# الماهر (Al-Maher)

Quran app — Flutter, Arabic-first (RTL), package `com.almaher.almaher`.

## Architecture (ZOX)

Clean architecture per feature, wired with `get_it`:

```
lib/
  core/        router, styles, translations (intl_utils), errors, use-case base, injections
  shared/      app-wide prefs, entities, widgets
  features/
    splash/
    quran/
      data/          local data source (bundled text) + shared prefs, repo impl
      domain/        models, repo contract, use cases (dartz Either)
      presentation/  bloc (part files), pages, widgets
      quran_injections.dart
```

Each feature registers itself in `<feature>_injections.dart`, called from `core/utils/injections.dart`.

## Quran data

- Text: `assets/quran/quran_uthmani.json` — Tanzil Uthmani text (via alquran.cloud), CC BY 3.0.
  Rows are `[surah, ayah, page, juz, hizbQuarter, sajda, text]`; page numbers follow the 604-page Madani mushaf.
  The basmala is stripped from ayah 1 of each surah (except 1 and 9) and drawn as its own line.
- Tajweed: `assets/quran/tajweed.json` — rule spans from alquran.cloud's `quran-tajweed` edition
  (same Tanzil text with inline tajweed tags), mapped onto our text by `tool/build_tajweed.py`:
  `python3 -I tool/build_tajweed.py <quran-tajweed.json> assets/quran/quran_uthmani.json assets/quran/tajweed.json`.
  59,870 spans; 8 land slightly off (a small yeh beside a waqf sign, one span in 56:26) and 7 are dropped.
- Font: Amiri Quran (`assets/fonts/`), SIL OFL.

Each ayah is rendered as its own `TextSpan` (`features/quran/presentation/widgets/ayah_spans.dart`),
keyed by `AyahModel.key` (`surah:ayah`), so ayahs — or ranges inside them — can be colored individually.

## Localization

ARB files in `lib/core/translations/l10n/` (Arabic is the main locale). Regenerate with:

```
dart run intl_utils:generate
```

## iOS simulator build note

Flutter 3.44's `flutter build ios --simulator` can fail with
`Binary ... does not contain architectures "arm64 x86_64"` (an arch-order check bug). Build arm64-only instead:

```
cd ios && xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Debug \
  -sdk iphonesimulator -derivedDataPath ../build/ios_dd ARCHS=arm64 ONLY_ACTIVE_ARCH=YES build
```

## Competition (المسابقة)

The home screen offers **قراءة القرآن** or **المسابقة**. Matches run on the NestJS server in
`../almaher-server` (Socket.IO, Postgres for results). Three seats: player 1, player 2 and the
referee (الحكم); modes: same room or remote. The app connects to `SERVER_URL`
(default: the production server `https://almaher-server-production.up.railway.app` on Railway;
local server: `--dart-define=SERVER_URL=http://localhost:3000`, Android emulator: `http://10.0.2.2:3000`).

```
cd ../almaher-server && npm install && npm run start:dev
```

`test/match_live_server_test.dart` plays a full match against a running server (skipped otherwise).
