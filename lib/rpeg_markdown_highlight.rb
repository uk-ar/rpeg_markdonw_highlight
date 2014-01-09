require "rpeg_markdown_highlight/version"
require "rpeg_markdown_highlight.so"

module RpegMarkdownHighlight
  class Renderer
    def normal_text(text)
      text
    end
    def code(text)
      text
    end
  end
  #todo render to module method
  class Markdown
    include RpegMarkdownHighlight
    attr_reader :text
    def initialize(text)
      @text = text
    end
    def _make_array(target)
      old_pos = 0
      string_assoc = to_elements(text)[target].map do |item|
        not_element = [false, @text.slice(old_pos...(item[:pos]))] unless item[:pos] == 0
        element = [true,@text.slice(item[:pos]...item[:end])]
        old_pos = item[:end]
        [not_element, element]
      end.flatten(1).compact
      string_assoc.push([false, @text.slice(old_pos, text.length)]) unless old_pos == text.length
      string_assoc
    end
    def on_code
      Markdown.new(_make_array(:code).map{|cond,string| cond ? yield(string) : string }.join)
    end
    def on_not_code
      Markdown.new(_make_array(:code).map{|cond,string| !cond ? yield(string) : string }.join)
    end
    def on_link
      Markdown.new(_make_array(:link).map{|cond,string| cond ? yield(string) : string }.join)
    end
  end
  # class Element
  # end
end
