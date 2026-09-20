import json
from pathlib import Path
from package_scope import semantic_rows
W=Path.cwd();rows=semantic_rows(W)
(W/'SEMANTIC_FILES.json').write_text(json.dumps(dict(schema='FT1536_FLOOR_CT_SEMANTIC_V1',matches=rows,physical_measurement_is_replayed_as_data=True),indent=2)+'\n')
print(json.dumps(dict(semantic_matches=len(rows))))
