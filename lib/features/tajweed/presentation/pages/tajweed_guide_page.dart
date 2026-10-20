import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/arabic_numbers.dart';
import '../../../../shared/presentation/widgets/app_loader.dart';
import '../../domain/models/tajweed_rule.dart';
import '../bloc/tajweed_guide_bloc.dart';
import '../widgets/tajweed_details_sheet.dart';
import '../widgets/tajweed_word.dart';

/// The colour guide: every tajweed colour, what it means, how long it is
/// held, and a real example from the mushaf.
class TajweedGuidePage extends StatelessWidget {
  const TajweedGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.tajweed_guide)),
      body: BlocBuilder<TajweedGuideBloc, TajweedGuideState>(
        builder: (context, state) {
          if (state is! TajweedGuideLoaded) return const AppLoader();
          return ListView(
            padding: EdgeInsets.only(bottom: 32.h),
            children: [
              for (final category in TajweedCategory.values) ...[
                _CategoryHeader(title: category.nameArabic),
                for (final rule in TajweedRule.values)
                  if (rule.category == category)
                    _RuleCard(rule: rule, example: state.examples[rule]),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  final String title;

  const _CategoryHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 6.h),
      child: Text(
        title,
        style: AppTextStyle.small.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _RuleCard extends StatelessWidget {
  final TajweedRule rule;
  final TajweedExample? example;

  const _RuleCard({required this.rule, required this.example});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    final color = rule.colorIn(context);
    final example = this.example;
    final duration = rule.durationArabic;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(13.r),
            ),
            alignment: Alignment.center,
            child: Container(
              width: 16.r,
              height: 16.r,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
          SizedBox(width: 12.w),
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
                if (duration != null)
                  Text(
                    duration,
                    style: AppTextStyle.small.copyWith(color: color),
                  ),
                SizedBox(height: 4.h),
                Text(
                  rule.descriptionArabic,
                  style: AppTextStyle.small.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                if (example != null) ...[
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Text(
                        '${s.tajweed_example}: ',
                        style: AppTextStyle.small.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      Flexible(
                        child: TajweedWord(
                          ayahText: example.ayah.text,
                          span: example.span,
                          fontSize: 22.sp,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '(${example.surah.nameArabic} ${example.ayah.numberInSurah.toArabicDigits})',
                        style: AppTextStyle.xSmall.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
