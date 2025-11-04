require "dotenv/load"

require_relative "claude_agent/version"
require_relative "claude_agent/configuration"
require_relative "claude_agent/agent"

module ClaudeAgent
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
