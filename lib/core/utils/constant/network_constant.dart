/// Match server. Override per build:
/// `flutter run --dart-define=SERVER_URL=http://192.168.1.20:3000`.
/// The iOS simulator reaches the Mac's localhost; an Android emulator needs
/// `http://10.0.2.2:3000`, and a real phone needs the Mac's network address.
const String serverUrl = String.fromEnvironment(
  'SERVER_URL',
  defaultValue: 'http://localhost:3000',
);
