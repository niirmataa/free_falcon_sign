import Source3.KeygenDecodeSyntax

namespace FT1536.Source3.KeygenPublicDecodeSource077
def sourceSha : String := "0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05"
def lines : List String := ["size_t\n","falcon_decode_18433(uint16_t *x, unsigned logn, const void *data, size_t len)\n","{\n","\tconst unsigned char *buf;\n","\tsize_t n, u;\n","\tuint32_t acc;\n","\tint acc_len;\n","\n","\tn = (size_t)3 << (logn - 1);\n","\tbuf = data;\n","\tu = 0;\n","\tacc = 0;\n","\tacc_len = 0;\n","\twhile (n > 0) {\n","\t\tif (u >= len) {\n","\t\t\treturn 0;\n","\t\t}\n","\t\tacc = (acc << 8) | buf[u ++];\n","\t\tacc_len += 8;\n","\t\tif (acc_len >= 15) {\n","\t\t\tuint32_t w;\n","\n","\t\t\tacc_len -= 15;\n","\t\t\tw = acc >> acc_len;\n","\t\t\tif (w >= 18433) {\n","\t\t\t\treturn 0;\n","\t\t\t}\n","\t\t\t*x ++ = (uint16_t)w;\n","\t\t\tn --;\n","\t\t\tacc &= (1U << acc_len) - 1U;\n","\t\t}\n","\t}\n","\tif (acc != 0) {\n","\t\treturn 0;\n","\t}\n","\treturn len;\n","}\n"]
end FT1536.Source3.KeygenPublicDecodeSource077
