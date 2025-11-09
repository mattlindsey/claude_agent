# frozen_string_literal: true

require 'dotenv/load'
require 'reline'
require 'shellwords'
require 'open3'
require 'json'
require 'fileutils'
require 'securerandom'

require_relative 'claude_agent/version'
require_relative 'claude_agent/configuration'
require_relative 'claude_agent/agent'
require_relative 'claude_agent/callback_support'

module ClaudeAgent
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
