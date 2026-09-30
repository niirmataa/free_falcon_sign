# Source integrity checks for procedure regions and object-like aliases.
# This checker does not prove parser adequacy or numerical FFT correctness.
from pathlib import Path
import hashlib,json,os
src=Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])/'inputs/source'
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
pins={
 'falcon-keygen.c':'0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf',
 'falcon-fft.c':'06b573b636ae368dcda3eb4d89c3936ab31272123440d0d5362317e55d9ac063',
 'internal.h':'512629d3b79fa5bd74131ed2ecde06e1d157f5ac58db3f758db96b19131f1ba5',
}
for name,pin in pins.items(): assert sha(src/name)==pin,name
header=(src/'internal.h').read_text().splitlines(keepends=True)
aliases=[
 (553,'#define falcon_poly_add_fft3   falcon_poly_add3\n'),
 (578,'#define falcon_poly_sub_fft3   falcon_poly_sub3\n'),
 (588,'#define falcon_poly_neg_fft3   falcon_poly_neg3\n'),
]
for line,expected in aliases: assert header[line-1]==expected,(line,header[line-1])
regions=[
 ('falcon-fft.c',758,93,'falcon_FFT3'),
 ('falcon-fft.c',1077,18,'falcon_poly_muladj_fft3'),
 ('falcon-fft.c',1274,49,'falcon_poly_split_top_fft3'),
 ('falcon-fft.c',1325,46,'falcon_poly_split_deep_fft3'),
 ('falcon-keygen.c',7549,14,'LDL_dim2_fft3_keygen'),
 ('falcon-keygen.c',7564,28,'LDL_dim3_fft3_keygen'),
 ('falcon-keygen.c',7593,28,'ffLDL_inner_fft3_keygen'),
 ('falcon-keygen.c',7622,33,'ffLDL_depth1_fft3_keygen'),
 ('falcon-keygen.c',7656,27,'ffLDL_fft3_keygen'),
]
rows=[]
for filename,start,count,name in regions:
    lines=(src/filename).read_text().splitlines(keepends=True)
    text=''.join(lines[start-1:start-1+count])
    assert name+'(' in text and text.rstrip().endswith('}'),name
    rows.append({'file':filename,'first_line':int(start),'line_count':int(count),
                 'name':name,'sha256':hashlib.sha256(text.encode()).hexdigest()})
Path('FFT_PROCEDURE_BINDINGS.json').write_text(json.dumps({
 'scope':'source region and alias integrity only','source_pins':pins,
 'aliases':[{'line':int(line),'text':text} for line,text in aliases],
 'regions':rows},indent=2)+'\n')
print('FFT_PROCEDURE_BINDINGS_PASS',len(rows),'regions;',len(aliases),'aliases')
