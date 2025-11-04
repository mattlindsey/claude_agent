require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc "Run RuboCop/Standard linter"
task :lint do
  sh "bundle exec standardrb"
end

desc "Auto-fix RuboCop/Standard issues"
task :lint_fix do
  sh "bundle exec standardrb --fix"
end

desc "Run all checks (tests and linting)"
task check: [:spec, :lint]
