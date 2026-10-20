import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/arabic_numbers.dart';
import '../../../../core/widgets/star_badge.dart';
import '../../../quran/domain/models/surah_model.dart';

class SurahResultTile extends StatelessWidget {
  final SurahModel surah;
  final VoidCallback onTap;

  const SurahResultTile({super.key, required this.surah, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            StarBadge(
              number: surah.number,
              size: 40.r,
              color: scheme.onSurface,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سورة ${surah.nameArabic}',
                    style: AppTextStyle.quranSurahTitle.copyWith(
                      fontSize: 19.sp,
                      height: 1.3,
                      color: scheme.onSurface,
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
            Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
