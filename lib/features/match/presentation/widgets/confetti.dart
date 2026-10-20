import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/styles/game_colors.dart';

/// Coloured paper falling once over [child], for the winner.
class Confetti extends StatefulWidget {
  final Widget child;

  const Confetti({super.key, required this.child});

  @override
  State<Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  )..forward();

  static const _colors = [
    GameColors.whatDoYouKnow,
    GameColors.ayahNumber,
    GameColors.auction,
    GameColors.similar,
    GameColors.buzzer,
    GameColors.gold,
    Colors.white,
  ];

  late final List<_Piece> _pieces = () {
    final rnd = math.Random(7);
    return List.generate(
      70,
      (i) => _Piece(
        x: rnd.nextDouble(),
        delay: rnd.nextDouble() * 0.35,
        speed: 0.7 + rnd.nextDouble() * 0.6,
        drift: (rnd.nextDouble() - 0.5) * 0.25,
        spin: (rnd.nextDouble() - 0.5) * 14,
        size: 6 + rnd.nextDouble() * 6,
        color: _colors[i % _colors.length],
      ),
    );
  }();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => CustomPaint(
                painter: _ConfettiPainter(_pieces, _controller.value),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Piece {
  final double x, delay, speed, drift, spin, size;
  final Color color;

  const _Piece({
    required this.x,
    required this.delay,
    required this.speed,
    required this.drift,
    required this.spin,
    required this.size,
    required this.color,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_Piece> pieces;
  final double t;

  _ConfettiPainter(this.pieces, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in pieces) {
      final local = ((t - p.delay) / (1 - p.delay)).clamp(0.0, 1.0);
      if (local <= 0 || local >= 1) continue;
      final y = -20 + local * p.speed * (size.height + 60);
      final x =
          (p.x + p.drift * local) * size.width +
          math.sin(local * 10 + p.x * 6) * 12;
      final paint = Paint()
        ..color = p.color.withValues(alpha: (1 - local).clamp(0.0, 1.0));
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(local * p.spin);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.5,
          ),
          const Radius.circular(1.5),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
