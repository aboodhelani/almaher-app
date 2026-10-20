import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/arabic_numbers.dart';
import '../../../../core/utils/quran_index.dart';
import '../bloc/library_bloc.dart';
import '../widgets/library_failure_listener.dart';
import 'library_page.dart';

/// One reciter's 114 surahs: download each (with progress), or delete it.
class ReciterSurahsPage extends StatelessWidget {
  final String reciter;

  const ReciterSurahsPage({super.key, required this.reciter});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    return LibraryFailureListener(
      child: BlocBuilder<LibraryBloc, LibraryState>(
        builder: (context, state) {
          final bloc = context.read<LibraryBloc>();
          final inUse = state.selection.reciter == reciter;
          final count = state.surahs[reciter]?.length ?? 0;
          return Scaffold(
            appBar: AppBar(title: Text(state.reciterName(reciter))),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          s.library_surahs_count(count.toArabicDigits),
                          style: AppTextStyle.small.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      inUse
                          ? FilledButton.tonalIcon(
                              onPressed: null,
                              icon: const Icon(Icons.check_rounded),
                              label: Text(s.library_in_use),
                            )
                          : FilledButton.icon(
                              onPressed: () => bloc.add(
                                LibrarySelectionChanged(reciter: reciter),
                              ),
                              icon: const Icon(Icons.headphones_rounded),
                              label: Text(s.library_use),
                            ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: 114,
                    itemBuilder: (context, i) {
                      final surah = i + 1;
                      final has = state.hasSurah(reciter, surah);
                      final progress = state.progressOf(reciter, surah);
                      final Widget trailing;
                      if (progress != null) {
                        trailing = SizedBox(
                          width: 28.r,
                          height: 28.r,
                          child: CircularProgressIndicator(
                            value: progress == 0 ? null : progress,
                            strokeWidth: 3,
                          ),
                        );
                      } else if (has) {
                        trailing = IconButton(
                          tooltip: s.library_delete,
                          icon: Icon(Icons.delete_outline_rounded, color: scheme.error),
                          onPressed: () async {
                            final name = 'سورة ${surahNamesArabic[i]}';
                            if (await confirmDelete(context, name)) {
                              bloc.add(SurahDeleted(reciter, surah));
                            }
                          },
                        );
                      } else {
                        trailing = IconButton(
                          tooltip: s.library_download,
                          icon: Icon(Icons.download_rounded, color: scheme.primary),
                          onPressed: () => bloc.add(SurahDownloadRequested(reciter, surah)),
                        );
                      }
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 16.r,
                          backgroundColor: has
                              ? scheme.primary
                              : scheme.surfaceContainerHighest,
                          child: Text(
                            surah.toArabicDigits,
                            style: AppTextStyle.xSmall.copyWith(
                              color: has ? scheme.onPrimary : scheme.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        title: Text(
                          'سورة ${surahNamesArabic[i]}',
                          style: AppTextStyle.quranSurahTitle.copyWith(
                            fontSize: 18.sp,
                            color: scheme.onSurface,
                          ),
                        ),
                        subtitle: Text(
                          '${surahAyahCounts[i].toArabicDigits} ${s.ayah_label}',
                          style: AppTextStyle.xSmall.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        trailing: trailing,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
