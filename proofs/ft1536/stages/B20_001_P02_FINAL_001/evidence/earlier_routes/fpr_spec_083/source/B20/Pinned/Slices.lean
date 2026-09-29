namespace B20.Pinned
def urshChars : List Char := "static inline uint64_t\nfpr_ursh(uint64_t x, int n)\n{\n\tx ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);\n\treturn x >> (n & 31);\n}\n".toList
def urshTokens : List (List Char) := ["static", "inline", "uint64_t", "fpr_ursh", "(", "uint64_t", "x", ",", "int", "n", ")", "{", "x", "^=", "(", "x", "^", "(", "x", ">>", "32", ")", ")", "&", "-", "(", "uint64_t", ")", "(", "n", ">>", "5", ")", ";", "return", "x", ">>", "(", "n", "&", "31", ")", ";", "}"].map String.toList
def irshChars : List Char := "static inline int64_t\nfpr_irsh(int64_t x, int n)\n{\n\tx ^= (x ^ (x >> 32)) & -(int64_t)(n >> 5);\n\treturn x >> (n & 31);\n}\n".toList
def irshTokens : List (List Char) := ["static", "inline", "int64_t", "fpr_irsh", "(", "int64_t", "x", ",", "int", "n", ")", "{", "x", "^=", "(", "x", "^", "(", "x", ">>", "32", ")", ")", "&", "-", "(", "int64_t", ")", "(", "n", ">>", "5", ")", ";", "return", "x", ">>", "(", "n", "&", "31", ")", ";", "}"].map String.toList
def ulshChars : List Char := "static inline uint64_t\nfpr_ulsh(uint64_t x, int n)\n{\n\tx ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);\n\treturn x << (n & 31);\n}\n".toList
def ulshTokens : List (List Char) := ["static", "inline", "uint64_t", "fpr_ulsh", "(", "uint64_t", "x", ",", "int", "n", ")", "{", "x", "^=", "(", "x", "^", "(", "x", "<<", "32", ")", ")", "&", "-", "(", "uint64_t", ")", "(", "n", ">>", "5", ")", ";", "return", "x", "<<", "(", "n", "&", "31", ")", ";", "}"].map String.toList
end B20.Pinned
