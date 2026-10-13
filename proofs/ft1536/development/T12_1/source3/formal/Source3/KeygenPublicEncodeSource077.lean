import Source3.KeygenCodecSyntax

namespace FT1536.Source3.KeygenPublicEncodeSource077
def sourceSha : String := "0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05"
def lines : List String := ["size_t\n","falcon_encode_18433(void *out, size_t max_out_len,\n","\tconst uint16_t *x, unsigned logn)\n","{\n","\tunsigned char *buf;\n","\tsize_t n, u;\n","\tuint32_t acc;\n","\tint acc_len;\n","\n","\tn = (size_t)3 << (logn - 1);\n","\tbuf = out;\n","\tu = 0;\n","\tacc = 0;\n","\tacc_len = 0;\n","\twhile (n > 0) {\n","\t\tacc = (acc << 15) | (*x ++);\n","\t\tn --;\n","\t\tacc_len += 15;\n","\t\twhile (acc_len >= 8) {\n","\t\t\tacc_len -= 8;\n","\t\t\tif (out != NULL) {\n","\t\t\t\tif (u >= max_out_len) {\n","\t\t\t\t\treturn 0;\n","\t\t\t\t}\n","\t\t\t\tbuf[u] = (unsigned char)(acc >> acc_len);\n","\t\t\t}\n","\t\t\tu ++;\n","\t\t\tacc &= (1U << acc_len) - 1U;\n","\t\t}\n","\t}\n","\tif (acc_len > 0) {\n","\t\tif (out != NULL) {\n","\t\t\tif (u >= max_out_len) {\n","\t\t\t\treturn 0;\n","\t\t\t}\n","\t\t\tbuf[u] = (unsigned char)(acc << (8 - acc_len));\n","\t\t}\n","\t\tu ++;\n","\t}\n","\treturn u;\n","}\n"]
end FT1536.Source3.KeygenPublicEncodeSource077
