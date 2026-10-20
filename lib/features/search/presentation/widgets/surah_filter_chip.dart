import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';
import '../../../quran/domain/models/surah_model.dart';

/// Shows which surah the search is limited to ("كل السور" when none).
/// Tap to pick a surah; the ✕ goes back to the whole Quran.
class SurahFilterChip extends StatelessWidget {
  final SurahModel? surah;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const SurahFilterChip({
    super.key,
    required this.surah,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    final selected = surah != null;
    final foreground = selected ? scheme.onPrimary : scheme.onSurface;

    return Material(
      color: selected ? scheme.primary : scheme.surfaceContainer,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(14.w, 8.h, 10.w, 8.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.filter_list_rounded, size: 18.sp, color: foreground),
              SizedBox(width: 6.w),
              Text(
                selected ? 'سورة ${surah!.nameArabic}' : s.search_all_surahs,
                style: AppTextStyle.small.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4.w),
              if (selected)
                InkResponse(
                  onTap: onClear,
                  radius: 16.r,
                  child: Icon(
                    Icons.close_rounded,
                    size: 18.sp,
                    color: foreground,
                  ),
                )
              else
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18.sp,
                  color: foreground,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
