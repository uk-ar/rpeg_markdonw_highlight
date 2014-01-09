# -*- coding: utf-8 -*-
require 'rspec'
require 'rpeg_markdown_highlight'

RSpec.configure do |config|
  config.tty = true
end

describe RpegMarkdownHighlight::Renderer do
  it "on_code" do
    markdown = RpegMarkdownHighlight::Markdown.new("12 `あ`")
    expect(markdown.on_code{ |s| "<c:#{s}>"}.text).to eq "12 <c:`あ`>"
    markdown = RpegMarkdownHighlight::Markdown.new("`あ` 12")
    expect(markdown.on_code{ |s| "<c:#{s}>"}.text).to eq "<c:`あ`> 12"
    markdown = RpegMarkdownHighlight::Markdown.new("12")
    expect(markdown.on_code{ |s| "<c:#{s}>"}.text).to eq "12"
    markdown = RpegMarkdownHighlight::Markdown.new("`あ`")
    expect(markdown.on_code{ |s| "<c:#{s}>"}.text).to eq "<c:`あ`>"
  end
  it "on_not_code" do
    markdown = RpegMarkdownHighlight::Markdown.new("`あ` 12")
    expect(markdown.on_not_code{ |s| "<nc:#{s}>"}.text).to eq "`あ`<nc: 12>"
    markdown = RpegMarkdownHighlight::Markdown.new("12 `あ`")
    expect(markdown.on_not_code{ |s| "<nc:#{s}>"}.text).to eq "<nc:12 >`あ`"
    markdown = RpegMarkdownHighlight::Markdown.new("12")
    expect(markdown.on_not_code{ |s| "<nc:#{s}>"}.text).to eq "<nc:12>"
    markdown = RpegMarkdownHighlight::Markdown.new("`あ`")
    expect(markdown.on_not_code{ |s| "<nc:#{s}>"}.text).to eq "`あ`"
    # expect(markdown.on_not_code{ |s| "foo ```bar``` baz"}.elements).
    #   to eq [{:type => :code , :string => "`あ`"},
    #          {:type => :not_code, :string => "<nc: 12>"}]
    # expect(markdown.on_not_code{ |s| "foo ```bar```"}.elements).
    #   to eq [{:type => :code , :string => "`あ`"},
    #          {:type => :not_code, :string => "<nc: 12>"}]
    # expect(markdown.on_not_code{ |s| "```bar``` baz"}.elements).
    #   to eq [{:type => :code , :string => "`あ`"},
    #          {:type => :not_code, :string => "<nc: 12>"}]
    # expect(markdown.on_not_code{ |s| "```bar"}.elements).
    #   to eq [{:type => :code , :string => "`あ`"},
    #          {:type => :not_code, :string => "<nc: 12>"}]
  end
  it "on_code & on_not_code" do
    markdown = RpegMarkdownHighlight::Markdown.new("`あ` 12")
    expect(markdown.on_not_code{ |s| "<nc:#{s}>"}
             .on_code{ |s| "<c:#{s}>"}.text).to eq "<c:`あ`><nc: 12>"
    markdown = RpegMarkdownHighlight::Markdown.new("12 `あ`")
    expect(markdown.on_not_code{ |s| "<nc:#{s}>"}
             .on_code{ |s| "<c:#{s}>"}.text).to eq "<nc:12 ><c:`あ`>"
    markdown = RpegMarkdownHighlight::Markdown.new("12")
    expect(markdown.on_not_code{ |s| "<nc:#{s}>"}
             .on_code{ |s| "<c:#{s}>"}.text).to eq "<nc:12>"
    markdown = RpegMarkdownHighlight::Markdown.new("`あ`")
    expect(markdown.on_not_code{ |s| "<nc:#{s}>"}
             .on_code{ |s| "<c:#{s}>"}.text).to eq "<c:`あ`>"
  end
  it "on_link" do
    markdown = RpegMarkdownHighlight::Markdown.new("12 [hoge](http://example.com)")
    expect(markdown._make_array(:link)).to eq [[false, "12 "], [true, "[hoge](http://example.com)"]]
    expect(markdown.on_link{ |s| "<l:#{s}>"}.text).to eq "12 <l:[hoge](http://example.com)>"
    
    #https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#wiki-links
    # markdown = RpegMarkdownHighlight::Markdown.new("12 http://example.com")
    # expect(markdown._make_array(:link)).to eq [[false, "12 "], [true, "http://example.com"]]
    # expect(markdown.on_link{ |s| "<l:#{s}>"}.text).to eq "12 <l:http://example.com>"
  end
  it "to_elements" do
    markdown = RpegMarkdownHighlight.to_elements("`あ` 12")
    expect(markdown).to eq(:link=>[], :auto_link_url=>[], :auto_link_email=>[], :image=>[], :code=>[{:type=>:code, :pos=>0, :end=>3}], :html=>[], :html_entity=>[], :emph=>[], :strong=>[], :list_bullet=>[], :list_enumerator=>[], :comment=>[], :h1=>[], :h2=>[], :h3=>[], :h4=>[], :h5=>[], :h6=>[], :blockquote=>[], :verbatim=>[], :htmlblock=>[], :hrule=>[], :reference=>[], :note=>[])
    markdown = RpegMarkdownHighlight.to_elements("[ref][1]\n[1]: http://slashdot")
    expect(markdown).to eq(:link=>[], :auto_link_url=>[{:type=>:auto_link_url, :pos=>14, :end=>29, :address=>"http://slashdot"}], :auto_link_email=>[], :image=>[], :code=>[], :html=>[], :html_entity=>[], :emph=>[], :strong=>[], :list_bullet=>[], :list_enumerator=>[], :comment=>[], :h1=>[], :h2=>[], :h3=>[], :h4=>[], :h5=>[], :h6=>[], :blockquote=>[], :verbatim=>[], :htmlblock=>[], :hrule=>[], :reference=>[], :note=>[])
    markdown = RpegMarkdownHighlight.to_elements("[ref][http://slashdot]")
    expect(markdown).to eq(:link=>[], :auto_link_url=>[{:type=>:auto_link_url, :pos=>6, :end=>22, :address=>"http://slashdot]"}], :auto_link_email=>[], :image=>[], :code=>[], :html=>[], :html_entity=>[], :emph=>[], :strong=>[], :list_bullet=>[], :list_enumerator=>[], :comment=>[], :h1=>[], :h2=>[], :h3=>[], :h4=>[], :h5=>[], :h6=>[], :blockquote=>[], :verbatim=>[], :htmlblock=>[], :hrule=>[], :reference=>[], :note=>[])
    markdown = RpegMarkdownHighlight.to_elements("[1]: http://slashdot")
    expect(markdown).to eq(:link=>[], :auto_link_url=>[], :auto_link_email=>[], :image=>[], :code=>[], :html=>[], :html_entity=>[], :emph=>[], :strong=>[], :list_bullet=>[], :list_enumerator=>[], :comment=>[], :h1=>[], :h2=>[], :h3=>[], :h4=>[], :h5=>[], :h6=>[], :blockquote=>[], :verbatim=>[], :htmlblock=>[], :hrule=>[], :reference=>[{:type=>:reference, :pos=>0, :end=>20, :label=>"1", :address=>"http://slashdot"}], :note=>[])
  end
end
