/// One-line preview of an ayah: its first five words, "....." and its last
/// word. Ayahs of six words or fewer are shown whole.
String ayahSnippet(String text) {
  // Drop standalone signs (۞, waqf marks) so they are not counted as words.
  final words = text
      .split(' ')
      .where((w) => w.runes.any(_isArabicLetter))
      .toList(growable: false);
  if (words.length <= 6) return words.join(' ');
  return '${words.take(5).join(' ')} ..... ${words.last}';
}

bool _isArabicLetter(int rune) =>
    (rune >= 0x0621 && rune <= 0x064A) || rune == 0x0671;
