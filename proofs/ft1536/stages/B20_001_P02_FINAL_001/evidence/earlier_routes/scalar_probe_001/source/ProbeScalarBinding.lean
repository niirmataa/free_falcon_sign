import B20.C.ScalarParser
import B20.Fpr.ParsedPrograms
import B20.Pinned.Header
import B20.Pinned.ScalarSlices
set_option maxRecDepth 16384
set_option maxHeartbeats 8000000
open B20.C.Scalar B20.Pinned B20.Fpr.Parsed
example : (headerLines.drop 159).take 6 = negLines := by decide
example : tokenize (negChars.length + 1) negChars = some negTokens := by decide
example : parseFunctionTokens negTokens = some negProgram := by decide
#check negProgram
