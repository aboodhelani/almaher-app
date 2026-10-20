import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../models/user_model.dart';
import '../repositories/auth_repo.dart';

class GetCurrentUserUseCase extends UseCase<UserModel?, NoParams> {
  final AuthRepo repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserModel?>> call(NoParams params) =>
      repository.currentUser();
}

class RegisterParams {
  final String email;
  final String password;
  final String name;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
  });
}

class RegisterUseCase extends UseCase<UserModel, RegisterParams> {
  final AuthRepo repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, UserModel>> call(RegisterParams params) =>
      repository.register(
        email: params.email,
        password: params.password,
        name: params.name,
      );
}

class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
}

class LoginUseCase extends UseCase<UserModel, LoginParams> {
  final AuthRepo repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserModel>> call(LoginParams params) =>
      repository.login(email: params.email, password: params.password);
}

class LogoutUseCase extends UseCase<void, NoParams> {
  final AuthRepo repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) => repository.logout();
}

class GetProfileUseCase extends UseCase<ProfileModel, NoParams> {
  final AuthRepo repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Either<Failure, ProfileModel>> call(NoParams params) =>
      repository.profile();
}

class GetLeaderboardUseCase
    extends UseCase<List<LeaderboardRowModel>, NoParams> {
  final AuthRepo repository;

  GetLeaderboardUseCase(this.repository);

  @override
  Future<Either<Failure, List<LeaderboardRowModel>>> call(NoParams params) =>
      repository.leaderboard();
}

/// Params: the account's password, to confirm.
class DeleteAccountUseCase extends UseCase<void, String> {
  final AuthRepo repository;

  DeleteAccountUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) =>
      repository.deleteAccount(params);
}
