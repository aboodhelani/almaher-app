import '../core/utils/injections.dart';
import 'data/data_sources/app_shared_prefs.dart';

void initAppInjections() {
  sl.registerFactory<AppSharedPrefs>(() => AppSharedPrefs(sl()));
}
