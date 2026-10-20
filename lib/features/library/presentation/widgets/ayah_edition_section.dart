import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/router/app_route_enum.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/injections.dart';
import '../../../../core/utils/quran_index.dart';
import '../../../quran/domain/models/ayah_model.dart';
import '../../domain/models/library_models.dart';
import '../../domain/usecases/library_usecases.dart';
import '../bloc/library_bloc.dart';
import 'library_dropdown.dart';

/// The ayah's tafsir or translation, with a dropdown of the ones on the
/// device (the choice is remembered).
class AyahEditionSection extends StatelessWidget {
  final AyahModel ayah;
  final EditionType type;

  const AyahEditionSection({super.key, required this.ayah, required this.type});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    final tafsir = type == EditionType.tafsir;
    return BlocBuilder<LibraryBloc, LibraryState>(
      buildWhen: (a, b) => a.editions != b.editions || a.selection != b.selection,
      builder: (context, state) {
        final editions = state.editionsOf(type);
        final selected = tafsir ? state.selection.tafsir : state.selection.translation;
        final edition = editions.firstWhere(
          (e) => e.identifier == selected,
          orElse: () => editions.first,
        );
        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    tafsir ? s.tafsir : s.translation,
                    style: AppTextStyle.large.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: LibraryDropdown(
                      value: edition.identifier,
                      items: {for (final e in editions) e.identifier: e.name},
                      onChanged: (id) => context.read<LibraryBloc>().add(
                        tafsir
                            ? LibrarySelectionChanged(tafsir: id)
                            : LibrarySelectionChanged(translation: id),
                      ),
                      onMore: () => Navigator.pushNamed(
                        context,
                        AppRouteEnum.library.name,
                        arguments: tafsir ? 0 : 1,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              _EditionText(
                key: ValueKey('${edition.identifier}/${ayah.key}'),
                edition: edition,
                ayah: ayah,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EditionText extends StatelessWidget {
  final EditionModel edition;
  final AyahModel ayah;

  const _EditionText({super.key, required this.edition, required this.ayah});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FutureBuilder(
      future: sl<GetAyahTextUseCase>().call(
        AyahTextParams(
          edition.identifier,
          globalAyahIndex(ayah.surahNumber, ayah.numberInSurah),
        ),
      ),
      builder: (context, snapshot) {
        final result = snapshot.data;
        if (result == null) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: const Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        final text = result.fold((_) => null, (t) => t);
        return Text(
          text ?? S.of(context).text_unavailable,
          textDirection: edition.rtl ? TextDirection.rtl : TextDirection.ltr,
          textAlign: TextAlign.start,
          style: AppTextStyle.medium.copyWith(
            color: text == null ? scheme.onSurfaceVariant : scheme.onSurface,
            height: 1.9,
          ),
        );
      },
    );
  }
}
