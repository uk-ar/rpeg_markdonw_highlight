gem 'test-unit', '>= 2'

require 'test/unit'
require 'rpeg_markdown_highlight'

class MyRenderer < RpegMarkdownHighlight::Renderer
  def normal_text(text)
    "<nt:#{text}>"
  end
  def code(text)
    "<code:#{text}>"
  end
end

class RpegTest < Test::Unit::TestCase
  def setup
  end

  def test_render
    renderer = RpegMarkdownHighlight::Renderer.new
    assert_equal "12", renderer.render("12")
    assert_equal "12 `34`", renderer.render("12 `34`")
    assert_equal "12 `34` 56", renderer.render("12 `34` 56")
  end

  def test_myrender
    renderer = MyRenderer.new
    assert_equal "<nt:12>", renderer.render("12")
    assert_equal "<nt:12 ><code:`34`>", renderer.render("12 `34`")
    assert_equal "<nt:12 ><code:`34`><nt: 56>", renderer.render("12 `34` 56")
    #assert_equal "<nt:fuga>", renderer.render("fuga")
    assert_equal "<t:fuga>", renderer.render("fuga")
  end
end
