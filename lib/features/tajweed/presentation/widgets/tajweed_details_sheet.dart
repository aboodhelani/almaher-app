import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/styles/tajweed_palette.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/arabic_numbers.dart';
import '../../../quran/domain/models/ayah_model.dart';
import '../../../quran/domain/models/surah_model.dart';
import '../../domain/models/tajweed_rule.dart';
import '../../domain/models/tajweed_span_model.dart';
import 'tajweed_word.dart';

/// The tajweed rules in one ayah, in reading order: where each happens, on
/// which letters, and how long it is held.
class TajweedDetailsSheet extends StatelessWidget {
  final AyahModel ayah;
  final SurahModel surah;

  /// `null` when the tajweed data could not be loaded.
  final List<TajweedSpanModel>? spans;

  const TajweedDetailsSheet({
    super.key,
    required this.ayah,
    required this.surah,
    required this.spans,
  });

  static Future<void> show(
    BuildContext context, {
    required AyahModel ayah,
    required SurahModel surah,
    required List<TajweedSpanModel>? spans,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) =>
          TajweedDetailsSheet(ayah: ayah, surah: surah, spans: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    final ordered = [...?spans]..sort((a, b) => a.start.compareTo(b.start));

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            s.tajweed_details,
            style: AppTextStyle.xLarge.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'سورة ${surah.nameArabic} · ${s.ayah_label} ${ayah.numberInSurah.toArabicDigits}',
            style: AppTextStyle.medium.copyWith(color: scheme.onSurfaceVariant),
          ),
          SizedBox(height: 8.h),
          if (spans == null)
            _Note(text: s.tajweed_unavailable)
          else if (ordered.isEmpty)
            _Note(text: s.tajweed_no_rules)
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                itemCount: ordered.length,
                separatorBuilder: (_, _) => Divider(height: 20.h),
                itemBuilder: (context, i) => TajweedRuleOccurrence(
                  ayahText: ayah.text,
                  span: ordered[i],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// One rule in an ayah: where it happens, on which letters, how long.
class TajweedRuleOccurrence extends StatelessWidget {
  final String ayahText;
  final TajweedSpanModel span;

  const TajweedRuleOccurrence({
    super.key,
    required this.ayahText,
    required this.span,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    final rule = span.rule;
    final color = TajweedPalette.of(rule, Theme.of(context).brightness);
    final duration = rule.durationArabic;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12.r,
          height: 12.r,
          margin: EdgeInsets.only(top: 6.h),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rule.nameArabic,
                style: AppTextStyle.large.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              _Fact(
                label: s.tajweed_position,
                child: TajweedWord(
                  ayahText: ayahText,
                  span: span,
                  fontSize: 22.sp,
                ),
              ),
              _Fact(
                label: s.tajweed_letters,
                child: Text(
                  _visible(ayahText.substring(span.start, span.end)),
                  textDirection: TextDirection.rtl,
                  style: AppTextStyle.quranAyah.copyWith(
                    fontSize: 22.sp,
                    height: 1.6,
                    color: color,
                  ),
                ),
              ),
              if (duration != null)
                _Fact(
                  label: s.tajweed_duration,
                  child: Text(
                    duration,
                    style: AppTextStyle.medium.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                ),
              SizedBox(height: 2.h),
              Text(
                rule.descriptionArabic,
                style: AppTextStyle.small.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// A span that starts with a haraka has nothing to sit on alone; a tatweel
  /// gives it a base so it shows.
  static String _visible(String piece) {
    if (piece.isEmpty) return piece;
    final first = piece.codeUnitAt(0);
    final isMark =
        (first >= 0x064B && first <= 0x065F) ||
        first == 0x0670 ||
        (first >= 0x06D6 && first <= 0x06ED);
    return isMark ? 'ـ$piece' : piece;
  }
}

class _Fact extends StatelessWidget {
  final String label;
  final Widget child;

  const _Fact({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 64.w,
          child: Text(
            label,
            style: AppTextStyle.small.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Flexible(child: child),
      ],
    );
  }
}

class _Note extends StatelessWidget {
  final String text;

  const _Note({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 40.h),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyle.large.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Exposed for the guide page's grouping.
extension TajweedRuleColor on TajweedRule {
  Color colorIn(BuildContext context) =>
      TajweedPalette.of(this, Theme.of(context).brightness);
}
