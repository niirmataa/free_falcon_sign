"""Rehearsal anchor manifest for the pre-freeze fresh replay.

Lists every immutable member (anchor itself excluded); the replay controller
verifies it with its external SHA-256 before creating a DEST."""
import json
from pathlib import Path
from replaylib import sha
from scope import members,ANCHOR
from common import W
def main():
    assert not (W/'OUTPUTS.sha256').exists(),'already frozen; use OUTPUTS.sha256'
    paths=members(W,anchor=True)
    (W/ANCHOR).write_text(''.join(sha(W/p)+'  '+p+'\n' for p in paths))
    print(json.dumps(dict(anchor=ANCHOR,members=len(paths),anchor_sha256=sha(W/ANCHOR)),indent=2))
if __name__=='__main__':main()
