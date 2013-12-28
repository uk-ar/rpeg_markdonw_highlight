# -*- coding: utf-8 -*-
# A sample Guardfile
# More info at https://github.com/guard/guard#readme
guard 'bundler' do
  watch('Gemfile')
  # Uncomment next line if Gemfile contain `gemspec' command
  # watch(/^.+\.gemspec/)
end

guard 'rake', :task => 'compile' do
  watch(%r{^ext/(.+)\.[ch]$})
  #watch(%r{^test/(.+)\.rb$})
  #watch(%r{^my_file.c})
  callback(:start_begin){ puts "my rake start" }
  #callback(:start_end){ "my end" }
end

# guard :test do
#   watch(%r{^test/.+_test\.rb$})
#   watch('test/test_helper.rb')  { 'test' }

#   # Non-rails
#   watch(%r{^lib/(.+)\.rb$}) { |m| "test/#{m[1]}_test.rb" }

#   # ext
#   watch(%r{^lib/(.+)\.bundle$}) { 'test' }
# end

guard :rspec, cmd: 'rspec -o ./spec_results.log', emacs: './spec_results.log' do
# guard :rspec do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

