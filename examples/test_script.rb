require 'claude_agent'

agent = ClaudeAgent.chat_sample_agent

response = agent.ask("Hello, can you help me write a short story?")
puts response

agent.close
