import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/router/app_route_enum.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/arabic_numbers.dart';
import '../../../../core/widgets/icon_badge.dart';
import '../../domain/models/bookmark_model.dart';
import '../bloc/bookmarks_bloc.dart';
import '../widgets/save_page_sheet.dart';

/// The saved mushaf pages in sections, one per group (the default group
/// first), newest first in each. Tap to open a page, swipe to remove it.
///
/// Opened from the reader ([pickForReader]) it pops with the page number;
/// opened from home it opens the reader at that page.
class SavedPagesPage extends StatelessWidget {
  final bool pickForReader;

  const SavedPagesPage({super.key, this.pickForReader = false});

  void _open(BuildContext context, int page) {
    if (pickForReader) {
      Navigator.pop(context, page);
    } else {
      Navigator.pushReplacementNamed(
        context,
        AppRouteEnum.quranReader.name,
        arguments: page,
      );
    }
  }

  void _remove(BuildContext context, BookmarkModel b) {
    final s = S.of(context);
    final bloc = context.read<BookmarksBloc>();
    bloc.add(BookmarkRemoved(b.page));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(s.page_unsaved(b.page.toArabicDigits)),
          action: SnackBarAction(
            label: s.undo,
            onPressed: () => bloc.add(BookmarkSaved(b, groupId: b.groupId)),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(s.saved_pages),
        actions: [
          IconButton(
            tooltip: s.group_new,
            icon: const Icon(Icons.create_new_folder_outlined),
            onPressed: () async {
              final bloc = context.read<BookmarksBloc>();
              final name = await askGroupName(context, action: s.group_create);
              if (name != null) bloc.add(BookmarkGroupCreated(name));
            },
          ),
        ],
      ),
      body: BlocBuilder<BookmarksBloc, BookmarksState>(
        builder: (context, state) {
          final list = state.bookmarks;
          if (list.isEmpty && state.groups.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(32.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconBadge(Icons.bookmark_add_outlined, size: 72.r),
                    SizedBox(height: 16.h),
                    Text(
                      s.saved_pages_empty,
                      style: AppTextStyle.large.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      s.saved_pages_empty_hint,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.medium.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          // The default group, then each named group with its pages.
          final rows = <Widget>[
            Padding(
              padding: EdgeInsetsDirectional.only(start: 4.w, bottom: 4.h),
              child: Text(
                s.saved_count(list.length.toArabicDigits),
                style: AppTextStyle.small.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ];
          void section(String? id, String name) {
            final pages = state.inGroup(id);
            if (id == null && pages.isEmpty) return;
            rows.add(
              _GroupHeader(
                name: name,
                count: pages.length,
                isDefault: id == null,
                onDelete: id == null
                    ? null
                    : () => _confirmDeleteGroup(context, id, name),
              ),
            );
            if (pages.isEmpty) {
              rows.add(
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 8.w, bottom: 8.h),
                  child: Text(
                    s.group_empty,
                    style: AppTextStyle.small.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ),
              );
            }
            for (final b in pages) {
              rows.add(
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Dismissible(
                    key: ValueKey(b.page),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => _remove(context, b),
                    background: Container(
                      alignment: AlignmentDirectional.centerEnd,
                      padding: EdgeInsetsDirectional.only(end: 24.w),
                      decoration: BoxDecoration(
                        color: scheme.error,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.white,
                      ),
                    ),
                    child: _SavedPageTile(
                      bookmark: b,
                      onTap: () => _open(context, b.page),
                      onRemove: () => _remove(context, b),
                    ),
                  ),
                ),
              );
            }
          }

          section(null, s.group_default);
          for (final g in state.groups) {
            section(g.id, g.name);
          }
          return ListView(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 32.h),
            children: rows,
          );
        },
      ),
    );
  }
}

Future<void> _confirmDeleteGroup(BuildContext context, String id, String name) async {
  final s = S.of(context);
  final bloc = context.read<BookmarksBloc>();
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(s.group_delete),
      content: Text(s.group_delete_body(name)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(s.cancel)),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
          onPressed: () => Navigator.pop(context, true),
          child: Text(s.group_delete),
        ),
      ],
    ),
  );
  if (ok == true) bloc.add(BookmarkGroupDeleted(id));
}

/// A group's name and page count, with a delete option for named groups.
class _GroupHeader extends StatelessWidget {
  final String name;
  final int count;
  final bool isDefault;
  final VoidCallback? onDelete;

  const _GroupHeader({
    required this.name,
    required this.count,
    required this.isDefault,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(4.w, 12.h, 0, 6.h),
      child: Row(
        children: [
          Icon(
            isDefault ? Icons.bookmark_rounded : Icons.folder_rounded,
            size: 20.r,
            color: scheme.primary,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              '$name (${count.toArabicDigits})',
              style: AppTextStyle.large.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (onDelete != null)
            IconButton(
              tooltip: s.group_delete,
              icon: Icon(Icons.delete_outline_rounded, color: scheme.onSurfaceVariant),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}

class _SavedPageTile extends StatelessWidget {
  final BookmarkModel bookmark;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _SavedPageTile({
    required this.bookmark,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    final d = bookmark.savedAt;
    return Material(
      color: scheme.surfaceContainer,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.fromLTRB(14.w, 12.h, 6.w, 12.h),
          child: Row(
            children: [
              Container(
                width: 52.r,
                height: 60.r,
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: scheme.primary, width: 1.4),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_rounded,
                      size: 16.r,
                      color: scheme.primary,
                    ),
                    Text(
                      bookmark.page.toArabicDigits,
                      style: AppTextStyle.large.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'سورة ${bookmark.surahName}',
                      style: AppTextStyle.quranSurahTitle.copyWith(
                        fontSize: 19.sp,
                        color: scheme.onSurface,
                        height: 1.3,
                      ),
                    ),
                    Text(
                      '${s.page} ${bookmark.page.toArabicDigits} · ${s.juz} ${bookmark.juz.toArabicDigits}',
                      style: AppTextStyle.small.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${d.day.toArabicDigits}/${d.month.toArabicDigits}/${d.year.toArabicDigits}',
                      style: AppTextStyle.xSmall.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
                icon: Icon(
                  Icons.bookmark_remove_outlined,
                  color: scheme.onSurfaceVariant,
                ),
                onPressed: onRemove,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
