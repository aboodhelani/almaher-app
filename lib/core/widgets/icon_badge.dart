import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// An icon on a soft accent square, leading a settings row or a card.
class IconBadge extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final Color? background;

  const IconBadge(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final side = size ?? 40.r;
    return Container(
      width: side,
      height: side,
      decoration: BoxDecoration(
        color: background ?? scheme.primaryContainer,
        borderRadius: BorderRadius.circular(side * 0.32),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: side * 0.52, color: color ?? scheme.primary),
    );
  }
}
