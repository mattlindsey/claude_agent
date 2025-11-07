require 'claude_agent'

class MyAgent < ClaudeAgent::Agent
  on_event :my_handler
  
  def my_handler(event)
    text = event.dig("delta", "text")
    # Process the streaming text
    # puts text if text
    puts "Event triggered"
  end
end

agent = MyAgent.new
agent.chat

response = agent.ask("Hello, can you help me write a resume?")
puts response

agent.close
