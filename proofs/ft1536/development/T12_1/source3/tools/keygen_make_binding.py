#!/usr/bin/env python3
"""Generate compositional syntax witnesses, each checked by Lean's parser.

This is a string/AST organizer, not a mathematical checker or callee model.
Read only the live pinned Extra/c source; never overwrite a sealed producer.
"""
import hashlib
import json
import re
import sys

from keygen_make_tokens import ROOT, REPO, SOURCE_SHA, REGIONS, MACROS, preprocess

OPS = {'||':('lor',1),'&&':('land',2),'|':('bor',3),'^':('bxor',4),'&':('band',5),
       '==':('eq',6),'!=':('ne',6),'<':('lt',7),'<=':('le',7),'>':('gt',7),'>=':('ge',7),
       '<<':('shl',8),'>>':('shr',8),'+':('add',9),'-':('sub',9),'*':('mul',10),'/':('div',10),'%':('rem',10)}
TYPES = {'void':'void','int':'i32','unsigned':'u32','int16_t':'i16','uint16_t':'u16',
         'uint64_t':'u64','uint32_t':'u32','size_t':'size','long':'long','fpr':'fpr','falcon_keygen':'context'}
CALLEES = dict(zip(['MKN','rng_ready','sample_true_ternary_secret','mod2_res_ternary',
    'poly_small_to_fp','falcon_FFT3','falcon_FFT','falcon_poly_invnorm2_fft3','falcon_poly_invnorm2_fft',
    'falcon_poly_adj_fft3','falcon_poly_adj_fft','falcon_poly_mulconst_fft3','falcon_poly_mulconst_fft',
    'falcon_poly_mul_autoadj_fft3','falcon_poly_mul_autoadj_fft','poly_small_mkgauss','poly_small_sqnorm',
    'falcon_iFFT','falcon_compute_public','solve_NTRU','ft_keygen_leaf_certificate',
    'falcon_encode_small','falcon_encode_18433','falcon_encode_12289','fpr_of','fpr_sqrt','fpr_div',
    'fpr_mul','fpr_add','fpr_sqr','fpr_double','fpr_lt'],
    ['mkn','ready','sample','resultant','smallToFp','fft3','fft','invnorm3','invnorm','adj3','adj',
     'mulconst3','mulconst','mulauto3','mulauto','mkgauss','sqnorm','ifft','computePublic','solve',
     'certificate','encodeSmall','encodeT','encodeB','of','sqrt','div','mul','add','sqr','double','lt']))


def quoted(s):
    return json.dumps(s)+'.toList'


def literal_tokens(ts):
    return '['+','.join(json.dumps(t) for t in ts)+'].map String.toList'


