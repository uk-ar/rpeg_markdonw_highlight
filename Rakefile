require "bundler/gem_tasks"
require 'rake/clean'
require 'rake/extensiontask'

task :default => [:test]

# Ruby Extension
Rake::ExtensionTask.new('rpeg_markdown_highlight')

# Testing
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new("spec")
task :default => :spec
task :spec => :compile
