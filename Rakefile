require "bundler/gem_tasks"
require 'rake/clean'
require 'rake/extensiontask'

task :default => [:test]

# Ruby Extension
Rake::ExtensionTask.new('rpeg_markdown_highlight')

# Testing
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/*_test.rb'
  #t.verbose = true
  #t.warning = false
end

task 'test' => :compile
