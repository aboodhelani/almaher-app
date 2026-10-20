import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/styles/game_colors.dart';
import '../../../../core/utils/game_sounds.dart';
import '../../../../core/utils/injections.dart';
import 'game_kit.dart';

/// Counts down from [seconds] as of [since], as a ring that empties over
/// [total] seconds and turns red for the last five. The server enforces the
/// real deadline; this only shows it.
class CountdownText extends StatefulWidget {
  final int seconds;
  final int total;
  final DateTime since;
  final Color color;
  final double? size;

  const CountdownText({
    super.key,
    required this.seconds,
    required this.total,
    required this.since,
    required this.color,
    this.size,
  });

  @override
  State<CountdownText> createState() => _CountdownTextState();
}

class _CountdownTextState extends State<CountdownText> {
  late final Timer _timer;
  int? _lastTicked;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) setState(() {});
    });
  }

  /// A tick for each of the last five seconds.
  void _maybeTick(int left) {
    if (left > 5 || left < 1 || left == _lastTicked) return;
    _lastTicked = left;
    sl<GameSounds>().play(GameSound.tick);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elapsedMs = DateTime.now().difference(widget.since).inMilliseconds;
    final leftMs = (widget.seconds * 1000 - elapsedMs).clamp(
      0,
      widget.seconds * 1000,
    );
    final left = (leftMs / 1000).ceil();
    _maybeTick(left);
    final urgent = left <= 5;
    final color = urgent ? GameColors.wrong : widget.color;
    final size = widget.size ?? 54.r;
    return AnimatedScale(
      scale: urgent && left > 0 && leftMs % 1000 > 500 ? 1.08 : 1,
      duration: const Duration(milliseconds: 150),
      child: ProgressRing(
        fraction: widget.total == 0 ? 0 : leftMs / (widget.total * 1000),
        color: color,
        size: size,
        stroke: size * 0.09,
        child: Text(
          '$left',
          style: AppTextStyle.large.copyWith(
            fontSize: size * 0.34,
            color: urgent ? GameColors.wrong : GameColors.text,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
      ),
    );
  }
}
