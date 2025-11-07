require "dotenv/load"

require_relative "claude_agent/version"
require_relative "claude_agent/configuration"
require_relative "claude_agent/agent"
require_relative "claude_agent/callback_support"

module ClaudeAgent
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.chat(...)
    agent = Agent.new
    agent.chat(...)
    agent
  end

  def self.chat_sample_agent(...)
    agent = ClaudeAgent::SampleAgent.new
    agent.chat(...)
    agent
  end
end
