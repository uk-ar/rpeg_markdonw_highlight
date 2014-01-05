require 'rspec'
require 'rpeg_markdown_highlight'

RSpec.configure do |config|
  config.tty = true
end

class MyRenderer < RpegMarkdownHighlight::Renderer
  def normal_text(text)
    "<nt:#{text}>"
  end
  def code(text)
    "<code:#{text}>"
  end
end

describe RpegMarkdownHighlight::Renderer do
  it "render" do
    renderer = RpegMarkdownHighlight::Renderer.new
    renderer.render("12").should eq "12"
    renderer.render("12 `34`").should eq "12 `34`"
    renderer.render("12 `34` 56").should eq "12 `34` 56"
  end

  it "test_myrender" do
    renderer = MyRenderer.new

    renderer.render("12").should eq "<nt:12>"
    renderer.render("12 `34`").should eq "<nt:12 ><code:`34`>"
    renderer.render("12 `34` 56").should eq "<nt:12 ><code:`34`><nt: 56>"
  end

  it "render2" do
    markdown = RpegMarkdownHighlight::Markdown.new("12 `34`")
    expect(markdown.render).to eq ["12 ", "`34`"]
    #markdown.text{}.code{}.text{}.to_markdown
  end

end
