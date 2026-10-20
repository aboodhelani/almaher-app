const _arabicIndicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

extension ArabicNumbers on int {
  /// `12` → `١٢`
  String get toArabicDigits {
    return toString()
        .split('')
        .map((d) => _arabicIndicDigits[int.parse(d)])
        .join();
  }
}

/// `١٢` → `12` (Arabic-Indic and Persian digits; other characters kept).
String toWesternDigits(String text) => String.fromCharCodes(
  text.runes.map(
    (r) => r >= 0x0660 && r <= 0x0669
        ? r - 0x0660 + 0x30
        : r >= 0x06F0 && r <= 0x06F9
        ? r - 0x06F0 + 0x30
        : r,
  ),
);
