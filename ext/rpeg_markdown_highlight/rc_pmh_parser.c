#include "ruby.h"

void hello(){
  printf("hello");
}

VALUE wrap_hello(self)
     VALUE self;
{
  hello();
  return Qnil;
}

void Init_rpeg_markdown_highlight()
{
  VALUE module;

  module = rb_define_module("RpegMarkdownHighlight");
  rb_define_module_function(module, "hello", wrap_hello, 0);
}
