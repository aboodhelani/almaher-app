import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/router/app_route_enum.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../../core/utils/arabic_numbers.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/app_notifier.dart';
import '../../../../core/utils/injections.dart';
import '../../../../core/utils/quran_index.dart';
import '../../../../shared/presentation/widgets/app_loader.dart';
import '../../../../shared/presentation/widgets/reload_widget.dart';
import '../../../bookmarks/domain/models/bookmark_model.dart';
import '../../../bookmarks/presentation/bloc/bookmarks_bloc.dart';
import '../../../bookmarks/presentation/widgets/save_page_sheet.dart';
import '../../../library/presentation/bloc/library_bloc.dart';
import '../../../library/presentation/recitation_player.dart';
import '../../../mutashabihat/domain/usecases/get_similar_ayahs_usecase.dart';
import '../../../mutashabihat/presentation/widgets/similar_ayahs_sheet.dart';
import '../../domain/models/ayah_model.dart';
import '../../domain/models/quran_location.dart';
import '../bloc/quran_bloc.dart';
import '../widgets/quran_page_widget.dart';
import '../widgets/surah_index_sheet.dart';

class QuranReaderPage extends StatefulWidget {
  const QuranReaderPage({super.key});

  @override
  State<QuranReaderPage> createState() => _QuranReaderPageState();
}

class _QuranReaderPageState extends State<QuranReaderPage> {
  PageController? _pageController;

  /// The minimum shared words the colouring was last requested for.
  int? _requestedMinWords;

  late final RecitationPlayer _player = context.read<RecitationPlayer>();

  /// The recited ayah the reader last followed.
  String? _followedAyahKey;

  /// The top bar; a tap on the page shows or hides it.
  bool _barVisible = true;

  void _onPageTap() {
    context.read<QuranBloc>().add(const QuranHighlightCleared());
    setState(() => _barVisible = !_barVisible);
  }

  @override
  void initState() {
    super.initState();
    _player.addListener(_followRecitation);
  }

  @override
  void dispose() {
    _player.removeListener(_followRecitation);
    _pageController?.dispose();
    super.dispose();
  }

  /// Turns to the ayah being recited and highlights it.
  void _followRecitation() {
    final key = _player.ayahKey;
    if (key == _followedAyahKey) return;
    _followedAyahKey = key;
    final bloc = context.read<QuranBloc>();
    final state = bloc.state;
    if (state is! QuranLoaded) return;
    if (key == null) {
      bloc.add(const QuranHighlightCleared());
      return;
    }
    final surah = _player.surah!;
    final ayah = _player.ayah!;
    var page = state.quran.surah(surah).startPage;
    while (page < state.quran.pages.length &&
        !state.quran
            .page(page)
            .ayahs
            .any((a) => a.surahNumber == surah && a.numberInSurah == ayah)) {
      page++;
    }
    if (page != state.currentPage) _pageController?.jumpToPage(page - 1);
    bloc.add(QuranAyahHighlighted(key));
  }

  Future<void> _openSurahIndex(QuranLoaded state) async {
    final surah = await SurahIndexSheet.show(
      context,
      surahs: state.quran.surahs,
      currentSurahNumber: state.quran.page(state.currentPage).firstSurahNumber,
    );
    if (surah != null) _pageController?.jumpToPage(surah.startPage - 1);
  }

  /// Highlights [ayah] and shows the places it repeats, then its tajweed
  /// rules; picking a similar ayah jumps there and highlights it.
  Future<void> _openSimilar(QuranLoaded state, AyahModel ayah) async {
    final bloc = context.read<QuranBloc>();
    final minWords = context.read<AppNotifier>().similarMinWords;
    bloc.add(QuranAyahHighlighted(ayah.key));
    final location = await SimilarAyahsSheet.show(
      context,
      ayah: ayah,
      surah: state.quran.surah(ayah.surahNumber),
      minWords: minWords,
      similar: sl<GetSimilarAyahsUseCase>().call(
        SimilarAyahsParams(ayahKey: ayah.key, minWords: minWords),
      ),
      tajweed: state.tajweed?.forAyah(ayah.key),
    );
    final ayahKey = location?.ayahKey;
    if (location == null || ayahKey == null || !mounted) return;
    _pageController?.jumpToPage(location.page - 1);
    bloc.add(QuranAyahHighlighted(ayahKey));
  }

  /// Opens the saved pages; a picked one opens here.
  Future<void> _openSavedPages() async {
    final page = await Navigator.pushNamed<int>(
      context,
      AppRouteEnum.savedPages.name,
      arguments: true,
    );
    if (page == null || !mounted) return;
    _pageController?.jumpToPage(page - 1);
    context.read<QuranBloc>().add(const QuranHighlightCleared());
  }

