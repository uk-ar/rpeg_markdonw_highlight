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
  class Markdown
    attr_reader :text
    def initialize(text)
      @text = text
    end
    # def code
    # end
  end
  class Element
  end
end
