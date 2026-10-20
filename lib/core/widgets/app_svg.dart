import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../helper/helper.dart';

/// One of the app's single-colour SVGs (assets/svg), tinted to [color] —
/// the theme's text colour by default, so it follows light and dark mode.
class AppSvg extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;

  const AppSvg(this.name, {super.key, required this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      Helper.getSvgPath(name),
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        color ?? Theme.of(context).colorScheme.onSurface,
        BlendMode.srcIn,
      ),
    );
  }
}