  /// Opens search; a picked result jumps to its page and, for an ayah,
  /// highlights it.
  Future<void> _openSearch() async {
    final location = await Navigator.pushNamed<QuranLocation>(
      context,
      AppRouteEnum.search.name,
    );
    if (location == null || !mounted) return;
    _pageController?.jumpToPage(location.page - 1);
    final bloc = context.read<QuranBloc>();
    final ayahKey = location.ayahKey;
    bloc.add(
      ayahKey == null
          ? const QuranHighlightCleared()
          : QuranAyahHighlighted(ayahKey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranBloc, QuranState>(
      // The PageView keeps its own position; rebuild for the app bar and for
      // highlight changes, not for every state copy.
      buildWhen: (prev, next) =>
          prev.runtimeType != next.runtimeType ||
          (prev is QuranLoaded &&
              next is QuranLoaded &&
              (prev.currentPage != next.currentPage ||
                  prev.highlightedAyahKey != next.highlightedAyahKey ||
                  prev.mutashabihat != next.mutashabihat)),
      builder: (context, state) {
        final bar = AppBar(
            primary: false,
            titleSpacing: 0,
            title: state is QuranLoaded
                ? _ReaderTitle(state: state)
                : Text(S.of(context).quran),
            actions: [
              if (state is QuranLoaded) _SaveButton(state: state),
              if (state is QuranLoaded)
                IconButton(
                  tooltip: S.of(context).search,
                  icon: const Icon(Icons.search_rounded),
                  onPressed: _openSearch,
                ),
              if (state is QuranLoaded)
                IconButton(
                  tooltip: S.of(context).surahs_index,
                  icon: const Icon(Icons.format_list_bulleted_rounded),
                  onPressed: () => _openSurahIndex(state),
                ),
              PopupMenuButton<AppRouteEnum>(
                tooltip: S.of(context).reader_more,
                icon: const Icon(Icons.more_vert_rounded),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onSelected: (route) => route == AppRouteEnum.savedPages
                    ? _openSavedPages()
                    : Navigator.pushNamed(context, route.name),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: AppRouteEnum.savedPages,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.collections_bookmark_outlined),
                      title: Text(S.of(context).saved_pages),
                    ),
                  ),
                  PopupMenuItem(
                    value: AppRouteEnum.library,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.download_for_offline_outlined),
                      title: Text(S.of(context).library),
                    ),
                  ),
                  PopupMenuItem(
                    value: AppRouteEnum.settings,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.settings_outlined),
                      title: Text(S.of(context).settings),
                    ),
                  ),
                ],
              ),
            ],
          );
        final scheme = Theme.of(context).colorScheme;
        // The bar floats over the page and slides away on a tap, so the
        // page itself never moves.
        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                // Room for the bar at the top (shown or not) and a margin at
                // the bottom, so the bar never covers the page.
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: kToolbarHeight + 6,
                      bottom: 10,
                    ),
                    child: _buildBody(context, state),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedSlide(
                  offset: _barVisible ? Offset.zero : const Offset(0, -1),
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  child: AnimatedOpacity(
                    opacity: _barVisible ? 1 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: Material(
                      color: scheme.surface,
                      elevation: 2,
                      shadowColor: Colors.black26,
                      child: SafeArea(
                        bottom: false,
                        child: SizedBox(height: kToolbarHeight, child: bar),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: const _MiniPlayer(),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, QuranState state) {
    if (state is QuranError) {
      return ReloadWidget(
        message: S.of(context).failed_to_load_quran,
        onRetry: () => context.read<QuranBloc>().add(const QuranStarted()),
      );
    }
    if (state is! QuranLoaded) {
      _requestedMinWords = null; // request again once loaded
      return const AppLoader();
    }

    final showTajweed = context.select<AppNotifier, bool>((n) => n.showTajweed);
    final showSimilar = context.select<AppNotifier, bool>((n) => n.showSimilar);
    final minWords = context.select<AppNotifier, int>((n) => n.similarMinWords);
    if (minWords != _requestedMinWords) {
      _requestedMinWords = minWords;
      final bloc = context.read<QuranBloc>();
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => bloc.add(QuranMutashabihatRequested(minWords)),
      );
    }
    final controller = _pageController ??= PageController(
      initialPage: state.initialPage - 1,
    );
    // In RTL the next page slides in from the left, as in a printed mushaf.
    return PageView.builder(
      controller: controller,
      itemCount: state.quran.pages.length,
      onPageChanged: (index) =>
          context.read<QuranBloc>().add(QuranPageChanged(index + 1)),
      itemBuilder: (context, index) => QuranPageWidget(
        quran: state.quran,
        page: state.quran.pages[index],
        highlightedAyahKey: state.highlightedAyahKey,
        tajweed: showTajweed ? state.tajweed : null,
        mutashabihat: showSimilar ? state.mutashabihat : null,
        // Only long press acts on an ayah; a tap clears the highlight and
        // shows or hides the top bar.
        onAyahTap: (_) => _onPageTap(),
        onAyahLongPress: (ayah) => _openSimilar(state, ayah),
        onClearHighlight: _onPageTap,
      ),
    );
  }
}

/// The surah on the current page, with its page and juz.
class _ReaderTitle extends StatelessWidget {
  final QuranLoaded state;

  const _ReaderTitle({required this.state});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    final page = state.quran.page(state.currentPage);
    final surah = state.quran.surah(page.firstSurahNumber);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          surah.nameArabic,
          style: AppTextStyle.quranSurahTitle.copyWith(
            fontSize: 20.sp,
            color: scheme.onSurface,
            height: 1.1,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          '${s.page} ${state.currentPage.toArabicDigits} · ${s.juz} ${page.juz.toArabicDigits}',
          textDirection: TextDirection.rtl,
          style: AppTextStyle.xSmall.copyWith(
            color: scheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

/// Saves the current page, or unsaves it; filled in the accent when saved.
class _SaveButton extends StatelessWidget {
  final QuranLoaded state;

  const _SaveButton({required this.state});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    final page = state.currentPage;
    final saved = context.select<BookmarksBloc, bool>(
      (b) => b.state.isSaved(page),
    );
    return IconButton(
      tooltip: s.save_page,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, anim) =>
            ScaleTransition(scale: anim, child: child),
        child: Icon(
          saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          key: ValueKey(saved),
          color: saved ? scheme.primary : null,
        ),
      ),
      onPressed: () {
        HapticFeedback.selectionClick();
        final pageModel = state.quran.page(page);
        final bookmark = BookmarkModel(
          page: page,
          surahName: state.quran.surah(pageModel.firstSurahNumber).nameArabic,
          juz: pageModel.juz,
          savedAt: DateTime.now(),
        );
        if (!saved) {
          // Not saved yet: choose its group.
          SavePageSheet.show(context, bookmark);
          return;
        }
        context.read<BookmarksBloc>().add(BookmarkRemoved(page));
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              content: Text(s.page_unsaved(page.toArabicDigits)),
            ),
          );
      },
    );
  }
}

