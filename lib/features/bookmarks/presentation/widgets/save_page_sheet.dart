import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/arabic_numbers.dart';
import '../../domain/models/bookmark_model.dart';
import '../bloc/bookmarks_bloc.dart';

/// Asks which group a page goes in: the default group, one of the user's
/// groups, or a new one. Saves it and tells the user where.
class SavePageSheet extends StatelessWidget {
  final BookmarkModel bookmark;

  const SavePageSheet({super.key, required this.bookmark});

  static Future<void> show(BuildContext context, BookmarkModel bookmark) =>
      showModalBottomSheet(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (_) => BlocProvider.value(
          value: context.read<BookmarksBloc>(),
          child: SavePageSheet(bookmark: bookmark),
        ),
      );

  void _save(BuildContext context, {String? groupId, String? newName, required String label}) {
    HapticFeedback.selectionClick();
    context.read<BookmarksBloc>().add(
      BookmarkSaved(bookmark, groupId: groupId, newGroupName: newName),
    );
    final messenger = ScaffoldMessenger.of(context);
    final text = S.of(context).page_saved_in(bookmark.page.toArabicDigits, label);
    Navigator.pop(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(duration: const Duration(seconds: 2), content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    final groups = context.watch<BookmarksBloc>().state.groups;
    Widget tile({
      required IconData icon,
      required String title,
      String? subtitle,
      required VoidCallback onTap,
      Color? color,
    }) => ListTile(
      leading: Icon(icon, color: color ?? scheme.primary),
      title: Text(
        title,
        style: AppTextStyle.medium.copyWith(
          color: color ?? scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(subtitle, style: AppTextStyle.xSmall.copyWith(color: scheme.onSurfaceVariant)),
      onTap: onTap,
    );
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.7),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
                child: Text(
                  s.group_save_title(bookmark.page.toArabicDigits),
                  style: AppTextStyle.large.copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              tile(
                icon: Icons.bookmark_rounded,
                title: s.group_default,
                subtitle: s.group_default_note,
                onTap: () => _save(context, label: s.group_default),
              ),
              for (final g in groups)
                tile(
                  icon: Icons.folder_rounded,
                  title: g.name,
                  onTap: () => _save(context, groupId: g.id, label: g.name),
                ),
              const Divider(),
              tile(
                icon: Icons.create_new_folder_outlined,
                title: s.group_new,
                onTap: () async {
                  final name = await askGroupName(context, action: s.group_create_save);
                  if (name != null && context.mounted) {
                    _save(context, newName: name, label: name);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Asks for a new group's name; null if cancelled or empty.
Future<String?> askGroupName(BuildContext context, {required String action}) async {
  final name = await showDialog<String>(
    context: context,
    builder: (_) => _GroupNameDialog(action: action),
  );
  final trimmed = name?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

/// Owns its text field's controller, so it lives until the dialog is gone.
class _GroupNameDialog extends StatefulWidget {
  final String action;

  const _GroupNameDialog({required this.action});

  @override
  State<_GroupNameDialog> createState() => _GroupNameDialogState();
}

class _GroupNameDialogState extends State<_GroupNameDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return AlertDialog(
      title: Text(s.group_new),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 40,
        decoration: InputDecoration(labelText: s.group_name, hintText: s.group_name_hint),
        onSubmitted: (v) => Navigator.pop(context, v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(s.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: Text(widget.action),
        ),
      ],
    );
  }
}
