# frozen_string_literal: true

require 'claude_agent'

class MyAgent < ClaudeAgent::Agent
  on_event :my_handler

  def my_handler(event)
    puts 'Event triggered'
    puts "Received event: #{event.dig('message', 'id')}"
  end

  # Or using a block:
  #
  # on_event do |event|
  #  puts "Block event triggered"
  #  puts "Received event in block: #{event.dig("message", "id")}"
  # end
end

ClaudeAgent.configure do |config|
  config.anthropic_api_key = ENV['ANTHROPIC_API_KEY'] # Not strictly necessary with claude installed
  config.system_prompt = 'You are a helpful AI human resources assistant.'
  config.model = 'claude-sonnet-4-5-20250929'
  config.sandbox_dir = './hr_sandbox'
end

agent = MyAgent.new(name: 'HR-Agent').chat

puts agent.ask('Hello, can you help me write a resume?')

agent.close