/// The recitation playing now: reciter, surah and ayah, with previous /
/// play-pause / next and close. Hidden when nothing plays.
class _MiniPlayer extends StatelessWidget {
  const _MiniPlayer();

  @override
  Widget build(BuildContext context) {
    final player = context.watch<RecitationPlayer>();
    final scheme = Theme.of(context).colorScheme;
    final s = S.of(context);
    final surah = player.surah;
    final ayah = player.ayah;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: surah == null || ayah == null
          ? const SizedBox(width: double.infinity)
          : SafeArea(
              top: false,
              child: Container(
                margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 8.h),
                padding: EdgeInsets.fromLTRB(14.w, 6.h, 4.w, 6.h),
                decoration: BoxDecoration(
                  color: scheme.inverseSurface,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.graphic_eq_rounded, color: scheme.primaryContainer),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.select<LibraryBloc, String>(
                              (b) => b.state.reciterName(player.reciter ?? ''),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.small.copyWith(
                              color: scheme.onInverseSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'سورة ${surahNamesArabic[surah - 1]} · ${s.ayah_label} ${ayah.toArabicDigits}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.xSmall.copyWith(
                              color: scheme.onInverseSurface.withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // In Arabic "previous" sits on the right and points right,
                    // "next" on the left and points left.
                    IconButton(
                      color: scheme.onInverseSurface,
                      icon: Icon(
                        rtl ? Icons.skip_next_rounded : Icons.skip_previous_rounded,
                      ),
                      onPressed: player.previous,
                    ),
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: scheme.primaryContainer,
                        foregroundColor: scheme.onPrimaryContainer,
                      ),
                      icon: Icon(
                        player.playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      ),
                      onPressed: player.toggle,
                    ),
                    IconButton(
                      color: scheme.onInverseSurface,
                      icon: Icon(
                        rtl ? Icons.skip_previous_rounded : Icons.skip_next_rounded,
                      ),
                      onPressed: player.next,
                    ),
                    IconButton(
                      color: scheme.onInverseSurface,
                      icon: const Icon(Icons.close_rounded),
                      onPressed: player.stop,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
