# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2025-11-04

### Added
- Initial release of ClaudeAgent gem
- Core Agent class for managing Claude CLI processes
- Support for MCP (Model Context Protocol) server integration
- Configuration management for API keys
- Sandbox directory support for isolated execution
- Session management and resumption capabilities
- Stream-based JSON communication with Claude CLI
- Error handling with custom ConnectionError class
- Basic chat interface for conversational AI interactions

### Features
- Spawn and manage Claude CLI processes programmatically
- Configure multiple MCP servers (HTTP and stdio)
- Real-time response streaming
- Verbose logging support
- Customizable system prompts
- Model selection support

[Unreleased]: https://github.com/yourusername/claude_agent/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/yourusername/claude_agent/releases/tag/v0.1.0
