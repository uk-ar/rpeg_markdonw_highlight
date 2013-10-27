#include "ruby.h"
#include "pmh_parser.h"

void hello(){
  printf("hello");
}

VALUE wrap_hello(self)
     VALUE self;
{
  hello();
  return Qnil;
}

static VALUE rb_renderer_render(VALUE self, VALUE text)
{
  pmh_element **elem;

  Check_Type(text, T_STRING);
  pmh_markdown_to_elements(RSTRING_PTR(text), pmh_EXT_NONE, &elem);
  pmh_sort_elements_by_pos(elem);

  pmh_element *cursor;
  cursor = elem[pmh_CODE];

  VALUE string;
  string = rb_str_new2("");
  ID id_normal_text = rb_intern("normal_text");
  ID id_code = rb_intern("code");

  unsigned long pos = 0;

  while (cursor != NULL)
    {
      VALUE tmp_v;
      // normal
      tmp_v = rb_str_new(RSTRING_PTR(text) + pos, cursor->pos);
      tmp_v = rb_funcall(self, id_normal_text, 1, tmp_v);
      rb_str_cat2(string, RSTRING_PTR(tmp_v));
      // code
      tmp_v = rb_str_new(RSTRING_PTR(text) + cursor->pos,
                         cursor->end - cursor->pos);
      tmp_v = rb_funcall(self, id_code, 1, tmp_v);
      rb_str_cat2(string, RSTRING_PTR(tmp_v));

      pos = cursor->end;
      cursor = cursor->next;
    }
  if (pos < RSTRING_LEN(text)){
    // normal
    VALUE tmp_v;
    tmp_v = rb_str_new(RSTRING_PTR(text) + pos, RSTRING_LEN(text) - pos);
    /* tmp_v = rb_str_new(RSTRING_PTR(text) + pos, cursor->pos); */
    tmp_v = rb_funcall(self, id_normal_text, 1, tmp_v);
    rb_str_cat2(string, RSTRING_PTR(tmp_v));
  }
  return string;
}

void Init_rpeg_markdown_highlight()
{
  VALUE module;
  VALUE class;

  module = rb_define_module("RpegMarkdownHighlight");
  rb_define_module_function(module, "hello", wrap_hello, 0);

  class = rb_define_class_under(module, "Renderer", rb_cObject);
  //rb_const_get(
  //rb_intern("RpegMarkdownHighlight::"));
  rb_define_method(class, "render", rb_renderer_render, 1);
}
