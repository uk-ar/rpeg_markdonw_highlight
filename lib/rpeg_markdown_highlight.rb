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
    attr_reader :elements
    def initialize(text)
      # @text = text
      #self._render
      @elements = _render(text)
    end
    def on_code
      @elements = elements.map do |item|
        item[:string] = yield item[:string] if item[:type] == :code
        item
      end
      self
    end
    def on_not_code
      @elements = elements.map do |item|
        item[:string] = yield item[:string] if item[:type] == :not_code
        item
      end
      self
    end
    def to_markdown
      elements.map{ |item| item[:string]}.join
    end
  end
  # class Element
  # end
end
