require 'claude_agent'

class MyAgent < ClaudeAgent::Agent
  on_event :my_handler
  
  def my_handler(event)
    puts "Event triggered"
    puts "Received event: #{event.dig("message", "id")}"
  end
end

agent = MyAgent.new
agent.chat

response = agent.ask("Hello, can you help me write a resume?")
puts response

agent.close
