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
    #expect(markdown.render).to eq ["12 ", "`34`"]
    expect(markdown.elements).to eq [{:type => :not_code, :string => "12 "},
                                   {:type => :code , :string => "`34`"}]
    expect(markdown.on_code{ |s| "<c:#{s}>"}.elements).
      to eq [{:type => :not_code, :string => "12 "},
             {:type => :code , :string => "<c:`34`>"}]
    markdown = RpegMarkdownHighlight::Markdown.new("12 `34`")
    expect(markdown.on_code{ |s| "<c:#{s}>"}.to_markdown).
      to eq "12 <c:`34`>"
    #markdown.text{}.code{}.text{}.to_markdown
  end

  it "render3" do
    markdown = RpegMarkdownHighlight::Markdown.new("`34` 12")
    #expect(markdown.render).to eq ["`34`", " 12"]
    expect(markdown.elements).to eq [{:type => :code , :string => "`34`"},
                                     {:type => :not_code, :string => " 12"}]
    expect(markdown.on_not_code{ |s| "<nc:#{s}>"}.elements).
      to eq [{:type => :code , :string => "`34`"},
             {:type => :not_code, :string => "<nc: 12>"}]
    markdown = RpegMarkdownHighlight::Markdown.new("`34` 12")
    expect(markdown.on_not_code{ |s| "<nc:#{s}>"}.to_markdown).
      to eq "`34`<nc: 12>"
    # expect(markdown.on_not_code{ |s| "foo ```bar``` baz"}.elements).
    #   to eq [{:type => :code , :string => "`34`"},
    #          {:type => :not_code, :string => "<nc: 12>"}]
    # expect(markdown.on_not_code{ |s| "foo ```bar```"}.elements).
    #   to eq [{:type => :code , :string => "`34`"},
    #          {:type => :not_code, :string => "<nc: 12>"}]
    # expect(markdown.on_not_code{ |s| "```bar``` baz"}.elements).
    #   to eq [{:type => :code , :string => "`34`"},
    #          {:type => :not_code, :string => "<nc: 12>"}]
    # expect(markdown.on_not_code{ |s| "```bar"}.elements).
    #   to eq [{:type => :code , :string => "`34`"},
    #          {:type => :not_code, :string => "<nc: 12>"}]
  end
  it "render3" do
    markdown = RpegMarkdownHighlight.to_elements("`34` 12") 
    expect(markdown).to eq(:LINK=>[], :AUTO_LINK_URL=>[], :AUTO_LINK_EMAIL=>[], :IMAGE=>[], :CODE=>[], :HTML=>[], :HTML_ENTITY=>[], :EMPH=>[], :STRONG=>[], :LIST_BULLET=>[], :LIST_ENUMERATOR=>[], :COMMENT=>[], :H1=>[], :H2=>[], :H3=>[], :H4=>[], :H5=>[], :H6=>[], :BLOCKQUOTE=>[], :VERBATIM=>[], :HTMLBLOCK=>[], :HRULE=>[], :REFERENCE=>[], :NOTE=>[])
  end
end
