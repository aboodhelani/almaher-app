import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/constant/app_constants.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/app_logo.dart';

/// The app, its privacy policy and where its content comes from.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(s.about)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 40.h),
        children: [
          Center(child: AppLogo(size: 96.r)),
          SizedBox(height: 10.h),
          Text(
            'الماهر',
            textAlign: TextAlign.center,
            style: AppTextStyle.display.copyWith(color: scheme.onSurface),
          ),
          Text(
            s.about_tagline,
            textAlign: TextAlign.center,
            style: AppTextStyle.small.copyWith(color: scheme.onSurfaceVariant),
          ),
          SizedBox(height: 4.h),
          Text(
            s.about_version(appVersion),
            textAlign: TextAlign.center,
            style: AppTextStyle.xSmall.copyWith(color: scheme.onSurfaceVariant),
          ),
          SectionLabel(s.privacy_title),
          _Paragraph(
            icon: Icons.menu_book_outlined,
            title: s.privacy_reading_title,
            body: s.privacy_reading_body,
          ),
          _Paragraph(
            icon: Icons.person_outline_rounded,
            title: s.privacy_account_title,
            body: s.privacy_account_body,
          ),
          _Paragraph(
            icon: Icons.videocam_outlined,
            title: s.privacy_media_title,
            body: s.privacy_media_body,
          ),
          _Paragraph(
            icon: Icons.delete_outline_rounded,
            title: s.privacy_delete_title,
            body: s.privacy_delete_body,
          ),
          SectionLabel(s.sources_title),
          _Paragraph(
            icon: Icons.source_outlined,
            title: s.sources_title,
            body: s.sources_body,
          ),
        ],
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _Paragraph({required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22.r, color: scheme.primary),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.medium.copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  body,
                  style: AppTextStyle.small.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
