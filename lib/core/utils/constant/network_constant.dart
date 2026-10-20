/// Match server: the production server on Railway by default. Override per
/// build to use a local server, e.g.
/// `flutter run --dart-define=SERVER_URL=http://localhost:3000`.
/// The iOS simulator reaches the Mac's localhost; an Android emulator needs
/// `http://10.0.2.2:3000`, and a real phone needs the Mac's network address.
const String serverUrl = String.fromEnvironment(
  'SERVER_URL',
  defaultValue: 'https://almaher-server-production.up.railway.app',
);
