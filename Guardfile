# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'bundler' do
  watch('Gemfile')
  # Uncomment next line if Gemfile contain `gemspec' command
  # watch(/^.+\.gemspec/)
end

guard 'rake', :task => 'test' do
  watch(%r{^ext/(.+)\.[ch]$})
  watch(%r{^test/(.+)\.rb$})
  #watch(%r{^my_file.c})
end
