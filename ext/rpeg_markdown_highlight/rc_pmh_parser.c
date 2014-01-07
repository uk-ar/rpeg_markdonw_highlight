#include "ruby.h"
#include "pmh_parser.h"

void hello(){
  printf("hello");
}

VALUE wrap_hello(VALUE self)
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

static VALUE rb_markdown_render(VALUE self, VALUE text)
{
  /* grab char pointer to markdown input text */
  //VALUE text = rb_funcall(self, rb_intern("text"), 0);
  Check_Type(text, T_STRING);

  pmh_element **elem;
  pmh_markdown_to_elements(RSTRING_PTR(text), pmh_EXT_NONE, &elem);
  pmh_sort_elements_by_pos(elem);

  pmh_element *cursor;
  cursor = elem[pmh_CODE];
  VALUE array;
  array = rb_ary_new();
  unsigned long pos = 0;
  VALUE tmp_string;
  VALUE tmp_hash;

  while (cursor != NULL)
    {
      tmp_hash = rb_hash_new();
      if(cursor->pos != 0){
       // normal
       tmp_string = rb_str_new(RSTRING_PTR(text) + pos, cursor->pos);
       //tmp_v = rb_funcall(self, id_normal_text, 1, tmp_v);
       //rb_str_cat2(string, RSTRING_PTR(tmp_v));
       rb_hash_aset(tmp_hash, ID2SYM(rb_intern("type")), ID2SYM(rb_intern("not_code")));
       rb_hash_aset(tmp_hash, ID2SYM(rb_intern("string")), tmp_string);
       rb_ary_push(array, tmp_hash);
      }
      // code
      tmp_string = rb_str_new(RSTRING_PTR(text) + cursor->pos,
                         cursor->end - cursor->pos);
      //tmp_v = rb_funcall(self, id_code, 1, tmp_v);
      //rb_str_cat2(string, RSTRING_PTR(tmp_v));
      tmp_hash = rb_hash_new();
      rb_hash_aset(tmp_hash, ID2SYM(rb_intern("type")), ID2SYM(rb_intern("code")));
      rb_hash_aset(tmp_hash, ID2SYM(rb_intern("string")), tmp_string);
      rb_ary_push(array, tmp_hash);

      pos = cursor->end;
      cursor = cursor->next;
    }
  if (pos < RSTRING_LEN(text)){
    // normal
    VALUE tmp_string;
    VALUE tmp_hash = rb_hash_new();
    tmp_string = rb_str_new(RSTRING_PTR(text) + pos, RSTRING_LEN(text) - pos);
    /* tmp_v = rb_str_new(RSTRING_PTR(text) + pos, cursor->pos); */
    //tmp_v = rb_funcall(self, id_normal_text, 1, tmp_v);
    //rb_str_cat2(string, RSTRING_PTR(tmp_v));
    rb_hash_aset(tmp_hash, ID2SYM(rb_intern("type")), ID2SYM(rb_intern("not_code")));
    rb_hash_aset(tmp_hash, ID2SYM(rb_intern("string")), tmp_string);

    rb_ary_push(array, tmp_hash);
  }
  return array;
}

const char* elemNames[] = {"LINK", "AUTO_LINK_URL", "AUTO_LINK_EMAIL", "IMAGE", "CODE", "HTML", "HTML_ENTITY", "EMPH", "STRONG", "LIST_BULLET", "LIST_ENUMERATOR", "COMMENT", "H1", "H2", "H3", "H4", "H5", "H6", "BLOCKQUOTE", "VERBATIM", "HTMLBLOCK", "HRULE", "REFERENCE", "NOTE", "RAW_LIST", "RAW", "EXTRA_TEXT", "SEPARATOR", "NO_TYPE", "ALL"};

static VALUE rb_markdown_to_elements(VALUE self, VALUE text)
{
  /* grab char pointer to markdown input text */
  Check_Type(text, T_STRING);

  pmh_element **elem;
  pmh_markdown_to_elements(RSTRING_PTR(text), pmh_EXT_NONE, &elem);
  pmh_sort_elements_by_pos(elem);

  VALUE hash;
  hash = rb_hash_new();
  //unsigned long pos = 0;

  pmh_element *cursor;
  for(int i = pmh_LINK; i <= pmh_NOTE; i++){
    cursor = elem[i];
    VALUE array;
    array = rb_ary_new();
    while (cursor != NULL){
      VALUE tmp_hash;
      tmp_hash = rb_hash_new();
  /*     // normal */
  /*     //tmp_string = rb_str_new(RSTRING_PTR(text) + pos, cursor->pos); */
      rb_hash_aset(tmp_hash, ID2SYM(rb_intern("type")), ID2SYM(rb_intern(elemNames[i])));
  /*     rb_hash_aset(tmp_hash, ID2SYM(rb_intern("pos")), ULONG2NUM(cursor->pos)); */
  /*     rb_hash_aset(tmp_hash, ID2SYM(rb_intern("end")), ULONG2NUM(cursor->end)); */
  /*     rb_hash_aset(tmp_hash, ID2SYM(rb_intern("label")),rb_str_new2(cursor->label)); */
  /*     rb_hash_aset(tmp_hash, ID2SYM(rb_intern("address")),rb_str_new2(cursor->label)); */
  /*     //rb_hash_aset(tmp_hash, ID2SYM(rb_intern("string")), ID2SYM(rb_intern(h))); */
      rb_ary_push(array, rb_str_new2("hoge"));
  /*     /\* pos = cursor->end; *\/ */
      cursor = cursor->next;
    }
    rb_hash_aset(hash, ID2SYM(rb_intern(elemNames[i])), array);
  }
  pmh_free_elements(elem);
  return hash;
}

void Init_rpeg_markdown_highlight()
{
  VALUE module;
  VALUE renderer_class;
  VALUE markdown_class;
  VALUE element_class;

  module = rb_define_module("RpegMarkdownHighlight");
  rb_define_module_function(module, "to_elements",
                            rb_markdown_to_elements, 1);
  renderer_class = rb_define_class_under(module, "Renderer", rb_cObject);
  markdown_class = rb_define_class_under(module, "Markdown", rb_cObject);
  //element_class = rb_define_class_under(module, "Element", rb_cObject);
  //rb_const_get(
  //rb_intern("RpegMarkdownHighlight::"));
  rb_define_method(renderer_class, "render", rb_renderer_render, 1);
  rb_define_private_method(markdown_class, "_render", rb_markdown_render, 1);
  /* rb_define_private_method(element_class, "initialize", */
  /*                          rb_element_initialize, 1); */
}
