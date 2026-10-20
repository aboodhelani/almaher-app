part of 'splash_bloc.dart';

abstract class SplashEvent {
  const SplashEvent();
}

class SplashStarted extends SplashEvent {
  const SplashStarted();
}
