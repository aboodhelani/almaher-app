import 'package:bloc/bloc.dart';

import '../../../../core/utils/usecases/usecase.dart';
import '../../domain/models/user_model.dart';
import '../../domain/usecases/auth_usecases.dart';

/// The profile screen: the player's stats and recent matches, and the
/// leaderboard. Loaded together, refreshed by pulling down.
class ProfileBloc extends Bloc<ProfileRequested, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final GetLeaderboardUseCase getLeaderboardUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.getLeaderboardUseCase,
  }) : super(const ProfileState()) {
    on<ProfileRequested>((e, emit) async {
      emit(
        ProfileState(loading: true, profile: state.profile, board: state.board),
      );
      final results = await Future.wait([
        getProfileUseCase.call(NoParams()),
        getLeaderboardUseCase.call(NoParams()),
      ]);
      final profile = results[0].fold((_) => null, (p) => p as ProfileModel);
      final board = results[1].fold(
        (_) => null,
        (b) => b as List<LeaderboardRowModel>,
      );
      final error = results[0].fold((f) => f.errorMessage, (_) => null);
      emit(
        ProfileState(profile: profile, board: board ?? const [], error: error),
      );
    });
  }
}

class ProfileRequested {
  const ProfileRequested();
}

class ProfileState {
  final bool loading;
  final ProfileModel? profile;
  final List<LeaderboardRowModel> board;
  final String? error;

  const ProfileState({
    this.loading = false,
    this.profile,
    this.board = const [],
    this.error,
  });
}
