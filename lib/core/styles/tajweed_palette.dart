import 'package:flutter/material.dart';

import '../../features/tajweed/domain/models/tajweed_rule.dart';

/// Colour of each tajweed rule. Light mode uses the common tajweed-mushaf
/// palette for this data; dark mode lifts each colour so it reads on black.
class TajweedPalette {
  static Color of(TajweedRule rule, Brightness brightness) {
    final pair = _colors[rule]!;
    return brightness == Brightness.dark ? pair.$2 : pair.$1;
  }

  static const Map<TajweedRule, (Color, Color)> _colors = {
    TajweedRule.maddNatural: (Color(0xFF537FFF), Color(0xFF86A5FF)),
    TajweedRule.maddPermissible: (Color(0xFF4050FF), Color(0xFF7D88FF)),
    TajweedRule.maddObligatory: (Color(0xFF2144C1), Color(0xFF6E8DFF)),
    TajweedRule.maddNecessary: (Color(0xFF000EBC), Color(0xFF5966FF)),
    TajweedRule.ghunna: (Color(0xFFFF7E1E), Color(0xFFFF9C52)),
    TajweedRule.ikhfa: (Color(0xFF9400A8), Color(0xFFD36BFF)),
    TajweedRule.idghamWithGhunna: (Color(0xFF169777), Color(0xFF2FC9A2)),
    TajweedRule.idghamWithoutGhunna: (Color(0xFF169200), Color(0xFF45C93A)),
    TajweedRule.iqlab: (Color(0xFF26BFFD), Color(0xFF63D4FF)),
    TajweedRule.ikhfaShafawi: (Color(0xFFD500B7), Color(0xFFFF5CE6)),
    TajweedRule.idghamShafawi: (Color(0xFF58B800), Color(0xFF86E040)),
    TajweedRule.qalqala: (Color(0xFFDD0008), Color(0xFFFF5259)),
    TajweedRule.idghamMutajanisayn: (Color(0xFFA1A1A1), Color(0xFF8A8A8A)),
    TajweedRule.idghamMutaqaribayn: (Color(0xFFA1A1A1), Color(0xFF8A8A8A)),
    TajweedRule.hamzatWasl: (Color(0xFFAAAAAA), Color(0xFF7A7A7A)),
    TajweedRule.lamShamsiyya: (Color(0xFFAAAAAA), Color(0xFF7A7A7A)),
    TajweedRule.silent: (Color(0xFFAAAAAA), Color(0xFF7A7A7A)),
  };
}