class Generator:
    def __init__(self,ts):
        self.ts = ts
        self.pos = 0
        self.lines = []
        self.counter = 0

    def peek(self):
        return self.ts[self.pos] if self.pos<len(self.ts) else None

    def pop(self,expected=None):
        token = self.peek()
        assert token is not None and (expected is None or token==expected),(expected,token,self.pos)
        self.pos += 1
        return token

    def ty(self):
        ty = TYPES[self.pop()]
        if ty=='u32' and self.peek()=='char':
            self.pop();ty='byte'
        return '.'+ty

    def pointer(self,ty):
        if self.peek()=='*':
            self.pop();return '(.pointer '+ty+')'
        return ty

    def unary(self):
        token = self.pop()
        if token in ('-','~','!','*','&'):
            op = {'-':'neg','~':'bitnot','!':'logicalNot','*':'dereference','&':'address'}[token]
            return '(.unary .'+op+' '+self.unary()+')'
        if token=='(':
            if self.peek() in TYPES:
                ty = self.pointer(self.ty());self.pop(')')
                return '(.cast '+ty+' '+self.unary()+')'
            e = self.expression();self.pop(')')
        elif re.fullmatch(r'\d+L?',token):
            e = '(.number .'+('long' if token.endswith('L') else 'i32')+' '+token.rstrip('L')+')'
        elif self.peek()=='(':
            destination = CALLEES[token];self.pop('(');args=[]
            if self.peek()!=')':
                while True:
                    args.append(self.expression())
                    if self.peek()!=',':break
                    self.pop(',')
            self.pop(')')
            e = '(.call .'+destination+' (argumentTree ['+','.join(args)+']))'
        else:
            e = '(.variable '+quoted(token)+')'
        while True:
            if self.peek()=='[':
                self.pop();index=self.expression();self.pop(']')
                e='(.index '+e+' '+index+')'
            elif self.peek()=='-' and self.ts[self.pos+1:self.pos+2]==['>']:
                self.pop();self.pop();e='(.member '+e+' '+quoted(self.pop())+')'
            else:return e

    def expression(self,minimum=0):
        left=self.unary()
        while self.peek() in OPS and OPS[self.peek()][1]>=minimum:
            op,priority=OPS[self.pop()]
            right=self.expression(priority+1)
            left='(.binary .'+op+' '+left+' '+right+')'
        if minimum==0 and self.peek()=='?':
            self.pop();yes=self.expression();self.pop(':');no=self.expression()
            left='(.conditional '+left+' '+yes+' '+no+')'
        return left

    def clause(self,ending):
        if self.peek()==ending:return '.skip'
        left=self.expression()
        if self.peek() in ('=','+='):
            op='set' if self.pop()=='=' else 'add'
            return '(.write '+left+' .'+op+' '+self.expression()+')'
        if self.peek()=='++':
            self.pop();return '(.increment '+left+')'
        return '(.evaluate '+left+')'

    def emit(self,kind,code,tokens,proof):
        name='node'+str(self.counter).zfill(3);self.counter+=1
        self.lines += ['def '+name+' : Stmt := '+code,
                       'def '+name+'Tokens : List B20.C.Token := '+tokens,
                       'theorem '+name+'_source : '+kind+' '+name+' '+name+'Tokens := '+proof,'']
        return name

    def body(self):
        statements=[]
        while self.peek()!='}':statements.append(self.statement())
        tail=self.emit('Body','.skip','[]','by exact .nil')
        for head in reversed(statements):
            tail=self.emit('Body','(.seq '+head+' '+tail+')',head+'Tokens++'+tail+'Tokens',
                           'by exact .cons _ _ _ _ '+head+'_source '+tail+'_source')
        return tail

    def statement(self):
        start=self.pos
        if self.peek()=='{':
            self.pop();body=self.body();self.pop('}')
            return self.emit('Statement','(.scope '+body+')',"[['{']]++"+body+"Tokens++[['}']]",
                             'by exact .scope _ _ '+body+'_source')
        if self.peek()=='if':
            self.pop();self.pop('(');test_start=self.pos;test=self.expression();test_tokens=self.ts[test_start:self.pos]
            self.pop(')');yes=self.statement();no=None
            if self.peek()=='else':self.pop();no=self.statement()
            guard_name='guard'+str(self.counter).zfill(3)
            self.lines += ['def '+guard_name+' : Expr := '+test,
                'def '+guard_name+'Tokens : List B20.C.Token := '+literal_tokens(test_tokens),
                'theorem '+guard_name+'_source : guard '+guard_name+' '+guard_name+'Tokens := by '+
                    ('decide +kernel' if test.count('.call ')>1 else 'rfl'),'']
            prefix='["if".toList,[\'(\']]++'+guard_name+'Tokens++[[\')\']]++'+yes+'Tokens'
            if no:
                return self.emit('Statement','(.branch '+guard_name+' '+yes+' '+no+')',prefix+'++["else".toList]++'+no+'Tokens',
                    'by exact .ifElse _ _ _ _ _ _ '+guard_name+'_source '+yes+'_source '+no+'_source')
            return self.emit('Statement','(.branch '+guard_name+' '+yes+' .skip)',prefix,
                'by exact .ifOnly _ _ _ _ '+guard_name+'_source '+yes+'_source')
        if self.peek()=='for':
            self.pop();self.pop('(');first_start=self.pos;init=self.clause(';');first=self.ts[first_start:self.pos];self.pop(';')
            test_start=self.pos;test=None if self.peek()==';' else self.expression();middle=self.ts[test_start:self.pos];self.pop(';')
            last_start=self.pos;increment=self.clause(')');last=self.ts[last_start:self.pos];self.pop(')');body=self.statement()
            name='loop'+str(self.counter).zfill(3)
            self.lines += ['def '+name+'Init : Stmt := '+init,'def '+name+'Update : Stmt := '+increment,
                'def '+name+'Test : Option Expr := '+('none' if test is None else '(some '+test+')'),
                'def '+name+'First : List B20.C.Token := '+literal_tokens(first),
                'def '+name+'Middle : List B20.C.Token := '+literal_tokens(middle),
                'def '+name+'Last : List B20.C.Token := '+literal_tokens(last),
                'theorem '+name+'_initial : initialClause '+name+'Init '+name+'First := by rfl',
                'theorem '+name+'_increment : incrementClause '+name+'Update '+name+'Last := by rfl',
                'theorem '+name+'_condition : Test '+name+'Test '+name+'Middle := by '+
                    ('exact .absent' if test is None else 'exact .present _ _ (by rfl)'), '']
            tokens='["for".toList,[\'(\']]++'+name+'First++[[\';\']]++'+name+'Middle++[[\';\']]++'+name+'Last++[[\')\']]++'+body+'Tokens'
            return self.emit('Statement','(.loop '+name+'Init '+name+'Test '+name+'Update '+body+')',tokens,
                'by exact .loop _ _ _ _ _ _ _ _ '+name+'_initial '+name+'_condition '+name+'_increment '+body+'_source')
        if self.peek() in TYPES:
            ty=self.ty();objects=[]
            while True:
                element=self.pointer(ty);n=self.pop();count='none'
                if self.peek()=='[':
                    self.pop();count='some '+self.pop();self.pop(']')
                objects.append('⟨'+quoted(n)+','+element+','+count+'⟩')
                if self.peek()!=',':break
                self.pop()
            self.pop(';');code='(.declare ['+','.join(objects)+'])'
        elif self.peek()=='return':
            self.pop();code='(.ret '+self.expression()+')';self.pop(';')
        elif self.peek() in ('break','continue'):
            code='.'+self.pop()+'Loop';self.pop(';')
        else:
            code=self.clause(';');self.pop(';')
        tactic='decide +kernel' if code.count('.call ')>1 else 'rfl'
        return self.emit('Statement',code,literal_tokens(self.ts[start:self.pos]),'by exact .simple _ _ (by '+tactic+')')


