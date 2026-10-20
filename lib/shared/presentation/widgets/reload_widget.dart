import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/styles/app_text_style.dart';
import '../../../core/translations/l10n.dart';
import '../../../core/widgets/icon_badge.dart';

class ReloadWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ReloadWidget({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconBadge(Icons.wifi_tethering_error_rounded, size: 64.r),
            SizedBox(height: 16.h),
            Text(
              message,
              style: AppTextStyle.large.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(S.of(context).retry),
            ),
          ],
        ),
      ),
    );
  }
}
