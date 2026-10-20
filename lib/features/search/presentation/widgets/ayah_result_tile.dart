import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/widgets/star_badge.dart';
import '../../domain/models/search_results_model.dart';
import '../utils/ayah_snippet.dart';

/// The ayah number in a star, the surah above a one-line preview of the ayah.
class AyahResultTile extends StatelessWidget {
  final AyahSearchResult result;
  final VoidCallback onTap;

  const AyahResultTile({super.key, required this.result, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            StarBadge(number: result.ayah.numberInSurah, size: 40.r),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سورة ${result.surah.nameArabic}',
                    style: AppTextStyle.small.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    ayahSnippet(result.ayah.text),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.quranAyah.copyWith(
                      fontSize: 18.sp,
                      height: 1.75,
                      color: scheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
