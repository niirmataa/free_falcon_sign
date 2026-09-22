import os,json
from pathlib import Path
Path(os.environ['REVIEW_MARKER']).write_text('imported')
class Backend:
    def __init__(self,name): self.name=name
    def estimate(self,params):
        with open(os.environ['REVIEW_CALLS'],'a') as f:
            f.write(json.dumps({'backend':self.name,'problem':params['problem'],'N':params['N']})+'\n')
        return 'REVIEW_MOCK_ONLY_NO_COST'
NTRU=Backend('NTRU')
ISIS=Backend('ISIS')
SIS=Backend('SIS')
