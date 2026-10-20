import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/translations/l10n.dart';
import '../bloc/library_bloc.dart';

/// Tells the user when a download fails.
class LibraryFailureListener extends StatelessWidget {
  final Widget child;

  const LibraryFailureListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LibraryBloc, LibraryState>(
      listenWhen: (a, b) => b.failure != null && a.failure != b.failure,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(S.of(context).library_download_failed)),
        ),
      child: child,
    );
  }
}
