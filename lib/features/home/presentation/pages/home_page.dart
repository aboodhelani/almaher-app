import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/router/app_route_enum.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/arabic_numbers.dart';
import '../../../../core/utils/injections.dart';
import '../../../../core/widgets/app_logo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../match/data/data_sources/local/match_session_prefs.dart';
import '../../../quran/data/data_sources/local/quran_shared_prefs.dart';
import '../widgets/home_option_card.dart';

/// First screen after the splash: read the Quran, or play the competition.
/// If the app was closed during a match, it goes straight back to it.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _lastPage = sl<QuranSharedPrefs>().getLastReadPage();

  @override
  void initState() {
    super.initState();
    if (sl<MatchSessionPrefs>().get() != null &&
        sl<AuthBloc>().state.signedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pushNamed(context, AppRouteEnum.match.name);
      });
    }
  }

  Future<void> _open(AppRouteEnum route) async {
    await Navigator.pushNamed(context, route.name);
    if (mounted) {
      setState(() => _lastPage = sl<QuranSharedPrefs>().getLastReadPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
          children: [
            Row(
              children: [
                AppLogo(size: 52.r),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.home_greeting,
                        style: AppTextStyle.small.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        s.app_name,
                        style: AppTextStyle.quranSurahTitle.copyWith(
                          fontSize: 28.sp,
                          color: scheme.onSurface,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                if (context.watch<AuthBloc>().state.signedIn) ...[
                  _RoundIconButton(
                    icon: Icons.person_outline_rounded,
                    tooltip: s.profile_title,
                    onTap: () => _open(AppRouteEnum.profile),
                  ),
                  SizedBox(width: 8.w),
                ],
                _RoundIconButton(
                  icon: Icons.tune_rounded,
                  tooltip: s.settings,
                  onTap: () => _open(AppRouteEnum.settings),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            QuranHeroCard(
              title: s.home_read,
              subtitle: s.home_read_subtitle,
              action: _lastPage > 1
                  ? s.home_continue(_lastPage.toArabicDigits)
                  : s.home_start_reading,
              onTap: () => _open(AppRouteEnum.quranReader),
            ),
            SizedBox(height: 16.h),
            GameHeroCard(
              title: s.home_play,
              subtitle: s.home_play_subtitle,
              caption: s.home_rounds,
              action: s.home_play_now,
              onTap: () => _open(AppRouteEnum.match),
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 4.w, bottom: 10.h),
              child: Text(
                s.home_more,
                style: AppTextStyle.small.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // One under the other, full width.
            HomeShortcut(
              icon: Icons.palette_outlined,
              label: s.home_tajweed_guide,
              onTap: () => _open(AppRouteEnum.tajweedGuide),
            ),
            SizedBox(height: 12.h),
            HomeShortcut(
              icon: Icons.collections_bookmark_outlined,
              label: s.saved_pages,
              onTap: () => _open(AppRouteEnum.savedPages),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _RoundIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: scheme.surfaceContainer,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 44.r,
            height: 44.r,
            child: Icon(icon, color: scheme.onSurface, size: 22.r),
          ),
        ),
      ),
    );
  }
}
