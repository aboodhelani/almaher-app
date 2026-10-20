part of 'splash_bloc.dart';

abstract class SplashState {
  const SplashState();
}

class SplashInitial extends SplashState {}

class SplashNavigationReady extends SplashState {
  final String routeName;
  final Object? arguments;

  const SplashNavigationReady({required this.routeName, this.arguments});
}
