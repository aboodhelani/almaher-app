import 'package:flutter/material.dart';
import '../../../../core/styles/brand_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/star_pattern.dart';
import '../bloc/splash_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashBloc>().add(const SplashStarted());
    });
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final fade = CurvedAnimation(parent: _intro, curve: Curves.easeOutCubic);
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigationReady) {
          Navigator.pushReplacementNamed(
            context,
            state.routeName,
            arguments: state.arguments,
          );
        }
      },
      // Always the brand's navy, matching the native launch screen.
      child: Scaffold(
        backgroundColor: Brand.navy900,
        body: Stack(
          children: [
            Positioned.fill(
              child: StarPattern(
                color: Brand.gold500.withValues(alpha: 0.07),
                spacing: 56,
              ),
            ),
            Center(
              child: FadeTransition(
                opacity: fade,
                child: ScaleTransition(
                  scale: Tween(begin: 0.92, end: 1.0).animate(fade),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppLogo(size: 220.r),
                      SizedBox(height: 20.h),
                      Text(
                        s.splash_tagline,
                        style: AppTextStyle.medium.copyWith(
                          color: Brand.gold200,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 64.h,
              child: Center(
                child: SizedBox(
                  width: 96.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      minHeight: 3,
                      color: Brand.gold500,
                      backgroundColor: Brand.navy700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
