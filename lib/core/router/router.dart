import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/profile_bloc.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/bookmarks/presentation/pages/saved_pages_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/library/presentation/pages/library_page.dart';
import '../../features/library/presentation/pages/reciter_surahs_page.dart';
import '../../features/match/presentation/bloc/match_bloc.dart';
import '../../features/match/presentation/pages/match_page.dart';
import '../../features/quran/domain/models/quran_location.dart';
import '../../features/quran/presentation/bloc/quran_bloc.dart';
import '../../features/quran/presentation/pages/quran_reader_page.dart';
import '../../features/search/presentation/bloc/search_bloc.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/settings/presentation/pages/about_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/tajweed/presentation/bloc/tajweed_guide_bloc.dart';
import '../../features/tajweed/presentation/pages/tajweed_guide_page.dart';
import '../utils/injections.dart';

class AppRouter {
  static String currentRoute = "/";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    currentRoute = settings.name ?? "/";
    switch (settings.name) {
      case '/quran-reader':
        return CupertinoPageRoute(
          settings: RouteSettings(
            name: settings.name,
            arguments: settings.arguments,
          ),
          // An int argument opens that page instead of the last one read.
          builder: (_) => BlocProvider(
            create: (_) =>
                sl<QuranBloc>()
                  ..add(QuranStarted(page: settings.arguments as int?)),
            child: const QuranReaderPage(),
          ),
        );

      case '/saved-pages':
        // Argument true: picking a page for the open reader (pops with it).
        return CupertinoPageRoute<int>(
          settings: RouteSettings(
            name: settings.name,
            arguments: settings.arguments,
          ),
          builder: (_) =>
              SavedPagesPage(pickForReader: settings.arguments == true),
        );

      case '/auth':
        // Argument false: sign in and come back (pops with true).
        return CupertinoPageRoute<bool>(
          settings: RouteSettings(
            name: settings.name,
            arguments: settings.arguments,
          ),
          builder: (_) =>
              AuthPage(continueToMatch: settings.arguments != false),
        );

      case '/profile':
        return CupertinoPageRoute(
          settings: RouteSettings(
            name: settings.name,
            arguments: settings.arguments,
          ),
          builder: (_) => BlocProvider(
            create: (_) => sl<ProfileBloc>()..add(const ProfileRequested()),
            child: const ProfilePage(),
          ),
        );

      case '/library':
        // Argument: the tab to open (0 tafsirs, 1 translations, 2 reciters).
        return CupertinoPageRoute(
          settings: RouteSettings(
            name: settings.name,
            arguments: settings.arguments,
          ),
          builder: (_) =>
              LibraryPage(initialTab: settings.arguments as int? ?? 0),
        );

      case '/reciter-surahs':
        // Argument: the reciter's identifier.
        return CupertinoPageRoute(
          settings: RouteSettings(
            name: settings.name,
            arguments: settings.arguments,
          ),
          builder: (_) =>
              ReciterSurahsPage(reciter: settings.arguments as String),
        );

      case '/about':
        return CupertinoPageRoute(
          settings: RouteSettings(
            name: settings.name,
            arguments: settings.arguments,
          ),
          builder: (_) => const AboutPage(),
        );

      case '/settings':
        return CupertinoPageRoute(
          settings: RouteSettings(
            name: settings.name,
            arguments: settings.arguments,
          ),
          builder: (_) => const SettingsPage(),
        );

      case '/search':
        return CupertinoPageRoute<QuranLocation>(
          settings: RouteSettings(
            name: settings.name,
            arguments: settings.arguments,
          ),
          builder: (_) => BlocProvider(
            create: (_) => sl<SearchBloc>()..add(const SearchStarted()),
            child: const SearchPage(),
          ),
        );

      case '/tajweed-guide':
        return CupertinoPageRoute(
          settings: RouteSettings(
            name: settings.name,
            arguments: settings.arguments,
          ),
          builder: (_) => BlocProvider(
            create: (_) =>
                sl<TajweedGuideBloc>()..add(const TajweedGuideStarted()),
            child: const TajweedGuidePage(),
          ),
        );

      case '/home':
        return CupertinoPageRoute(
          settings: RouteSettings(
            name: settings.name,
            arguments: settings.arguments,
          ),
          builder: (_) => const HomePage(),
        );

      case '/match':
        return CupertinoPageRoute(
          settings: RouteSettings(
            name: settings.name,
            arguments: settings.arguments,
          ),
          // Guests can read the Quran but must sign in to play.
          builder: (_) => sl<AuthBloc>().state.signedIn
              ? BlocProvider(
                  create: (_) =>
                      sl<MatchBloc>()..add(const MatchResumeRequested()),
                  child: const MatchPage(),
                )
              : const AuthPage(),
        );

      default:
        return CupertinoPageRoute(
          settings: RouteSettings(
            name: settings.name,
            arguments: settings.arguments,
          ),
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
