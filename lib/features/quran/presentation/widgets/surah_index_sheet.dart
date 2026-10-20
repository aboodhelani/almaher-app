import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/arabic_numbers.dart';
import '../../../../core/widgets/star_badge.dart';
import '../../domain/models/surah_model.dart';

/// Lists the 114 surahs, filterable by name or number; pops with the one
/// picked. Used as the reader's index and as the search filter.
class SurahIndexSheet extends StatefulWidget {
  final List<SurahModel> surahs;

  /// Marked and scrolled to, if given.
  final int? currentSurahNumber;

  const SurahIndexSheet({
    super.key,
    required this.surahs,
    this.currentSurahNumber,
  });

  static Future<SurahModel?> show(
    BuildContext context, {
    required List<SurahModel> surahs,
    int? currentSurahNumber,
  }) {
    return showModalBottomSheet<SurahModel>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => SurahIndexSheet(
        surahs: surahs,
        currentSurahNumber: currentSurahNumber,
      ),
    );
  }

  @override
  State<SurahIndexSheet> createState() => _SurahIndexSheetState();
}

class _SurahIndexSheetState extends State<SurahIndexSheet> {
  static final _rowHeight = 68.h;
  late final _scroll = ScrollController(
    initialScrollOffset:
        ((widget.currentSurahNumber ?? 1) - 3).clamp(0, 114) * _rowHeight,
  );
  String _query = '';

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  List<SurahModel> get _visible {
    final q = _plain(_query);
    if (q.isEmpty) return widget.surahs;
    final number = int.tryParse(toWesternDigits(_query.trim()));
    return widget.surahs
        .where(
          (s) =>
              (number != null && s.number == number) ||
              _plain(s.nameArabic).contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    final surahs = _visible;
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.85,
      child: Column(
        children: [
          Text(
            s.surahs_index,
            style: AppTextStyle.xLarge.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: s.surah_filter_hint,
                prefixIcon: const Icon(Icons.search_rounded),
              ),
            ),
          ),
          Expanded(
            child: surahs.isEmpty
                ? Center(
                    child: Text(
                      s.surah_none,
                      style: AppTextStyle.medium.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _query.isEmpty ? _scroll : null,
                    padding: EdgeInsets.fromLTRB(8.w, 4.h, 8.w, 16.h),
                    itemExtent: _rowHeight,
                    itemCount: surahs.length,
                    itemBuilder: (context, index) => _SurahRow(
                      surah: surahs[index],
                      selected:
                          surahs[index].number == widget.currentSurahNumber,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  /// Letters only, alef forms folded, so "الفاتحه" finds الفَاتِحَةِ.
  static String _plain(String text) {
    final b = StringBuffer();
    for (final r in text.runes) {
      if ((r >= 0x064B && r <= 0x065F) ||
          r == 0x0670 ||
          (r >= 0x06D6 && r <= 0x06ED) ||
          r == 0x0640 ||
          r == 0x20) {
        continue;
      }
      b.writeCharCode(switch (r) {
        0x0671 || 0x0623 || 0x0625 || 0x0622 => 0x0627,
        0x0629 => 0x0647,
        0x0649 => 0x064A,
        _ => r,
      });
    }
    return b.toString();
  }
}

class _SurahRow extends StatelessWidget {
  final SurahModel surah;
  final bool selected;

  const _SurahRow({required this.surah, required this.selected});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Material(
        color: selected ? scheme.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () => Navigator.of(context).pop(surah),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: [
                StarBadge(
                  number: surah.number,
                  size: 42.r,
                  color: selected ? scheme.primary : scheme.onSurface,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          surah.nameArabic,
                          style: AppTextStyle.quranSurahTitle.copyWith(
                            fontSize: 19.sp,
                            color: selected ? scheme.primary : scheme.onSurface,
                            height: 1.3,
                          ),
                        ),
                        Text(
                          '${surah.revelationType == RevelationType.meccan ? s.meccan : s.medinan}'
                          ' · ${s.ayahs_count(surah.ayahCount.toArabicDigits)}',
                          style: AppTextStyle.small.copyWith(
                            color: scheme.onSurfaceVariant,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    s.surah_page_short(surah.startPage.toArabicDigits),
                    style: AppTextStyle.small.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
