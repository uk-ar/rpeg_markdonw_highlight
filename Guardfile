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

guard :test do
  watch(%r{^test/.+_test\.rb$})
  watch('test/test_helper.rb')  { 'test' }

  # Non-rails
  watch(%r{^lib/(.+)\.rb$}) { |m| "test/#{m[1]}_test.rb" }

  # ext
  watch(%r{^lib/(.+)\.bundle$}) { 'test' }

  def stdout_begin
    puts "my test start"
    @stdout_old = $stdout.dup        # 元の $stdout を保存する
    $stdout.reopen("resutl.txt")      # $stdout を /tmp/foo にリダイレクトする
    puts "redirect"
  end

  def stdout_end
    $stdout.flush                   # 念のためフラッシュする
    $stdout.reopen @stdout_old       # 元に戻す
    puts "my test end"
  end

  callback([:run_on_modifications_begin, :start_begin, :run_all_begin]) do
    stdout_begin
  end

  callback([:run_on_modifications_end, :start_end, :run_all_end]) do
    stdout_end
  end

end
