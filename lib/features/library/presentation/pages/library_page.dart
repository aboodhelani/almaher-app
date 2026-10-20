import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/router/app_route_enum.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/arabic_numbers.dart';
import '../../domain/models/library_models.dart';
import '../bloc/library_bloc.dart';
import '../widgets/library_failure_listener.dart';

/// Tafsirs, translations and reciters to download, use or delete.
class LibraryPage extends StatefulWidget {
  final int initialTab;

  const LibraryPage({super.key, this.initialTab = 0});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  void initState() {
    super.initState();
    context.read<LibraryBloc>().add(const LibraryCatalogRequested());
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return LibraryFailureListener(
      child: DefaultTabController(
        length: 3,
        initialIndex: widget.initialTab.clamp(0, 2),
        child: Scaffold(
          appBar: AppBar(
            title: Text(s.library),
            bottom: TabBar(
              tabs: [
                Tab(text: s.library_tafsirs),
                Tab(text: s.library_translations),
                Tab(text: s.library_reciters),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              _EditionsTab(type: EditionType.tafsir),
              _EditionsTab(type: EditionType.translation),
              _RecitersTab(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown above a list when the catalog could not be loaded.
class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      padding: EdgeInsets.fromLTRB(14.w, 6.h, 6.w, 6.h),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off_rounded, color: scheme.onErrorContainer, size: 20.r),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              S.of(context).library_offline,
              style: AppTextStyle.small.copyWith(color: scheme.onErrorContainer),
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: scheme.onErrorContainer),
            onPressed: () => context.read<LibraryBloc>().add(
              const LibraryCatalogRequested(force: true),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditionsTab extends StatefulWidget {
  final EditionType type;

  const _EditionsTab({required this.type});

  @override
  State<_EditionsTab> createState() => _EditionsTabState();
}

class _EditionsTabState extends State<_EditionsTab>
    with AutomaticKeepAliveClientMixin {
  String _query = '';

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final s = S.of(context);
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        final catalog = state.catalog;
        final online = catalog == null
            ? const <EditionModel>[]
            : widget.type == EditionType.tafsir
            ? catalog.tafsirs
            : catalog.translations;
        // What is on the device first, then the rest of the catalog.
        final local = state.editionsOf(widget.type);
        final all = [
          ...local,
          ...online.where((e) => !state.hasEdition(e.identifier)),
        ];
        final q = _query.trim().toLowerCase();
        final shown = q.isEmpty
            ? all
            : all
                  .where(
                    (e) =>
                        e.name.toLowerCase().contains(q) ||
                        e.englishName.toLowerCase().contains(q) ||
                        e.language.toLowerCase() == q,
                  )
                  .toList();
        return Column(
          children: [
            if (state.catalogError) const _OfflineBanner(),
            if (widget.type == EditionType.translation)
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: s.library_search,
                    prefixIcon: const Icon(Icons.search_rounded),
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
            if (state.catalogLoading) const LinearProgressIndicator(),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: shown.length,
                separatorBuilder: (_, _) => Divider(height: 1, indent: 16.w, endIndent: 16.w),
                itemBuilder: (context, i) => _EditionTile(edition: shown[i]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EditionTile extends StatelessWidget {
  final EditionModel edition;

  const _EditionTile({required this.edition});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    final state = context.watch<LibraryBloc>().state;
    final id = edition.identifier;
    final local = state.hasEdition(id);
    final downloading = state.downloadingEditions.contains(id);
    final sel = state.selection;
    final inUse = sel.tafsir == id || sel.translation == id;
    final bloc = context.read<LibraryBloc>();

    final Widget trailing;
    if (downloading) {
      trailing = SizedBox(
        width: 24.r,
        height: 24.r,
        child: const CircularProgressIndicator(strokeWidth: 2.5),
      );
    } else if (!local) {
      trailing = IconButton(
        tooltip: s.library_download,
        icon: Icon(Icons.download_rounded, color: scheme.primary),
        onPressed: () => bloc.add(EditionDownloadRequested(edition)),
      );
    } else if (edition.bundled) {
      trailing = _Chip(text: s.library_bundled);
    } else {
      trailing = IconButton(
        tooltip: s.library_delete,
        icon: Icon(Icons.delete_outline_rounded, color: scheme.error),
        onPressed: () async {
          if (await confirmDelete(context, edition.name)) {
            bloc.add(EditionDeleted(id));
          }
        },
      );
    }

    return ListTile(
      leading: Icon(
        inUse ? Icons.check_circle_rounded : Icons.circle_outlined,
        color: inUse ? scheme.primary : scheme.outlineVariant,
      ),
      title: Text(
        edition.name,
        textDirection: edition.rtl ? TextDirection.rtl : TextDirection.ltr,
        style: AppTextStyle.medium.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${edition.englishName} · ${edition.language}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyle.xSmall.copyWith(color: scheme.onSurfaceVariant),
      ),
      trailing: trailing,
      // A tap on something on the device makes it the one the reader uses.
      onTap: local
          ? () => bloc.add(
              edition.type == EditionType.tafsir
                  ? LibrarySelectionChanged(tafsir: id)
                  : LibrarySelectionChanged(translation: id),
            )
          : null,
    );
  }
}

class _RecitersTab extends StatelessWidget {
  const _RecitersTab();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        final ids = <String>{
          ...state.downloadedReciters(),
          for (final r in state.catalog?.reciters ?? const <ReciterModel>[]) r.identifier,
        }.toList();
        return Column(
          children: [
            if (state.catalogError) const _OfflineBanner(),
            if (state.catalogLoading) const LinearProgressIndicator(),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: ids.length,
                separatorBuilder: (_, _) => Divider(height: 1, indent: 16.w, endIndent: 16.w),
                itemBuilder: (context, i) {
                  final id = ids[i];
                  final count = state.surahs[id]?.length ?? 0;
                  final inUse = state.selection.reciter == id;
                  return ListTile(
                    leading: Icon(
                      inUse ? Icons.check_circle_rounded : Icons.circle_outlined,
                      color: inUse ? scheme.primary : scheme.outlineVariant,
                    ),
                    title: Text(
                      state.reciterName(id),
                      style: AppTextStyle.medium.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: count == 0
                        ? null
                        : Text(
                            s.library_surahs_count(count.toArabicDigits),
                            style: AppTextStyle.xSmall.copyWith(
                              color: scheme.primary,
                            ),
                          ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRouteEnum.reciterSurahs.name,
                      arguments: id,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;

  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: AppTextStyle.xSmall.copyWith(color: scheme.onSurfaceVariant),
      ),
    );
  }
}

Future<bool> confirmDelete(BuildContext context, String name) async {
  final s = S.of(context);
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(s.library_delete_confirm(name)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(s.library_delete),
        ),
      ],
    ),
  );
  return ok == true;
}
