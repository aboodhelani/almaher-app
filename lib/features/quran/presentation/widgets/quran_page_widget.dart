import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/styles/quran_colors.dart';
import '../../../../core/styles/quran_fonts.dart';
import '../../../../core/utils/app_notifier.dart';
import '../../../../core/utils/arabic_numbers.dart';
import '../../../mutashabihat/domain/models/mutashabihat_model.dart';
import '../../../tajweed/domain/models/tajweed_model.dart';
import '../../domain/models/ayah_model.dart';
import '../../domain/models/mushaf_line_model.dart';
import '../../domain/models/quran_model.dart';
import '../../domain/models/quran_page_model.dart';
import 'mushaf_line.dart';
import 'surah_header.dart';

/// One mushaf page laid out line for line as the printed Madani mushaf: 15
/// lines (8 on the first two pages), each justified across the page, with
/// surah banners and basmalas on their own lines. The font follows the
/// setting; colours follow the theme (see [QuranColors]).
class QuranPageWidget extends StatelessWidget {
  final QuranModel quran;
  final QuranPageModel page;

  /// `surah:ayah` key of the selected ayah, if it is on this page.
  final String? highlightedAyahKey;

  /// Colours letters by tajweed rule when given.
  final TajweedModel? tajweed;

  /// Marks repeated ayahs and phrases when given.
  final MutashabihatModel? mutashabihat;
  final ValueChanged<AyahModel> onAyahTap;
  final ValueChanged<AyahModel> onAyahLongPress;
  final VoidCallback onClearHighlight;

  const QuranPageWidget({
    super.key,
    required this.quran,
    required this.page,
    required this.highlightedAyahKey,
    required this.tajweed,
    required this.mutashabihat,
    required this.onAyahTap,
    required this.onAyahLongPress,
    required this.onClearHighlight,
  });

  /// The first two pages are short centred blocks in the mushaf.
  bool get _isOpeningPage => page.pageNumber <= 2;

  /// Lines on a full page; every page's line height follows it.
  static const _linesPerPage = 15;

  @override
  Widget build(BuildContext context) {
    final colors = context.quranColors;
    // Odd pages are on the right of the open mushaf, even on the left; the
    // stacked page edges show on the outer side.
    final rightPage = page.pageNumber.isOdd;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClearHighlight,
      child: Container(
        color: colors.pageBackground,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              right: rightPage ? 0 : null,
              left: rightPage ? null : 0,
              child: _PageEdge(onRight: rightPage),
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  rightPage ? 6.w : 14.w,
                  4.h,
                  rightPage ? 18.w : 10.w,
                  2.h,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, box) => _lines(context, box),
                      ),
                    ),
                    _PageNumber(page.pageNumber),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lines(BuildContext context, BoxConstraints box) {
    final font = context.select<AppNotifier, QuranFont>((n) => n.quranFont);
    final lineHeight = box.maxHeight / _linesPerPage;
    var style = MushafLineStyle(
      font: font,
      fontSize: lineHeight * font.lineFill,
      colors: context.quranColors,
      brightness: Theme.of(context).brightness,
      highlightedAyahKey: highlightedAyahKey,
      tajweed: tajweed,
      mutashabihat: mutashabihat,
    );
    // One size for the whole page, fitted to its longer lines: the third
    // widest fits the width, and any line still longer shrinks on its own.
    final widths = [
      for (final line in page.lines.whereType<TextLine>())
        measureMushafLine(line, style),
    ]..sort((a, b) => b.compareTo(a));
    final widest = widths.isEmpty ? 0.0 : widths[widths.length > 2 ? 2 : 0];
    if (widest > box.maxWidth) {
      style = MushafLineStyle(
        font: font,
        fontSize: style.fontSize * box.maxWidth / widest * 0.99,
        colors: style.colors,
        brightness: style.brightness,
        highlightedAyahKey: highlightedAyahKey,
        tajweed: tajweed,
        mutashabihat: mutashabihat,
      );
    }
    final rows = [
      for (final line in page.lines)
        SizedBox(
          height: lineHeight,
          child: Center(child: _line(line, style, box.maxWidth, lineHeight)),
        ),
    ];
    return Column(
      mainAxisAlignment: _isOpeningPage
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: rows,
    );
  }

  Widget _line(
    MushafLineModel line,
    MushafLineStyle style,
    double width,
    double height,
  ) => switch (line) {
    SurahBannerLine(:final surahNumber) => SurahHeader(
      surah: quran.surah(surahNumber),
      height: height * 0.92,
    ),
    BasmalaLine() => Text(
      style.font.prepare('بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ'),
      textDirection: TextDirection.rtl,
      style: style.base,
    ),
    TextLine() => MushafTextLine(
      line: line,
      style: style,
      width: _isOpeningPage ? width * 0.8 : width,
      justify: !_isOpeningPage,
      onTap: (ayah) => ayah == null ? onClearHighlight() : onAyahTap(ayah),
      onLongPress: onAyahLongPress,
    ),
  };
}

class _PageNumber extends StatelessWidget {
  final int number;

  const _PageNumber(this.number);

  @override
  Widget build(BuildContext context) {
    final colors = context.quranColors;
    Widget rule() => Container(
      width: 22.w,
      height: 1,
      color: colors.headerBorder.withValues(alpha: 0.5),
    );
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          rule(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              number.toArabicDigits,
              style: AppTextStyle.small.copyWith(
                color: colors.headerBorder,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          rule(),
        ],
      ),
    );
  }
}

/// The outer edge of a mushaf page: a soft shade with the thin lines of the
/// pages beneath, on the right of a right page and the left of a left one.
class _PageEdge extends StatelessWidget {
  final bool onRight;

  const _PageEdge({required this.onRight});

  @override
  Widget build(BuildContext context) {
    final colors = context.quranColors;
    final shade = Color.lerp(colors.pageBackground, colors.text, 0.14)!;
    final line = Color.lerp(colors.pageBackground, colors.text, 0.22)!;
    final lines = [
      for (var i = 0; i < 4; i++)
        Container(width: 1, color: line.withValues(alpha: 0.9 - i * 0.18)),
    ];
    return SizedBox(
      width: 12.w,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: onRight ? Alignment.centerRight : Alignment.centerLeft,
            end: onRight ? Alignment.centerLeft : Alignment.centerRight,
            colors: [shade, colors.pageBackground],
          ),
        ),
        child: Row(
          textDirection: onRight ? TextDirection.rtl : TextDirection.ltr,
          children: [
            for (final l in lines) ...[l, SizedBox(width: 1.5.w)],
          ],
        ),
      ),
    );
  }
}
