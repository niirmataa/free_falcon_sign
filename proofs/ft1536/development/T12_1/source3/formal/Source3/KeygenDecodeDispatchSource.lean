import Source3.KeygenDecodeSyntax

namespace FT1536.Source3.KeygenDecodeDispatchSource
def sourceSha : String := "0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05"
def lines : List String := ["size_t\n","falcon_decode_small(int16_t *x, unsigned logn,\n","\tint comp, unsigned q, const void *data, size_t len)\n","{\n","\tswitch (comp) {\n","\tcase FALCON_COMP_NONE:\n","\t\treturn uncompress_none(x, logn, q, data, len);\n","\tcase FALCON_COMP_STATIC:\n","\t\treturn uncompress_static(x, logn, q, data, len);\n","\tdefault:\n","\t\treturn 0;\n","\t}\n","}\n"]
end FT1536.Source3.KeygenDecodeDispatchSource
