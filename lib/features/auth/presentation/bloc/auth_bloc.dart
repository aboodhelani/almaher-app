import 'package:bloc/bloc.dart';

import '../../../../core/utils/usecases/usecase.dart';
import '../../domain/models/user_model.dart';
import '../../domain/usecases/auth_usecases.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Whether a player is signed in. Lives for the whole app: the competition
/// needs an account, reading the Quran does not.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.getCurrentUserUseCase,
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
  }) : super(const AuthState()) {
    on<AuthStarted>((e, emit) async {
      final result = await getCurrentUserUseCase.call(NoParams());
      emit(AuthState(user: result.fold((_) => null, (u) => u), checked: true));
    });
    on<AuthLoginRequested>((e, emit) async {
      emit(state.copyWith(busy: true, error: null));
      final result = await loginUseCase.call(
        LoginParams(email: e.email, password: e.password),
      );
      result.fold(
        (f) => emit(state.copyWith(busy: false, error: f.errorMessage)),
        (user) => emit(AuthState(user: user, checked: true)),
      );
    });
    on<AuthRegisterRequested>((e, emit) async {
      emit(state.copyWith(busy: true, error: null));
      final result = await registerUseCase.call(
        RegisterParams(email: e.email, password: e.password, name: e.name),
      );
      result.fold(
        (f) => emit(state.copyWith(busy: false, error: f.errorMessage)),
        (user) => emit(AuthState(user: user, checked: true)),
      );
    });
    on<AuthLogoutRequested>((e, emit) async {
      await logoutUseCase.call(NoParams());
      emit(const AuthState(checked: true));
    });
    on<AuthSessionExpired>((e, emit) async {
      await logoutUseCase.call(NoParams());
      emit(const AuthState(checked: true));
    });
  }
}
