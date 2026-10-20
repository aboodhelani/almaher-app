"""Turns api.alquran.cloud `/v1/quran/<edition>` downloads into the app's
compact edition format (assets/quran/editions/<id>.json):

  {"identifier", "name", "englishName", "language", "direction", "type",
   "texts": [6236 strings, in mushaf order]}

The app writes downloaded editions in the same format.

Run: python3 tool/build_editions.py <downloaded.json>...
"""
import json
import sys
from pathlib import Path

OUT = Path(__file__).resolve().parent.parent / "assets" / "quran" / "editions"
OUT.mkdir(parents=True, exist_ok=True)

for path in sys.argv[1:]:
    data = json.load(open(path, encoding="utf-8"))["data"]
    ed = data["edition"]
    texts = [a["text"] for s in data["surahs"] for a in s["ayahs"]]
    assert len(texts) == 6236, (path, len(texts))
    out = {
        "identifier": ed["identifier"],
        "name": ed["name"],
        "englishName": ed["englishName"],
        "language": ed["language"],
        "direction": ed.get("direction") or ("rtl" if ed["language"] in ("ar", "ur", "fa") else "ltr"),
        "type": ed["type"],
        "texts": texts,
    }
    target = OUT / f"{ed['identifier']}.json"
    target.write_text(json.dumps(out, ensure_ascii=False, separators=(",", ":")), encoding="utf-8")
    print(target.name, len(texts), f"{target.stat().st_size // 1024} KB")
