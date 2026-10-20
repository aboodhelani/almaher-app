import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/data/data_sources/app_shared_prefs.dart';
import '../../shared/domain/entities/language_enum.dart';
import '../utils/constant/app_constants.dart';
import '../utils/injections.dart';

class Helper {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Get language
  static LanguageEnum getLang() {
    return sl<AppSharedPrefs>().getLang() ?? LanguageEnum.ar;
  }

  /// Get svg picture path
  static String getSvgPath(String name) {
    return "$svgPath$name";
  }

  /// Get vertical space
  static double getVerticalSpace() {
    return 10.h;
  }

  /// Get horizontal space
  static double getHorizontalSpace() {
    return 10.w;
  }
}
