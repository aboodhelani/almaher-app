import 'dart:typed_data';

const int _alef = 0x0627;
const int _waw = 0x0648;
const int _yeh = 0x064A;
const int _space = 0x20;

/// Arabic text reduced to what search compares: one entry per letter (or
/// space), each with its tashkeel as a bitmask so the order the marks were
/// typed in does not matter.
///
/// Letters are folded so a normal keyboard finds the Uthmani text:
/// ٱ أ إ آ → ا, ى → ي, ة → ه. The Uthmani "small" letters — dagger alef (ٰ),
/// small waw (ۥ) and small yeh (ۦ) — become *optional* letters that either
/// match a typed ا / و / ي or are skipped, so both العالمين (written
/// ٱلْعَٰلَمِينَ) and هذا (written هَٰذَا) are found. Waqf signs and other
/// annotation marks are dropped.
class SearchText {
  final Uint16List letters;
  final Uint8List marks;

  /// 1 where the letter may be skipped (a small Uthmani letter).
  final Uint8List optional;

  SearchText._(this.letters, this.marks, this.optional);

  int get length => letters.length;

  bool get hasTashkeel => marks.any((m) => m != 0);

  /// Letters, not counting spaces or optional letters.
  int get letterCount {
    var count = 0;
    for (var i = 0; i < letters.length; i++) {
      if (letters[i] != _space && optional[i] == 0) count++;
    }
    return count;
  }

  /// Parses [input]. A [query] is what the user typed: small letters in it are
  /// plain letters, never optional.
  factory SearchText.parse(String input, {bool query = false}) {
    final letters = <int>[];
    final marks = <int>[];
    final optional = <int>[];

    void add(int letter, {bool isOptional = false}) {
      letters.add(letter);
      marks.add(0);
      optional.add(isOptional ? 1 : 0);
    }

    for (final rune in input.runes) {
      final mark = _tashkeelBit(rune);
      if (mark != 0) {
        if (letters.isNotEmpty) marks[marks.length - 1] |= mark;
        continue;
      }
      switch (rune) {
        case 0x0670: // dagger alef
          add(_alef, isOptional: !query);
          continue;
        case 0x06E5: // small waw
          add(_waw, isOptional: !query);
          continue;
        case 0x06E6: // small yeh
          add(_yeh, isOptional: !query);
          continue;
      }
      if (_isDropped(rune)) continue;
      if (_isSpace(rune)) {
        if (letters.isNotEmpty && letters.last != _space) add(_space);
        continue;
      }
      add(_fold(rune));
    }
    while (letters.isNotEmpty && letters.last == _space) {
      letters.removeLast();
      marks.removeLast();
      optional.removeLast();
    }
    return SearchText._(
      Uint16List.fromList(letters),
      Uint8List.fromList(marks),
      Uint8List.fromList(optional),
    );
  }

  /// This text without a leading [word] (e.g. "سورة البقرة" → "البقرة").
  SearchText withoutLeadingWord(SearchText word) {
    final n = word.length;
    if (length <= n || letters[n] != _space) return this;
    for (var i = 0; i < n; i++) {
      if (letters[i] != word.letters[i]) return this;
    }
    return SearchText._(
      letters.sublist(n + 1),
      marks.sublist(n + 1),
      optional.sublist(n + 1),
    );
  }

  /// Whether [query] occurs anywhere in this text, ignoring spaces. With
  /// [matchTashkeel], each matched letter must also carry exactly the tashkeel
  /// typed on it.
  bool contains(SearchText query, {required bool matchTashkeel}) {
    if (query.length == 0) return false;
    for (var start = 0; start < length; start++) {
      if (letters[start] == _space) continue;
      if (_matchAt(start, query, 0, matchTashkeel)) return true;
    }
    return false;
  }

  bool _matchAt(int ti, SearchText q, int qi, bool matchTashkeel) {
    while (qi < q.length) {
      // Spaces don't count on either side, so الحمدلله finds الحمد لله
      // and words split differently still match.
      if (q.letters[qi] == _space) {
        qi++;
        continue;
      }
      if (ti >= length) return false;
      if (letters[ti] == _space) {
        ti++;
        continue;
      }
      final ql = q.letters[qi];
      final qm = q.marks[qi];

      if (optional[ti] == 1) {
        // A small letter: use it for the typed letter, or skip it.
        if (letters[ti] == ql &&
            (!matchTashkeel || marks[ti] == qm) &&
            _matchAt(ti + 1, q, qi + 1, matchTashkeel)) {
          return true;
        }
        ti++;
        continue;
      }

      // Uthmani وٰ (as in ٱلصَّلَوٰةَ) reads as ا: let it match a typed ا.
      if (letters[ti] == _waw &&
          ql == _alef &&
          ti + 1 < length &&
          optional[ti + 1] == 1 &&
          letters[ti + 1] == _alef &&
          (!matchTashkeel || marks[ti + 1] == qm) &&
          _matchAt(ti + 2, q, qi + 1, matchTashkeel)) {
        return true;
      }

      if (letters[ti] != ql) return false;
      if (matchTashkeel && marks[ti] != qm) return false;
      ti++;
      qi++;
    }
    return true;
  }
}

/// Fathatan … sukun map to bits 0–7; the Uthmani sukun (ۡ) counts as sukun.
int _tashkeelBit(int rune) {
  if (rune >= 0x064B && rune <= 0x0652) return 1 << (rune - 0x064B);
  if (rune == 0x06E1) return 1 << 7;
  return 0;
}

bool _isDropped(int rune) =>
    (rune >= 0x0653 && rune <= 0x065F) || // maddah, hamza marks, …
    (rune >= 0x06D6 && rune <= 0x06ED) || // waqf signs, ۞, ۩, small marks
    rune == 0x0640 || // tatweel
    rune == 0xFEFF;

bool _isSpace(int rune) =>
    rune == 0x20 || rune == 0x00A0 || rune == 0x09 || rune == 0x0A;

int _fold(int rune) {
  switch (rune) {
    case 0x0671: // ٱ
    case 0x0623: // أ
    case 0x0625: // إ
    case 0x0622: // آ
      return _alef;
    case 0x0649: // ى
      return _yeh;
    case 0x0629: // ة
      return 0x0647; // ه
    default:
      return rune;
  }
}
