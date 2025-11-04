require 'claude_agent'

agent = ClaudeAgent::Agent.new(
  name: "MyAssistant",
  sandbox_dir: "./sandbox",
  system_prompt: "You are a helpful assistant"
)

response = agent.chat("Hello, can you help me write some Ruby code?")
puts response

agent.close
