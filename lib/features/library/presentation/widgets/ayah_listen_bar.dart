import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/router/app_route_enum.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/arabic_numbers.dart';
import '../../../../core/utils/quran_index.dart';
import '../../../quran/domain/models/ayah_model.dart';
import '../bloc/library_bloc.dart';
import '../recitation_player.dart';
import 'library_dropdown.dart';

/// The top of the ayah sheet: pick a reciter, then listen from this ayah
/// (or download the surah first, with its progress).
class AyahListenBar extends StatelessWidget {
  final AyahModel ayah;

  const AyahListenBar({super.key, required this.ayah});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        final reciter = state.selection.reciter;
        final surah = ayah.surahNumber;
        final downloaded = state.hasSurah(reciter, surah);
        final progress = state.progressOf(reciter, surah);
        final Widget action;
        if (downloaded) {
          action = FilledButton.icon(
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(s.recitation_play_from),
            onPressed: () async {
              final started = await context.read<RecitationPlayer>().play(
                reciter: reciter,
                surah: surah,
                ayahCount: surahAyahCounts[surah - 1],
                fromAyah: ayah.numberInSurah,
              );
              if (started && context.mounted) Navigator.of(context).pop();
            },
          );
        } else if (progress != null) {
          action = Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                s.recitation_downloading('${(progress * 100).round().toArabicDigits}٪'),
                textAlign: TextAlign.center,
                style: AppTextStyle.small.copyWith(color: scheme.onSurfaceVariant),
              ),
              SizedBox(height: 6.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: progress == 0 ? null : progress,
                  minHeight: 6.h,
                ),
              ),
            ],
          );
        } else {
          action = OutlinedButton.icon(
            icon: const Icon(Icons.download_rounded),
            label: Text(s.recitation_download_surah),
            onPressed: () => context.read<LibraryBloc>().add(
              SurahDownloadRequested(reciter, surah),
            ),
          );
        }
        return Container(
          margin: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.headphones_rounded, size: 20.r, color: scheme.primary),
                  SizedBox(width: 8.w),
                  Text(
                    s.recitation_reciter,
                    style: AppTextStyle.small.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: LibraryDropdown(
                      value: reciter,
                      items: {
                        for (final r in state.downloadedReciters()) r: state.reciterName(r),
                      },
                      onChanged: (r) => context.read<LibraryBloc>().add(
                        LibrarySelectionChanged(reciter: r),
                      ),
                      onMore: () => Navigator.pushNamed(
                        context,
                        AppRouteEnum.library.name,
                        arguments: 2,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              action,
            ],
          ),
        );
      },
    );
  }
}
