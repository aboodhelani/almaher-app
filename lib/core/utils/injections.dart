import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/auth_injections.dart';
import '../../features/bookmarks/bookmarks_injections.dart';
import '../../features/library/library_injections.dart';
import '../../features/quran/quran_injections.dart';
import '../../features/match/match_injections.dart';
import '../../features/mutashabihat/mutashabihat_injections.dart';
import '../../features/search/search_injections.dart';
import '../../features/tajweed/tajweed_injections.dart';
import '../../shared/app_injections.dart';
import 'log/app_logger.dart';

final sl = GetIt.instance;

Future<void> initInjections() async {
  initRootLogger();
  await initSharedPrefsInjections();
  initAppInjections();
  initQuranInjections();
  initSearchInjections();
  initTajweedInjections();
  initMutashabihatInjections();
  initAuthInjections();
  initMatchInjections();
  initBookmarksInjections();
  initLibraryInjections();
}

Future<void> initSharedPrefsInjections() async {
  sl.registerSingletonAsync<SharedPreferences>(() async {
    return await SharedPreferences.getInstance();
  });
  await sl.isReady<SharedPreferences>();
}
