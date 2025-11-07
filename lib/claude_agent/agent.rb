require "reline"
require "shellwords"
require "open3"
require "json"
require "fileutils"
require "securerandom"
require_relative "callback_support"

module ClaudeAgent
  class Agent
    include CallbackSupport

    class ConnectionError < StandardError; end

    attr_reader :name, :sandbox_dir, :timezone, :skip_permissions, :verbose,
                :system_prompt, :mcp_servers, :model, :session_key,
                :context, :conversation_history

    # Users can register callbacks in two ways:
    # class MyAgent < ClaudeAgent::Agent
    #   # Using a method name
    #   on_event :my_handler
    #
    #   def my_handler(event)
    #     text = event.dig("delta", "text")
    #     # Process the streaming text
    #   end
    # end
    #
    # Or using a block
    # class MyAgent < ClaudeAgent::Agent
    #   on_event do |event|
    #     text = event.dig("delta", "text")
    #     # Process the streaming text
    #   end
    # end

    def initialize(name: "MyName", sandbox_dir: "./sandbox", model: "claude-sonnet-4-5-20250929")
      @name = name
      @sandbox_dir = sandbox_dir
      @model = model
      @stdin = nil
      @stdout = nil
      @stderr = nil
      @wait_thr = nil
    end
    
    def chat(
      name: "MyName",
      sandbox_dir: "./sandbox",
      timezone: "Eastern Time (US & Canada)",
      skip_permissions: true,
      verbose: true,
      system_prompt: "prompt",
      mcp_servers: {headless_browser: {type: :http, url: "http://0.0.0.0:4567/mcp"}},
      model: "claude-sonnet-4-5-20250929",
      session_key: nil,
      resume_session: false,
      **additional_context
    )

      @name = name
      @sandbox_dir = sandbox_dir
      @timezone = timezone
      @skip_permissions = skip_permissions
      @verbose = verbose
      @system_prompt = system_prompt
      @mcp_servers = mcp_servers
      @model = model
      @session_key = session_key
      @resume_session = resume_session
      @context = additional_context
      @conversation_history = []

      ensure_sandbox_exists

      command = build_claude_command

      @stdin, @stdout, @stderr, @wait_thr = spawn_process(command, @sandbox_dir)

      # Check if process is alive
      sleep 0.5
      unless @wait_thr.alive?
        error_output = @stderr.read
        raise ConnectionError, "Claude process failed to start. Error: #{error_output}"
      end

      puts "Claude process started successfully (PID: #{@wait_thr.pid})"
      self
    end

    def ask(message) 
      return if message.nil? || message.strip.empty?

      send_message(message)
      read_response
    rescue => e
      raise
    end

    def close
      return unless @stdin

      @stdin.close unless @stdin.closed?
      @stdout.close unless @stdout.closed?
      @stderr.close unless @stderr.closed?
      @wait_thr.join if @wait_thr
    ensure
      @stdin = nil
      @stdout = nil
      @stderr = nil
      @wait_thr = nil
    end

    private

    def ensure_sandbox_exists
      return if File.directory?(@sandbox_dir)

      puts "Creating sandbox directory: #{@sandbox_dir}"
      FileUtils.mkdir_p(@sandbox_dir)
    end

    def build_claude_command
      puts "Building Claude command..."

      cmd = "claude -p --dangerously-skip-permissions --output-format=stream-json --input-format=stream-json"
      cmd += " --verbose" if @verbose
      cmd += " --system-prompt #{Shellwords.escape(@system_prompt)}"
      cmd += " --model #{Shellwords.escape(@model)}"

      if @mcp_servers
        mcp_config_json = build_mcp_config(@mcp_servers).to_json
        cmd += " --mcp-config #{Shellwords.escape(mcp_config_json)}"
      end

      cmd += " --setting-sources \"\""
      cmd += " --resume #{Shellwords.escape(@session_key)}" if @resume_session && @session_key
      cmd
    end

    def build_mcp_config(mcp_servers)
      servers = mcp_servers.transform_keys { |k| k.to_s.gsub("_", "-") }
      {mcpServers: servers}
    end

    def spawn_process(command, sandbox_dir)
      puts "Spawning process with command: #{command}"

      command_to_run = if $stdout.tty? && File.exist?("./stream.rb")
        "#{command} | tee >(ruby ./stream.rb >/dev/tty)"
      else
        command
      end

      stdin, stdout, stderr, wait_thr = Open3.popen3("bash", "-lc", command_to_run, chdir: sandbox_dir)
      [stdin, stdout, stderr, wait_thr]
    end

    def send_message(content, session_id = nil)
      raise ConnectionError, "Not connected to Claude" unless @stdin

      unless @wait_thr&.alive?
        error_output = @stderr&.read || "Unknown error"
        raise ConnectionError, "Claude process has died. Error: #{error_output}"
      end

      message_json = {
        type: "user",
        message: {role: "user", content: content},
        session_id: session_id
      }.compact

      @stdin.puts JSON.generate(message_json)
      @stdin.flush
    rescue => e
      raise
    end

    def read_response
      response_text = ""

      loop do
        unless @wait_thr.alive?
          error_output = @stderr.read
          raise ConnectionError, "Claude process died while reading response. Error: #{error_output}"
        end

        ready = IO.select([@stdout, @stderr], nil, nil, 0.1)

        if ready
          if ready[0].include?(@stderr)
            error_line = @stderr.gets
            $stderr.puts error_line if error_line
          end

          if ready[0].include?(@stdout)
            line = @stdout.gets
            break unless line

            line = line.strip
            next if line.empty?

            begin
              event = JSON.parse(line)

              case event["type"]
              when "system"
                next
              when "assistant"
                if event.dig("message", "content")
                  content = event["message"]["content"]
                  if content.is_a?(Array)
                    content.each do |block|
                      if block["type"] == "text" && block["text"]
                        text = block["text"]
                        response_text += text
                        puts text
                      end
                    end
                  elsif content.is_a?(String)
                    response_text += content
                    puts content
                  end
                end
              when "content_block_delta"
                if event.dig("delta", "text")
                  text = event["delta"]["text"]
                  response_text += text
                  print text
                end
              when "result"
                break
              when "error"
                puts "[ERROR] #{event["message"]}"
                break
              end
              run_callbacks(event)
            rescue JSON::ParserError => e
              $stderr.puts "Failed to parse JSON: #{line[0..100]}"
              next
            end
          end
        end
      end

      puts
      response_text
    end
  end

  class SampleAgent < Agent
  # Example of a new Agent subclass

    def initialize
      super(name: "SampleAgent", sandbox_dir: "./coding_sandbox", model: "claude-sonnet-4-5-20250929")
    end

    on_event :on_event_callback
    # after_event :method_name

    def on_event_callback event
      puts "Event triggered!"
    end
  end

end
