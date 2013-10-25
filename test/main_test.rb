
gem 'test-unit', '>= 2'

require 'test/unit'
require 'rpeg_markdown_highlight'

p RpegMarkdownHighlight
p RpegMarkdownHighlight.hello
class RpegTest < Test::Unit::TestCase
  def test_hoge
    #RpegMarkdownHighlight.hello
    #p RpegMarkdownHighlight.methods
    #p RpegMarkdownHighlight.hello
    #RpegMarkdownHighlight.hello
    #assert_respond_to @markdown, :render
  end
end
