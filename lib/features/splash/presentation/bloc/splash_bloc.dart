import 'package:bloc/bloc.dart';

import '../../../../core/router/app_route_enum.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashStarted>(_onSplashStarted);
  }

  Future<void> _onSplashStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));
    emit(SplashNavigationReady(routeName: AppRouteEnum.home.name));
  }
}
