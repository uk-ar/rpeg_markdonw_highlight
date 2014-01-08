#include "ruby.h"
#include "pmh_parser.h"

const char* elemNames[] = {"link", "auto_link_url", "auto_link_email", "image", "code", "html", "html_entity", "emph", "strong", "list_bullet", "list_enumerator", "comment", "h1", "h2", "h3", "h4", "h5", "h6", "blockquote", "verbatim", "htmlblock", "hrule", "reference", "note", "raw_list", "raw", "extra_text", "separator", "no_type", "all"};

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
  int i;
  for(i = pmh_LINK; i <= pmh_NOTE; i++){
    cursor = elem[i];
    VALUE array;
    array = rb_ary_new();
    while (cursor != NULL){
      VALUE tmp_hash;
      tmp_hash = rb_hash_new();
      rb_hash_aset(tmp_hash, ID2SYM(rb_intern("type")), ID2SYM(rb_intern(elemNames[i])));
      rb_hash_aset(tmp_hash, ID2SYM(rb_intern("pos")), ULONG2NUM(cursor->pos));
      rb_hash_aset(tmp_hash, ID2SYM(rb_intern("end")), ULONG2NUM(cursor->end));
      /* rb_hash_aset(tmp_hash, ID2SYM(rb_intern("label")),rb_str_new2(cursor->label)); */
      /* rb_hash_aset(tmp_hash, ID2SYM(rb_intern("address")),rb_str_new2(cursor->label)); */
      rb_ary_push(array, tmp_hash);
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
}
