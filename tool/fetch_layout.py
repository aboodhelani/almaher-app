"""Downloads the Madani mushaf (King Fahd Complex 1405H print) word layout
from the quran.com API: every word's page and line. Cached per page, so it
can be re-run; build_layout.py turns the cache into the app's asset.

Run: python3 tool/fetch_layout.py <cache dir>
"""
import json
import sys
import time
import subprocess
from pathlib import Path

API = ("https://api.quran.com/api/v4/verses/by_page/{page}"
       "?words=true&word_fields=line_number,page_number,text_uthmani"
       "&mushaf=2&per_page=300")

cache = Path(sys.argv[1])
cache.mkdir(parents=True, exist_ok=True)
for page in range(1, 605):
    out = cache / f"page{page:03d}.json"
    if out.exists():
        continue
    for attempt in range(5):
        try:
            # curl rather than urllib: it uses the system's certificates.
            raw = subprocess.run(
                ["curl", "-sf", "--max-time", "30", API.format(page=page)],
                check=True, capture_output=True,
            ).stdout
            data = json.loads(raw)
            assert data["verses"], page
            out.write_text(json.dumps(data, ensure_ascii=False), encoding="utf-8")
            break
        except Exception as e:  # retry with a pause
            print("retry", page, e)
            time.sleep(2 + attempt * 3)
    else:
        sys.exit(f"failed on page {page}")
    time.sleep(0.15)
print("done")
