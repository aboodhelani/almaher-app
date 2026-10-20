enum AppRouteEnum {
  splash,
  home,
  quranReader,
  settings,
  search,
  tajweedGuide,
  match,
  savedPages,
  auth,
  profile,
  library,
  reciterSurahs,
  about,
}

extension AppRouteExtension on AppRouteEnum {
  String get name {
    switch (this) {
      case AppRouteEnum.splash:
        return "/splash";
      case AppRouteEnum.home:
        return "/home";
      case AppRouteEnum.match:
        return "/match";
      case AppRouteEnum.quranReader:
        return "/quran-reader";
      case AppRouteEnum.settings:
        return "/settings";
      case AppRouteEnum.search:
        return "/search";
      case AppRouteEnum.tajweedGuide:
        return "/tajweed-guide";
      case AppRouteEnum.savedPages:
        return "/saved-pages";
      case AppRouteEnum.auth:
        return "/auth";
      case AppRouteEnum.profile:
        return "/profile";
      case AppRouteEnum.library:
        return "/library";
      case AppRouteEnum.reciterSurahs:
        return "/reciter-surahs";
      case AppRouteEnum.about:
        return "/about";
    }
  }
}
