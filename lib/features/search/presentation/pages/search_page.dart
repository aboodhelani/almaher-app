import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/app_notifier.dart';
import '../../../../core/widgets/icon_badge.dart';
import '../../../../shared/presentation/widgets/app_loader.dart';
import '../../../quran/domain/models/quran_location.dart';
import '../../../quran/presentation/widgets/surah_index_sheet.dart';
import '../../domain/models/search_results_model.dart';
import '../bloc/search_bloc.dart';
import '../widgets/arabic_keyboard.dart';
import '../widgets/ayah_result_tile.dart';
import '../widgets/search_section_header.dart';
import '../widgets/surah_filter_chip.dart';
import '../widgets/surah_result_tile.dart';

/// Searches surah names and ayahs. Pops with the [QuranLocation] to open.
///
/// A surah filter limits the search to one surah, where a number picks the
/// ayah with that number.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  Timer? _debounce;

  /// The in-app keyboard was asked for (it shows once the system keyboard
  /// is down).
  bool _inAppOpen = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (_focus.hasFocus) {
        _showKeyboard();
      } else {
        setState(() => _inAppOpen = false);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  /// Brings up the chosen keyboard for the field (also when it is already
  /// focused but its keyboard was closed).
  void _showKeyboard() {
    if (!_focus.hasFocus) {
      _focus.requestFocus(); // the focus listener calls back here
      return;
    }
    if (context.read<AppNotifier>().useTashkeelKeyboard) {
      setState(() => _inAppOpen = true);
    } else {
      setState(() => _inAppOpen = false);
      // Reopens the system keyboard if it was closed while focused.
      SystemChannels.textInput.invokeMethod<void>('TextInput.show');
    }
  }

  /// Switches between the system keyboard and the in-app tashkeel keyboard.
  /// To the in-app one: the field turns read-only, which closes the system
  /// keyboard, and the in-app one shows once it is down. To the system one:
  /// iOS only raises its keyboard on a fresh focus, so the field is
  /// refocused on the next frame.
  void _setTashkeelKeyboard(bool use) {
    context.read<AppNotifier>().updateUseTashkeelKeyboard(use);
    if (use) {
      if (_focus.hasFocus) {
        setState(() => _inAppOpen = true);
      } else {
        _focus.requestFocus();
      }
      return;
    }
    _focus.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focus.requestFocus();
    });
  }

  void _onChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      context.read<SearchBloc>().add(SearchQueryChanged(query));
    });
  }

  void _clear() {
    _controller.clear();
    _onChanged('');
  }

  Future<void> _pickSurah(SearchState state) async {
    if (state.surahs.isEmpty) return;
    final bloc = context.read<SearchBloc>();
    final surah = await SurahIndexSheet.show(
      context,
      surahs: state.surahs,
      currentSurahNumber: state.surahFilter?.number,
    );
    if (surah != null) bloc.add(SearchSurahFilterChanged(surah));
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    final state = context.watch<SearchBloc>().state;
    final filter = state.surahFilter;
    final tashkeel = context.watch<AppNotifier>().useTashkeelKeyboard;
    // Shown only once the system keyboard is fully down, so the two never
    // overlap while one slides away.
    final systemKeyboardUp = MediaQuery.viewInsetsOf(context).bottom > 0;
    return Scaffold(
      bottomNavigationBar:
          tashkeel && _inAppOpen && _focus.hasFocus && !systemKeyboardUp
          ? ArabicKeyboard(
              controller: _controller,
              onChanged: _onChanged,
              onUseSystem: () => _setTashkeelKeyboard(false),
              onDone: _focus.unfocus,
            )
          : null,
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsetsDirectional.only(end: 16.w),
          child: TextField(
            controller: _controller,
            focusNode: _focus,
            autofocus: true,
            // With the in-app keyboard the field takes no system input.
            readOnly: tashkeel,
            showCursor: true,
            onTap: _showKeyboard,
            textInputAction: TextInputAction.search,
            onChanged: _onChanged,
            style: AppTextStyle.medium.copyWith(color: scheme.onSurface),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              hintText: filter == null ? s.search_hint : s.search_in_surah_hint,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: ValueListenableBuilder(
                valueListenable: _controller,
                builder: (context, value, _) => value.text.isEmpty
                    ? const SizedBox.shrink()
                    : IconButton(
                        icon: const Icon(Icons.cancel_rounded),
                        color: scheme.onSurfaceVariant,
                        onPressed: _clear,
                      ),
              ),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.h),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.w, 0, 16.w, 10.h),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SurahFilterChip(
                      surah: filter,
                      onTap: () => _pickSurah(state),
                      onClear: () => context.read<SearchBloc>().add(
                        const SearchSurahFilterChanged(null),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    FilterChip(
                      selected: tashkeel,
                      showCheckmark: false,
                      avatar: Icon(
                        Icons.keyboard_alt_outlined,
                        size: 18.r,
                        color: tashkeel ? scheme.primary : scheme.onSurface,
                      ),
                      label: Text(s.search_tashkeel_keyboard),
                      onSelected: _setTashkeelKeyboard,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: switch (state) {
        SearchLoading() => const AppLoader(),
        SearchError() => _Message(
          icon: Icons.error_outline_rounded,
          text: s.search_failed,
        ),
        SearchLoaded(:final results) when results.isEmpty => _Message(
          icon: Icons.search_off_rounded,
          text: s.search_no_results,
        ),
        SearchLoaded(:final results) => _ResultsList(results: results),
        _ => _Message(
          icon: filter == null
              ? Icons.manage_search_rounded
              : Icons.format_list_numbered_rounded,
          text: filter == null
              ? s.search_start_hint
              : s.search_in_surah_start_hint,
        ),
      },
    );
  }
}

class _ResultsList extends StatelessWidget {
  final SearchResultsModel results;

  const _ResultsList({required this.results});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final items = <Widget Function()>[];

    void section(String title, int count, List<Widget Function()> rows) {
      if (count == 0) return;
      items.add(() => SearchSectionHeader(title: title, count: count));
      items.addAll(rows);
    }

    void open(QuranLocation location) => Navigator.of(context).pop(location);

    final byNumber = results.ayahByNumber;
    if (byNumber != null) {
      section(s.search_ayah, 1, [
        () => AyahResultTile(
          result: byNumber,
          onTap: () => open(
            QuranLocation(page: byNumber.ayah.page, ayahKey: byNumber.ayah.key),
          ),
        ),
      ]);
    }
    section(s.search_surahs, results.surahs.length, [
      for (final surah in results.surahs)
        () => SurahResultTile(
          surah: surah,
          onTap: () => open(QuranLocation(page: surah.startPage)),
        ),
    ]);
    section(s.search_full_match, results.fullMatches.length, [
      for (final r in results.fullMatches)
        () => AyahResultTile(
          result: r,
          onTap: () =>
              open(QuranLocation(page: r.ayah.page, ayahKey: r.ayah.key)),
        ),
    ]);
    section(s.search_partial_match, results.partialMatches.length, [
      for (final r in results.partialMatches)
        () => AyahResultTile(
          result: r,
          onTap: () =>
              open(QuranLocation(page: r.ayah.page, ayahKey: r.ayah.key)),
        ),
    ]);

    // Rows are built lazily: a short query can match thousands of ayahs.
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(bottom: 24.h),
      itemCount: items.length,
      itemBuilder: (context, index) => items[index](),
    );
  }
}

class _Message extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Message({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.all(32.w),
      child: Align(
        alignment: const Alignment(0, -0.45),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconBadge(icon, size: 72.r),
            SizedBox(height: 18.h),
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyle.medium.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
