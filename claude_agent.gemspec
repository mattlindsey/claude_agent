require_relative "lib/claude_agent/version"

Gem::Specification.new do |spec|
  spec.name          = "claude_agent"
  spec.version       = ClaudeAgent::VERSION
  spec.authors       = ["Matt Lindsey"]
  spec.email         = ["your.email@example.com"]

  spec.summary       = "Ruby gem for interacting with Claude AI agent via CLI"
  spec.description   = "A Ruby interface to Claude AI that spawns and manages Claude CLI processes, enabling programmatic interaction with Claude's conversational AI capabilities including MCP server integration."
  spec.homepage      = "https://github.com/yourusername/claude_agent"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yourusername/claude_agent"
  spec.metadata["changelog_uri"] = "https://github.com/yourusername/claude_agent/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir[
    "lib/**/*.rb",
    "LICENSE",
    "README.md",
    "CHANGELOG.md"
  ]

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "dotenv", "~> 2.8"

  # Development dependencies
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "standard", "~> 1.24"
end
