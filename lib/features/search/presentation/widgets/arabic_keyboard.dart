import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';

/// An in-app Arabic keyboard with a row of tashkeel marks, so a search can be
/// typed with diacritics (for full matches) without installing a keyboard.
/// Edits [controller] at its selection and calls [onChanged] after each key.
class ArabicKeyboard extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  /// Switches back to the system keyboard.
  final VoidCallback onUseSystem;

  /// The search key.
  final VoidCallback onDone;

  const ArabicKeyboard({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onUseSystem,
    required this.onDone,
  });

  /// Fatha, damma, kasra, their tanween, sukun, shadda and dagger alef.
  static const _marks = [
    'َ', 'ُ', 'ِ', 'ً', 'ٌ', 'ٍ', //
    'ْ', 'ّ', 'ٰ',
  ];
  static const _rows = [
    ['ض', 'ص', 'ث', 'ق', 'ف', 'غ', 'ع', 'ه', 'خ', 'ح', 'ج'],
    ['ش', 'س', 'ي', 'ب', 'ل', 'ا', 'ت', 'ن', 'م', 'ك', 'ط'],
    ['ذ', 'ئ', 'ء', 'ؤ', 'ر', 'ى', 'ة', 'و', 'ز', 'ظ', 'د'],
    ['أ', 'إ', 'آ', 'ٱ'],
  ];

  void _insert(String text) {
    HapticFeedback.selectionClick();
    final value = controller.value;
    final sel = value.selection.isValid
        ? value.selection
        : TextSelection.collapsed(offset: value.text.length);
    final next = value.text.replaceRange(sel.start, sel.end, text);
    controller.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: sel.start + text.length),
    );
    onChanged(next);
  }

  void _backspace() {
    HapticFeedback.selectionClick();
    final value = controller.value;
    final sel = value.selection.isValid
        ? value.selection
        : TextSelection.collapsed(offset: value.text.length);
    if (!sel.isCollapsed) {
      _insert('');
      return;
    }
    if (sel.start == 0) return;
    // One code unit: Arabic letters and marks are single UTF-16 units.
    final next = value.text.replaceRange(sel.start - 1, sel.start, '');
    controller.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: sel.start - 1),
    );
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainer,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(4.w, 6.h, 4.w, 6.h),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _KeyRow(
                  children: [
                    for (final m in _marks)
                      _Key(label: '◌$m', accent: true, onTap: () => _insert(m)),
                  ],
                ),
                for (final row in _rows)
                  _KeyRow(
                    children: [
                      // First in a right-to-left row: delete sits on the right.
                      if (row == _rows.last)
                        _Key(
                          icon: Icons.backspace_outlined,
                          flex: 2,
                          onTap: _backspace,
                          onLongPress: () {
                            controller.clear();
                            onChanged('');
                          },
                        ),
                      for (final k in row)
                        _Key(label: k, onTap: () => _insert(k)),
                    ],
                  ),
                _KeyRow(
                  children: [
                    _Key(
                      icon: Icons.keyboard_alt_outlined,
                      flex: 2,
                      onTap: onUseSystem,
                    ),
                    _Key(label: 'مسافة', flex: 6, onTap: () => _insert(' ')),
                    _Key(
                      icon: Icons.search_rounded,
                      flex: 2,
                      primary: true,
                      onTap: onDone,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KeyRow extends StatelessWidget {
  final List<Widget> children;

  const _KeyRow({required this.children});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: 3.h),
    child: Row(children: children),
  );
}

class _Key extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final int flex;
  final bool accent;
  final bool primary;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _Key({
    this.label,
    this.icon,
    this.flex = 1,
    this.accent = false,
    this.primary = false,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = primary
        ? scheme.primary
        : accent
        ? scheme.primaryContainer
        : scheme.surface;
    final fg = primary
        ? scheme.onPrimary
        : accent
        ? scheme.primary
        : scheme.onSurface;
    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.5.w),
        child: Material(
          color: bg,
          borderRadius: BorderRadius.circular(8.r),
          elevation: 0.5,
          child: InkWell(
            borderRadius: BorderRadius.circular(8.r),
            onTap: onTap,
            onLongPress: onLongPress,
            child: SizedBox(
              height: 44.h,
              child: Center(
                child: icon != null
                    ? Icon(icon, size: 20.r, color: fg)
                    : Text(
                        label!,
                        style:
                            (accent
                                    ? AppTextStyle.quranAyah.copyWith(
                                        fontSize: 22.sp,
                                      )
                                    : AppTextStyle.large.copyWith(
                                        fontSize: label!.length > 1
                                            ? 13.sp
                                            : 19.sp,
                                      ))
                                .copyWith(color: fg, height: 1.2),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
