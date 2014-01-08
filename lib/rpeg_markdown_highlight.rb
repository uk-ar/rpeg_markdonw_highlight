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
      #self._render
      # @elements = _render(text)
    end
    def elements
      to_elements(text)
    end
    def on_code
      return self if elements[:code].empty?
      old_pos = 0
      @text = elements[:code].map do |item|
        not_code = @text.slice(old_pos...(item[:pos])) unless
          item[:pos] == 0
        code = yield(@text.slice(item[:pos]...item[:end]))
        old_pos = item[:end]
        [not_code, code]
      end.push(unless old_pos == text.length then @text.slice(old_pos, text.length) end).flatten.join
      self
    end
    def on_not_code
      old_pos = 0
      @text = elements[:code].map do |item|
        not_code = yield(@text.slice(old_pos...(item[:pos]))) unless
          item[:pos] == 0
        code = @text.slice(item[:pos]...item[:end])
        old_pos = item[:end]
        [not_code, code]
      end.push(unless old_pos == text.length then yield(@text.slice(old_pos, text.length)) end).flatten.join
      self
    end
    # def to_markdown
    #   elements.map{ |item| item[:string]}.join
    # end
  end
  # class Element
  # end
end
