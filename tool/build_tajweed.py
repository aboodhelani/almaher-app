"""Builds assets/quran/tajweed.json from alquran.cloud's `quran-tajweed` edition.

The tajweed edition marks rule spans inline, e.g. `[n[ـٰ]` or nested
`[o[ُوٓ[s[اْ]]`, on a slightly different spelling of the same Tanzil Uthmani
text. Each span is mapped onto our base text (assets/quran/quran_uthmani.json)
with a per-ayah character alignment, so colours land on our letters.

Output: {"rules": "<codes>", "ayahs": [[start, end, rule, ...], ...]} — one flat
list per ayah in mushaf order; offsets are UTF-16 indices into the ayah text,
`rule` indexes into `rules`. Inner (nested) spans come after outer ones.

Usage: python3 -I tool/build_tajweed.py <quran-tajweed.json> <quran_uthmani.json> <out.json>
"""
import difflib
import json
import re
import sys
import unicodedata

RULES = "hslnpmqocfwiaudbg"
OPEN = re.compile(r"\[([a-z])(?::\d+)?\[")


def strip_tags(text):
    """Plain text plus [(start, end, code)] spans, innermost last."""
    out, spans, stack, i = [], [], [], 0
    while i < len(text):
        m = OPEN.match(text, i)
        if m:
            stack.append((m.group(1), len(out)))
            i = m.end()
        elif text[i] == "]" and stack:
            code, start = stack.pop()
            spans.append((start, len(out), code, len(stack)))
            i += 1
        else:
            out.append(text[i])
            i += 1
    spans.sort(key=lambda s: (s[3], s[0]))  # outer first, inner last
    return "".join(out), [(s, e, c) for s, e, c, _ in spans]


def is_mark(ch):
    return unicodedata.category(ch) in ("Mn", "Me") or ch in "ـ‌"


def boundary_maps(src, dst):
    """For every boundary i in src (0..len), where a span starting/ending there
    starts/ends in dst. Marks that dst inserts at a boundary stay with the
    letter before it."""
    starts = [0] * (len(src) + 1)
    ends = [0] * (len(src) + 1)
    sm = difflib.SequenceMatcher(None, src, dst, autojunk=False)
    for op, i1, i2, j1, j2 in sm.get_opcodes():
        if op == "equal":
            for k in range(i1, i2 + 1):
                starts[k] = ends[k] = j1 + (k - i1)
        elif op == "insert":
            inserted_marks = all(is_mark(c) for c in dst[j1:j2])
            starts[i1] = j2
            ends[i1] = j2 if inserted_marks else j1
        else:  # replace / delete
            starts[i1] = j1
            ends[i1] = j1
            for k in range(i1 + 1, i2):
                starts[k] = j1
                ends[k] = j2
            starts[i2] = j2
            ends[i2] = j2
    return starts, ends


# Their spelling uses these where ours has a dagger alef or alef maqsura.
LETTER_EQUIVALENTS = {"\u0672": "\u0670", "\u066e": "\u0649"}


def letters(s):
    """Base letters only; a dagger alef counts as a letter here."""
    s = "".join(LETTER_EQUIVALENTS.get(c, c) for c in s)
    return "".join(c for c in s if c == "\u0670" or not (is_mark(c) or c == " "))


def main(tajweed_path, base_path, out_path):
    tajweed = json.load(open(tajweed_path, encoding="utf-8-sig"))["data"]["surahs"]
    base = json.load(open(base_path, encoding="utf-8"))["ayahs"]
    tagged = [a["text"].replace("﻿", "") for s in tajweed for a in s["ayahs"]]
    assert len(tagged) == len(base), (len(tagged), len(base))

    out, total, empty, suspicious = [], 0, 0, []
    for t, row in zip(tagged, base):
        plain, spans = strip_tags(t)
        text = row[6]
        starts, ends = boundary_maps(plain, text)
        flat = []
        for s, e, code in spans:
            ms, me = starts[s], ends[e]
            if me <= ms:
                empty += 1
                continue
            # The same letters should be covered on both sides.
            if letters(plain[s:e]) and not letters(text[ms:me]):
                suspicious.append((row[0], row[1], code, plain[s:e], text[ms:me]))
            flat += [ms, me, RULES.index(code)]
            total += 1
        out.append(flat)

    json.dump({"rules": RULES, "ayahs": out}, open(out_path, "w", encoding="utf-8"),
              separators=(",", ":"))
    print(f"spans={total} dropped_empty={empty} suspicious={len(suspicious)}")
    for s in suspicious[:10]:
        print("  ", s)


if __name__ == "__main__":
    main(*sys.argv[1:4])
