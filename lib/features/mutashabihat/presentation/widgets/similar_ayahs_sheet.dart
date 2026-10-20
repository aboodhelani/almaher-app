import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/styles/quran_colors.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/arabic_numbers.dart';
import '../../../../core/network/error/failures.dart';
import '../../../../shared/presentation/widgets/app_loader.dart';
import '../../../library/domain/models/library_models.dart';
import '../../../library/presentation/widgets/ayah_edition_section.dart';
import '../../../library/presentation/widgets/ayah_listen_bar.dart';
import '../../../quran/domain/models/ayah_model.dart';
import '../../../quran/domain/models/quran_location.dart';
import '../../../quran/domain/models/surah_model.dart';
import '../../../tajweed/domain/models/tajweed_span_model.dart';
import '../../../tajweed/presentation/widgets/tajweed_details_sheet.dart';
import '../../domain/models/similar_ayahs_model.dart';

/// Everything about one ayah, opened by a long press: listening from it,
/// then two tabs — the other places it repeats (identical ayahs, then ayahs
/// sharing a phrase) with its tajweed rules, and its tafsir and translation. Pops with the [QuranLocation] of a similar ayah if one is tapped.
class SimilarAyahsSheet extends StatelessWidget {
  final AyahModel ayah;
  final SurahModel surah;
  final int minWords;
  final Future<Either<Failure, SimilarAyahsModel>> similar;

  /// The ayah's tajweed spans; `null` when they could not be loaded.
  final List<TajweedSpanModel>? tajweed;

  const SimilarAyahsSheet({
    super.key,
    required this.ayah,
    required this.surah,
    required this.minWords,
    required this.similar,
    required this.tajweed,
  });

  static Future<QuranLocation?> show(
    BuildContext context, {
    required AyahModel ayah,
    required SurahModel surah,
    required int minWords,
    required Future<Either<Failure, SimilarAyahsModel>> similar,
    required List<TajweedSpanModel>? tajweed,
  }) {
    return showModalBottomSheet<QuranLocation>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => SimilarAyahsSheet(
        ayah: ayah,
        surah: surah,
        minWords: minWords,
        similar: similar,
        tajweed: tajweed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Text(
              'سورة ${surah.nameArabic} · ${s.ayah_label} ${ayah.numberInSurah.toArabicDigits}',
              style: AppTextStyle.xLarge.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            AyahListenBar(ayah: ayah),
            TabBar(
              labelStyle: AppTextStyle.medium.copyWith(fontWeight: FontWeight.w700),
              unselectedLabelStyle: AppTextStyle.medium,
              tabs: [
                Tab(text: s.sheet_tab_similar),
                Tab(text: s.sheet_tab_tafsir),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  FutureBuilder(
                    future: similar,
                    builder: (context, snapshot) {
                      final result = snapshot.data;
                      return _DetailsList(
                        ayah: ayah,
                        minWords: minWords,
                        similar: result?.fold((_) => null, (model) => model),
                        loading: result == null,
                        tajweed: tajweed,
                      );
                    },
                  ),
                  ListView(
                    padding: EdgeInsets.only(top: 12.h, bottom: 24.h),
                    children: [
                      AyahEditionSection(ayah: ayah, type: EditionType.tafsir),
                      Divider(height: 32.h, color: scheme.outlineVariant),
                      AyahEditionSection(ayah: ayah, type: EditionType.translation),
                    ],
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

/// Similar ayahs first, then the tajweed rules, as one scrolling list.
class _DetailsList extends StatelessWidget {
  final AyahModel ayah;
  final int minWords;

  /// `null` while loading or if the search failed.
  final SimilarAyahsModel? similar;
  final bool loading;
  final List<TajweedSpanModel>? tajweed;

  const _DetailsList({
    required this.ayah,
    required this.minWords,
    required this.similar,
    required this.loading,
    required this.tajweed,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colors = context.quranColors;
    final scheme = Theme.of(context).colorScheme;
    final rows = <Widget Function()>[];

    // ── Similar ayahs ──
    rows.add(() => _GroupTitle(title: s.similar_ayahs));
    final similar = this.similar;
    if (loading) {
      rows.add(
        () => Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: const AppLoader(),
        ),
      );
    } else if (similar == null) {
      rows.add(() => _Note(text: s.similar_failed));
    } else if (similar.isEmpty) {
      rows.add(() => _Note(text: s.similar_none(minWords.toArabicDigits)));
    } else {
      void section(
        String title,
        Color swatch,
        List<SimilarAyahModel> items, {
        required bool full,
      }) {
        if (items.isEmpty) return;
        rows.add(
          () => _SectionHeader(
            title: '$title (${items.length.toArabicDigits})',
            swatch: swatch,
          ),
        );
        for (final item in items) {
          rows.add(() => _SimilarTile(item: item, swatch: swatch, full: full));
        }
      }

      section(
        s.similar_full,
        colors.similarFull,
        similar.fullMatches,
        full: true,
      );
      section(
        s.similar_partial,
        colors.similarPartial,
        similar.partialMatches,
        full: false,
      );
    }

    // ── Tajweed ──
    rows.add(() => Divider(height: 32.h, color: scheme.outlineVariant));
    rows.add(() => _GroupTitle(title: s.tajweed_details));
    final tajweed = this.tajweed;
    if (tajweed == null) {
      rows.add(() => _Note(text: s.tajweed_unavailable));
    } else if (tajweed.isEmpty) {
      rows.add(() => _Note(text: s.tajweed_no_rules));
    } else {
      final ordered = [...tajweed]..sort((a, b) => a.start.compareTo(b.start));
      for (var i = 0; i < ordered.length; i++) {
        final span = ordered[i];
        rows.add(
          () => Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
            child: TajweedRuleOccurrence(ayahText: ayah.text, span: span),
          ),
        );
        if (i < ordered.length - 1) {
          rows.add(() => Divider(height: 20.h, indent: 16.w, endIndent: 16.w));
        }
      }
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 8.h, bottom: 24.h),
      itemCount: rows.length,
      itemBuilder: (context, i) => rows[i](),
    );
  }
}

class _GroupTitle extends StatelessWidget {
  final String title;

  const _GroupTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 2.h),
      child: Text(
        title,
        style: AppTextStyle.large.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color swatch;

  const _SectionHeader({required this.title, required this.swatch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 4.h),
      child: Row(
        children: [
          Container(
            width: 14.r,
            height: 14.r,
            decoration: BoxDecoration(
              color: swatch,
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            title,
            style: AppTextStyle.small.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SimilarTile extends StatelessWidget {
  final SimilarAyahModel item;
  final Color swatch;
  final bool full;

  const _SimilarTile({
    required this.item,
    required this.swatch,
    required this.full,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      title: Text(
        'سورة ${item.surah.nameArabic} · ${s.ayah_label} ${item.ayah.numberInSurah.toArabicDigits}',
        style: AppTextStyle.large.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        item.sharedText,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyle.quranAyah.copyWith(
          fontSize: 17.sp,
          height: 1.8,
          color: context.quranColors.text,
          backgroundColor: swatch,
        ),
      ),
      trailing: full
          ? null
          : Text(
              s.similar_words(item.sharedWords.toArabicDigits),
              style: AppTextStyle.small.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
      onTap: () => Navigator.of(
        context,
      ).pop(QuranLocation(page: item.ayah.page, ayahKey: item.ayah.key)),
    );
  }
}

class _Note extends StatelessWidget {
  final String text;

  const _Note({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
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
