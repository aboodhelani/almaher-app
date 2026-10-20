import 'package:flutter/material.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';

/// A compact dropdown of what is on the device, ending with "More…" which
/// opens the downloads.
class LibraryDropdown extends StatelessWidget {
  static const _more = '__more__';

  /// identifier → display name.
  final Map<String, String> items;
  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback onMore;

  const LibraryDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final style = AppTextStyle.small.copyWith(
      color: scheme.onSurface,
      fontWeight: FontWeight.w600,
    );
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        isDense: true,
        borderRadius: BorderRadius.circular(14),
        value: items.containsKey(value) ? value : null,
        items: [
          for (final e in items.entries)
            DropdownMenuItem(
              value: e.key,
              child: Text(e.value, style: style, overflow: TextOverflow.ellipsis),
            ),
          DropdownMenuItem(
            value: _more,
            child: Row(
              children: [
                Icon(Icons.download_rounded, size: 18, color: scheme.primary),
                const SizedBox(width: 6),
                Text(
                  S.of(context).more_downloads,
                  style: style.copyWith(color: scheme.primary),
                ),
              ],
            ),
          ),
        ],
        onChanged: (v) {
          if (v == null) return;
          v == _more ? onMore() : onChanged(v);
        },
      ),
    );
  }
}
