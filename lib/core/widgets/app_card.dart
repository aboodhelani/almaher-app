import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A rounded surface on the reading side of the app: filled with the muted
/// surface colour, or outlined when [outlined].
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool outlined;
  final Color? color;
  final double? radius;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.outlined = false,
    this.color,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final r = BorderRadius.circular(radius ?? 20.r);
    return Material(
      color: color ?? (outlined ? scheme.surface : scheme.surfaceContainer),
      shape: RoundedRectangleBorder(
        borderRadius: r,
        side: outlined
            ? BorderSide(color: scheme.outline, width: 1.2)
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding ?? EdgeInsets.all(16.r), child: child),
      ),
    );
  }
}
