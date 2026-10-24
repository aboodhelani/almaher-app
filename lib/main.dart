import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'core/helper/helper.dart';
import 'core/router/router.dart';
import 'core/styles/app_theme.dart';
import 'core/translations/l10n.dart';
import 'core/utils/app_notifier.dart';
import 'core/utils/injections.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/bookmarks/presentation/bloc/bookmarks_bloc.dart';
import 'features/library/presentation/bloc/library_bloc.dart';
import 'features/library/presentation/recitation_player.dart';
import 'features/splash/presentation/bloc/splash_bloc.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'shared/data/data_sources/app_shared_prefs.dart';
import 'shared/domain/entities/language_enum.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await initInjections();
  await FlutterLocalization.instance.ensureInitialized();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // Arabic is the app's base language.
  Locale localeState = const Locale("ar");
  final GlobalKey<ScaffoldMessengerState> snackBarKey = GlobalKey<ScaffoldMessengerState>();
  final FlutterLocalization _localization = FlutterLocalization.instance;

  @override
  void initState() {
    super.initState();
    final savedLang = Helper.getLang();
    _localization.init(
      mapLocales: [
        const MapLocale('ar', {'title': LanguageEnum.ar}),
        const MapLocale('en', {'title': LanguageEnum.en}),
      ],
      initLanguageCode: savedLang.local,
    );
    _localization.onTranslatedLanguage = _onTranslatedLanguage;
    localeState = Locale(savedLang.local);
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {
      localeState = locale ?? const Locale("ar");
    });
    sl<AppSharedPrefs>().setLang(LanguageEnumExtension.valueOf(localeState.languageCode));
  }

  @override
  Widget build(BuildContext context) {
    // Saved pages are shared by the reader and the saved-pages screen.
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<BookmarksBloc>()),
        // Signed-in player: the competition needs one, reading does not.
        BlocProvider.value(value: sl<AuthBloc>()),
        // Tafsirs, translations and recitations on the device.
        BlocProvider.value(value: sl<LibraryBloc>()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppNotifier(sl<AppSharedPrefs>())),
          ChangeNotifierProvider.value(value: sl<RecitationPlayer>()),
        ],
        child: Consumer<AppNotifier>(
          builder: (context, value, child) {
            ScreenUtil.init(context, designSize: const Size(390, 844), minTextAdapt: true, splitScreenMode: true);
            return MaterialApp(
              title: 'الماهر',
              scaffoldMessengerKey: snackBarKey,
              onGenerateRoute: AppRouter.generateRoute,
              theme: appTheme,
              darkTheme: darkAppTheme,
              themeMode: value.themeMode,
              debugShowCheckedModeBanner: false,
              locale: localeState,
              supportedLocales: _localization.supportedLocales,
              localizationsDelegates: [S.delegate, ..._localization.localizationsDelegates],
              navigatorKey: Helper.navigatorKey,
              home: BlocProvider(create: (_) => SplashBloc(), child: const SplashPage()),
            );
          },
        ),
      ),
    );
  }
}
