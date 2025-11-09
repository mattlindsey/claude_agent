# ClaudeAgent

A Ruby gem for programmatically interacting with Claude AI via the Claude CLI. ClaudeAgent spawns and manages Claude CLI processes, enabling conversational AI capabilities with MCP (Model Context Protocol) server integration.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'claude_agent'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install claude_agent
```

## Prerequisites

- Ruby 2.7 or higher
- Claude CLI installed and configured on your system
- Valid Anthropic API key

## Usage

### Basic Usage

```ruby
require 'claude_agent'

# Create a new agent instance and connect
agent = ClaudeAgent::Agent.new(
  name: "MyAssistant",
  sandbox_dir: "./sandbox",
  system_prompt: "You are a helpful assistant"
).chat

# Send messages using ask()
response = agent.ask("Hello, can you help me write some Ruby code?")
puts response

# Close the connection when done
agent.close
```

**Note:** The `ask()` method streams Claude's response to stdout in real-time as it's generated, and returns the full accumulated response text as a string. This means you'll see the response appear character-by-character in your terminal, and can also capture the complete text in a variable for further processing.

### Configuration Options

The `new()` method accepts basic configuration:

- `name`: Agent identifier
- `sandbox_dir`: Working directory for Claude
- `system_prompt`: Initial system instructions
- `model`: Claude model to use

The `chat()` method accepts runtime configuration and starts the Claude process:

- `timezone`: Timezone for Claude context
- `skip_permissions`: Skip permission prompts (default: true)
- `verbose`: Enable verbose output
- `mcp_servers`: MCP server configuration
- `session_key`: Unique session identifier
- `resume_session`: Resume existing session

```ruby
# Initialize with basic config
agent = ClaudeAgent::Agent.new(
  name: "MyAssistant",
  sandbox_dir: "./sandbox",
  system_prompt: "You are a helpful coding assistant",
  model: "claude-sonnet-4-5-20250929"
)

# Connect with runtime config
agent.chat(
  timezone: "Eastern Time (US & Canada)",
  skip_permissions: true,
  verbose: true,
  mcp_servers: {
    headless_browser: {
      type: :http,
      url: "http://0.0.0.0:4567/mcp"
    }
  }
)

# Send messages
response = agent.ask("Write a Ruby function to calculate fibonacci numbers")
```

### With MCP Servers

By default, the agent connects to a `headless_browser` MCP server on `http://0.0.0.0:4567/mcp`. You can override this or add additional servers:

```ruby
# Use default MCP server (headless_browser on port 4567)
agent = ClaudeAgent::Agent.new(
  name: "WebAutomation",
  sandbox_dir: "./web_sandbox",
  system_prompt: "You are a web automation assistant"
).chat

response = agent.ask("Navigate to example.com and extract the page title")

# Or configure with multiple MCP servers
agent = ClaudeAgent::Agent.new(
  name: "WebAutomation",
  sandbox_dir: "./web_sandbox",
  system_prompt: "You are a web automation assistant"
).chat(
  mcp_servers: {
    headless_browser: {
      type: :http,
      url: "http://0.0.0.0:4567/mcp"
    },
    custom_server: {
      type: :stdio,
      command: "node",
      args: ["path/to/server.js"]
    }
  }
)
```

### Session Management

```ruby
# Start a new session
agent = ClaudeAgent::Agent.new(
  name: "MyAgent",
  sandbox_dir: "./sandbox"
).chat(
  session_key: "my-unique-session-id"
)

# Resume an existing session
agent = ClaudeAgent::Agent.new(
  name: "MyAgent",
  sandbox_dir: "./sandbox"
).chat(
  session_key: "my-unique-session-id",
  resume_session: true
)

response = agent.ask("Continue our previous conversation")
```

### Event Callbacks

The gem supports event callbacks for handling streaming events from Claude. You can register callbacks using `on_event` with either a method name or a block:

```ruby
class MyAgent < ClaudeAgent::Agent
  # Using a method name
  on_event :my_handler

  def my_handler(event)
    case event['type']
    when 'content_block_delta'
      # Handle streaming text
      text = event.dig('delta', 'text')
      print text if text
    when 'assistant'
      # Handle complete assistant messages
      puts "Message ID: #{event.dig('message', 'id')}"
    end
  end
end

# Or using a block
class MyBlockAgent < ClaudeAgent::Agent
  on_event do |event|
    puts "Received event type: #{event['type']}"
  end
end

# Initialize and use
agent = MyAgent.new(name: 'CallbackAgent', sandbox_dir: './sandbox').chat
agent.ask("Tell me a story")
agent.close
```

### Error Handling

```ruby
begin
  agent = ClaudeAgent::Agent.new(
    name: "ErrorHandlingAgent",
    sandbox_dir: "./sandbox"
  ).chat

  response = agent.ask("Hello!")
  puts response
rescue ClaudeAgent::Agent::ConnectionError => e
  puts "Failed to connect to Claude: #{e.message}"
ensure
  agent&.close
end
```

## Configuration

You can configure the gem globally:

```ruby
ClaudeAgent.configure do |config|
  config.anthropic_api_key = ENV['ANTHROPIC_API_KEY']
end
```

## Development

After checking out the repo, run:

```bash
bundle install
```

To run tests:

```bash
bundle exec rspec
```

To build the gem:

```bash
bundle exec rake build
```

To install the gem locally:

```bash
bundle exec rake install
```

## Contributing

Bug reports and pull requests are welcome on GitHub.

## License

The gem is available as open source under the terms of the [MIT License](LICENSE).
