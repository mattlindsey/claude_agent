module ClaudeAgent
  class Configuration
    attr_accessor :anthropic_api_key

    def initialize
      @anthropic_api_key = nil
    end
  end
end
