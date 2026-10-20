import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../helper/helper.dart';

/// The brand logo in its own colours: gold calligraphy on a navy disc, or
/// with [markOnly] the gold calligraphy alone (for navy backgrounds).
class AppLogo extends StatelessWidget {
  final double size;
  final bool markOnly;

  const AppLogo({super.key, required this.size, this.markOnly = false});

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    Helper.getSvgPath(markOnly ? 'logo_mark.svg' : 'logo.svg'),
    width: size,
    height: size,
  );
}
