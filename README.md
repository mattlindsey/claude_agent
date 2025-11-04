# ClaudeAgent

A Ruby gem for programmatically interacting with Claude AI via the Claude CLI. ClaudeAgent spawns and manages Claude CLI processes, enabling conversational AI capabilities with MCP (Model Context Protocol) server integration.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'claude_agent'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install claude_agent
```

## Prerequisites

- Ruby 2.7 or higher
- Claude CLI installed and configured on your system
- Valid Anthropic API key

## Usage

### Basic Usage

```ruby
require 'claude_agent'

# Create a new agent instance
agent = ClaudeAgent::Agent.new(
  name: "MyAssistant",
  sandbox_dir: "./sandbox",
  system_prompt: "You are a helpful assistant"
)

# Chat with Claude
response = agent.chat("Hello, can you help me write some Ruby code?")
puts response

# Close the connection when done
agent.close
```

### Configuration Options

```ruby
agent = ClaudeAgent::Agent.new(
  name: "MyAssistant",
  sandbox_dir: "./sandbox",
  timezone: "Eastern Time (US & Canada)",
  skip_permissions: true,
  verbose: true,
  system_prompt: "You are a helpful coding assistant",
  model: "claude-sonnet-4-5-20250929",
  mcp_servers: {
    headless_browser: {
      type: :http,
      url: "http://0.0.0.0:4567/mcp"
    }
  }
)
```

### With MCP Servers

```ruby
# Configure with multiple MCP servers
agent = ClaudeAgent::Agent.new(
  system_prompt: "You are a web automation assistant",
  mcp_servers: {
    headless_browser: {
      type: :http,
      url: "http://0.0.0.0:4567/mcp"
    },
    custom_server: {
      type: :stdio,
      command: "node",
      args: ["path/to/server.js"]
    }
  }
)

response = agent.chat("Navigate to example.com and extract the page title")
```

### Session Management

```ruby
# Start a new session
agent = ClaudeAgent::Agent.new(
  session_key: "my-unique-session-id"
)

# Resume an existing session
agent = ClaudeAgent::Agent.new(
  session_key: "my-unique-session-id",
  resume_session: true
)
```

### Error Handling

```ruby
begin
  agent = ClaudeAgent::Agent.new
  response = agent.chat("Hello!")
rescue ClaudeAgent::ConnectionError => e
  puts "Failed to connect to Claude: #{e.message}"
ensure
  agent&.close
end
```

## Configuration

You can configure the gem globally:

```ruby
ClaudeAgent.configure do |config|
  config.anthropic_api_key = ENV['ANTHROPIC_API_KEY']
end
```

## Development

After checking out the repo, run:

```bash
bundle install
```

To run tests:

```bash
bundle exec rspec
```

To build the gem:

```bash
bundle exec rake build
```

To install the gem locally:

```bash
bundle exec rake install
```

## Contributing

Bug reports and pull requests are welcome on GitHub.

## License

The gem is available as open source under the terms of the [MIT License](LICENSE).



Next Steps

  To build and test the gem:

  # Install dependencies
  bundle install

  # Run tests
  bundle exec rspec

  # Build the gem
  bundle exec rake build

  # Install locally
  bundle exec rake install

  To use in another project:

  # In Gemfile
  gem 'claude_agent', path: '/path/to/claude_agent'

  # Or after publishing to RubyGems
  gem 'claude_agent'

  The gem is now ready for development, testing, and eventual publication to RubyGems.org!
