"""Builds assets/quran/layout_madani.json — the Madani mushaf's line layout
(King Fahd Complex 1405H print, 15 lines a page) — from the per-page cache
fetch_layout.py downloads, matched word for word against the app's text
(assets/quran/quran_uthmani.json).

Each page is a list of lines; a line is one of:
  ["h", surah]          the surah's name banner
  ["b"]                 the basmala
  [[surah, ayah, from, to, end], ...]
                        text: words [from, to) of each ayah, as indexes into
                        the ayah's text split on spaces (pause marks stay
                        with the word before them); end = 1 when the ayah
                        ends on this line (its number ornament follows).

Run: python3 tool/build_layout.py <cache dir>
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
cache = Path(sys.argv[1])
quran = json.load(open(ROOT / "assets/quran/quran_uthmani.json", encoding="utf-8"))
text = {(a[0], a[1]): a[6] for a in quran["ayahs"]}
LETTER = re.compile("[\u0621-\u063F\u0641-\u064A\u0671-\u06D3\u06FA-\u06FF]")  # letters, no tatweel


def word_tokens(ayah_text):
    """Token index ranges of each word: a word plus any mark-only tokens
    (pause signs, the sajda sign) that follow it; a leading sign (the hizb
    sign ۞) goes with the first word."""
    tokens = ayah_text.split(" ")
    words = []
    pending = None
    for i, t in enumerate(tokens):
        if LETTER.search(t):
            words.append([i if pending is None else pending, i + 1])
            pending = None
        elif words:
            words[-1][1] = i + 1
        elif pending is None:
            pending = i
    return words


def letters(word):
    """A word's letters, to match words across the two texts — hamza and
    alef forms folded, since the texts spell some of them differently."""
    out = "".join(LETTER.findall(word)).replace("\u0621", "")
    for alef in "\u0623\u0625\u0622\u0671":
        out = out.replace(alef, "\u0627")
    return out.replace("\u0649", "\u064A")


def align(api_words, words, tokens):
    """Our token range for each API word. The texts may split a word
    differently (بَعْدَ مَا / بَعْدَمَا, إِلْ يَاسِينَ), so words are matched by
    their letters; a group shared by several API words goes to the first."""
    ranges = []
    i = k = 0
    while i < len(api_words):
        j, l = i + 1, k + 1
        a = letters(api_words[i])
        o = letters(" ".join(tokens[words[k][0]:words[k][1]]))
        while a != o:
            if len(a) < len(o):
                a += letters(api_words[j]); j += 1
            else:
                o += letters(" ".join(tokens[words[l][0]:words[l][1]])); l += 1
        ranges.append((words[k][0], words[l - 1][1]))
        ranges.extend((words[l - 1][1], words[l - 1][1]) for _ in range(j - i - 1))
        i, k = j, l
    assert k == len(words)
    return ranges


pages = []
for page in range(1, 605):
    data = json.load(open(cache / f"page{page:03d}.json", encoding="utf-8"))
    by_line = {}
    for v in data["verses"]:
        s, a = map(int, v["verse_key"].split(":"))
        words = word_tokens(text[(s, a)])
        api_words = [w for w in v["words"] if w["char_type_name"] == "word"]
        api_texts = [w["text_uthmani"] for w in api_words]
        try:
            ranges = align(api_texts, words, text[(s, a)].split(" "))
        except (AssertionError, IndexError):
            # Spelt too differently to match by letters: word by word.
            assert len(api_texts) == len(words), (v["verse_key"], api_texts)
            ranges = [tuple(w) for w in words]
            print("matched word by word:", v["verse_key"])
        wi = 0
        for w in v["words"]:
            line = w["line_number"]
            segs = by_line.setdefault(line, [])
            if w["char_type_name"] == "word":
                start, end = ranges[wi]
                wi += 1
                if start == end:
                    continue
                if segs and segs[-1][:2] == [s, a] and segs[-1][3] == start:
                    segs[-1][3] = end
                else:
                    segs.append([s, a, start, end, 0])
            elif w["char_type_name"] == "end":
                if segs and segs[-1][:2] == [s, a]:
                    segs[-1][4] = 1
                else:  # the number alone on a line
                    n = len(text[(s, a)].split(" "))
                    segs.append([s, a, n, n, 1])
    count = 8 if page <= 2 else 15
    lines = []
    for n in range(1, count + 1):
        lines.append(by_line.get(n))
    # Fill banner / basmala lines: a run of empty lines belongs to the next
    # surah start, on this page or (at the page's end) the next page.
    i = 0
    while i < len(lines):
        if lines[i] is not None:
            i += 1
            continue
        j = i
        while j < len(lines) and lines[j] is None:
            j += 1
        run = j - i
        if j < len(lines):
            first = lines[j][0]
            surah, starts = first[0], first[1] == 1 and first[2] == 0
            assert starts, (page, i + 1)
        else:
            nxt = json.load(open(cache / f"page{page + 1:03d}.json", encoding="utf-8"))
            surah = int(nxt["verses"][0]["verse_key"].split(":")[0])
            starts = False
        has_basmala = surah not in (1, 9)
        if starts:
            fill = (["h", surah], ["b"]) if run == 2 else ((["h", surah],) if not has_basmala or surah == 1 else (["b"],))
        else:
            fill = ((["h", surah], ["b"]) if run == 2 and has_basmala else (["h", surah],))
        assert len(fill) == run, (page, i + 1, run, fill)
        lines[i:j] = list(fill)
        i = j
    pages.append(lines)

out = ROOT / "assets/quran/layout_madani.json"
out.write_text(json.dumps({"source": "King Fahd Complex Madani mushaf, 1405H print (via quran.com)",
                           "pages": pages}, ensure_ascii=False, separators=(",", ":")),
               encoding="utf-8")
print("wrote", out, out.stat().st_size // 1024, "KB")
