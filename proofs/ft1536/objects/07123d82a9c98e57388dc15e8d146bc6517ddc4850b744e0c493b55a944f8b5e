import Source3.KeygenHelpers

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryPin

def lines : List String :=
  ["static void\n", "ft_stable_binary_inplace_keygen(fpr *values, size_t n,\n",
  "\tfpr *scratch, uint32_t *bad)\n", "{\n", "\tsize_t hn, u;\n",
  "\tif (n == 1) {\n", "\t\tvalues[0] = ft_stable_positive_keygen(values[0], bad);\n",
  "\t\treturn;\n", "\t}\n", "\thn = n >> 1;\n",
  "\tfor (u = 0; u < hn; u ++) {\n", "\t\tfpr a, b, product, sum;\n",
  "\t\ta = ft_stable_positive_keygen(values[(u << 1) + 0], bad);\n",
  "\t\tb = ft_stable_positive_keygen(values[(u << 1) + 1], bad);\n",
  "\t\tsum = ft_stable_positive_keygen(fpr_add(a, b), bad);\n",
  "\t\tproduct = ft_stable_positive_keygen(fpr_mul(a, b), bad);\n",
  "\t\tscratch[u] = ft_stable_positive_keygen(fpr_half(sum), bad);\n",
  "\t\tscratch[u + hn] = ft_stable_positive_keygen(\n",
  "\t\t\tfpr_div(fpr_double(product), sum), bad);\n", "\t}\n",
  "\tmemcpy(values, scratch, n * sizeof *values);\n",
  "\tft_stable_binary_inplace_keygen(values, hn, scratch, bad);\n",
  "\tft_stable_binary_inplace_keygen(values + hn, hn, scratch, bad);\n", "}\n"]

theorem pinned : (Pinned.keygenLines.drop 7490).take 24=lines := by decide

end FT1536.Source3.StableBinaryPin

#print axioms FT1536.Source3.StableBinaryPin.pinned
