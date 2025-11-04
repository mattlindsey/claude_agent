require "spec_helper"

RSpec.describe ClaudeAgent do
  it "has a version number" do
    expect(ClaudeAgent::VERSION).not_to be nil
  end

  describe ".configure" do
    it "allows configuration" do
      ClaudeAgent.configure do |config|
        config.anthropic_api_key = "test_key"
      end

      expect(ClaudeAgent.configuration.anthropic_api_key).to eq("test_key")
    end
  end
end

RSpec.describe ClaudeAgent::Agent do
  describe "#initialize" do
    it "sets default attributes" do
      # Mock the process spawning to avoid actually starting Claude
      allow(Open3).to receive(:popen3).and_return([
        double(:stdin, close: true, closed?: false, puts: true, flush: true),
        double(:stdout, close: true, closed?: false),
        double(:stderr, close: true, closed?: false, read: ""),
        double(:wait_thr, alive?: true, pid: 12345, join: true)
      ])

      agent = ClaudeAgent::Agent.new(name: "TestAgent")

      expect(agent.name).to eq("TestAgent")
      expect(agent.sandbox_dir).to eq("./sandbox")
      expect(agent.model).to eq("claude-sonnet-4-5-20250929")
    end
  end
end
