#!/usr/bin/env python3
"""Untrusted AST pretty-print transport; FprScaledBinding verifies its bytes in Lean."""
import json
from pathlib import Path
import sys

root=Path(__file__).resolve().parent.parent
label=sys.argv[1]
if Path(label).name!=label:
    raise ValueError('one job label required')
job=root/'.build/jobs'/label
receipt=json.loads((job/'RECEIPTS.json').read_text())
assert len(receipt)==1 and receipt[0]['accepted'] and receipt[0]['clean_log']
text=(job/receipt[0]['stdout']).read_text()
assert text.startswith('import Source3.FprPrimitives\nnamespace FT1536.Source3.FprScaledAST\n')
assert text.rstrip().endswith('end FT1536.Source3.FprScaledAST')
out=root/'formal/Source3/FprScaledAST.lean'
assert not out.exists(), 'do not overwrite an earlier source snapshot'
out.write_text(text)
print('UNTRUSTED_AST_CAPTURED',out)