def main():
    source=REPO/'Extra/c/falcon-keygen.c'
    assert hashlib.sha256(source.read_bytes()).hexdigest()==SOURCE_SHA
    lines=source.read_text().splitlines(keepends=True)
    text=''.join(preprocess(lines[start-1:start-1+count]) for start,count in REGIONS)
    text=re.sub(r'/\*.*?\*/|//[^\n]*',' ',text,flags=re.S)
    ts=re.findall(r'\w+|>>=|<<=|\+\+|>>|<<|&&|\|\||[+\-*^&|=!<>]=|[^\s\w]',text)
    ts=[str(MACROS[t]) if t in MACROS else t for t in ts]
    start=ts.index('{')+1;signature=ts[:start]
    generator=Generator(ts);generator.pos=start;body=generator.body();generator.pop('}');assert generator.pos==len(ts)
    directory=(ROOT/sys.argv[1]).resolve() if len(sys.argv)==2 else ROOT/'formal/Source3'
    assert len(sys.argv) in (1,2) and directory.is_relative_to(ROOT)
    directory.mkdir(parents=True,exist_ok=True)
    common='set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\n'
    common+='/- Generated bounded compositional syntax; atomic clauses are kernel checked. -/\n'
    common+='namespace FT1536.Source3.KeygenMakeBinding\nopen KeygenMakeSyntax\nopen KeygenMakeGrammar\n\n'
    parts=[]
    for offset in range(0,len(generator.lines),120):
        name='KeygenMakeBindingPart'+str(len(parts)).zfill(2)
        content='import Source3.'+(parts[-1] if parts else 'KeygenMakeGrammar')+'\n\n'+common
        content+='\n'.join(generator.lines[offset:offset+120])
        content+='\nend FT1536.Source3.KeygenMakeBinding\n'
        for boundary in ['node029','guard035','guard040','node041']:
            pattern=r'^(theorem '+boundary+r'_source[^\n]*\n)'
            match=re.search(pattern,content,re.M)
            if match:
                progress='run_cmd IO.FS.writeFile "../MAKE_BINDING_PART01_PROGRESS.json" "{\\\"boundary\\\":\\\"'+boundary+'\\\"}\\n"\n'
                content=content[:match.end()]+progress+content[match.end():]
        target=directory/(name+'.lean')
        assert not target.exists(), 'Never replace a bounded producer'
        target.write_text(content);parts.append(name)
    output='import Source3.'+parts[-1]+'\nimport Source3.KeygenMakeTokens\n\n'+common
    output+='def signatureTokens : List B20.C.Token := '+literal_tokens(signature)+'\n'
    output+='run_cmd IO.FS.writeFile "../MAKE_BINDING_PROGRESS.json" "{\\\"boundary\\\":\\\"all'+str(generator.counter)+'nodes\\\"}\\n"\n'
    output+='theorem signature_source : header signatureTokens=some (expectedHeader,[]) := by rfl\n'
    output+='def code : Stmt := .scope '+body+'\n'
    output+='def completeTokens : List B20.C.Token := signatureTokens++'+body+"Tokens++[['}']]\n"
    output+='theorem complete_tokens_source : completeTokens=KeygenMakeTokens.all := by rfl\n'
    output+='theorem source_bound : Whole KeygenMakeTokens.all expectedHeader code := by\n'
    output+='  exact .function _ _ _ _ _ signature_source '+body+'_source complete_tokens_source.symm\n'
    output+='\nend FT1536.Source3.KeygenMakeBinding\n'
    target=directory/'KeygenMakeBinding.lean'
    assert not target.exists(), 'Never replace an existing binding producer'
    target.write_text(output)
    print(json.dumps({'nodes':generator.counter,'tokens':len(ts),'parts':parts,
        'sha256':hashlib.sha256(target.read_bytes()).hexdigest()},indent=2))


if __name__=='__main__':
    main()
