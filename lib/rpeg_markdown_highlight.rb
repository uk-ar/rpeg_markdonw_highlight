require "rpeg_markdown_highlight/version"
require "rpeg_markdown_highlight.so"

module RpegMarkdownHighlight
  # Your code goes here...
  class Renderer
    def normal_text(text)
      #"<nt:#{text}>"
      text
    end
    def code(text)
      #"<code:#{text}>"
      text
    end
  end
end
