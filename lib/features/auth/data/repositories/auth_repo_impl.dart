import 'package:dartz/dartz.dart';

import '../../../../core/network/error/exceptions.dart';
import '../../../../core/network/error/failures.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repo.dart';
import '../data_sources/local/auth_local_data_source.dart';
import '../data_sources/remote/auth_remote_data_source.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  AuthRepoImpl(this._remote, this._local);

  @override
  Future<Either<Failure, UserModel?>> currentUser() async {
    final token = await _local.token();
    return Right(token == null ? null : _local.user());
  }

  @override
  Future<Either<Failure, UserModel>> register({
    required String email,
    required String password,
    required String name,
  }) => _session(
    () => _remote.register(email: email, password: password, name: name),
  );

  @override
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  }) => _session(() => _remote.login(email: email, password: password));

  @override
  Future<Either<Failure, void>> logout() async {
    await _local.clear();
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> deleteAccount(String password) async {
    final token = await _local.token();
    if (token == null) return const Left(ServerFailure('unauthorized'));
    try {
      await _remote.deleteAccount(token, password);
      await _local.clear();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.code));
    }
  }

  @override
  Future<Either<Failure, ProfileModel>> profile() async {
    final token = await _local.token();
    if (token == null) return const Left(ServerFailure('unauthorized'));
    try {
      return Right(ProfileModel.fromJson(await _remote.me(token)));
    } on ServerException catch (e) {
      // The account was removed or the token expired: sign out.
      if (e.code == 'unauthorized') await _local.clear();
      return Left(ServerFailure(e.code));
    }
  }

  @override
  Future<Either<Failure, List<LeaderboardRowModel>>> leaderboard() async {
    try {
      final rows = await _remote.leaderboard();
      return Right([
        for (final r in rows)
          LeaderboardRowModel.fromJson(Map<String, dynamic>.from(r as Map)),
      ]);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.code));
    }
  }

  Future<Either<Failure, UserModel>> _session(
    Future<Map<String, dynamic>> Function() call,
  ) async {
    try {
      final body = await call();
      final user = UserModel.fromJson(
        Map<String, dynamic>.from(body['user'] as Map),
      );
      await _local.save(body['token'] as String, user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.code));
    }
  }
}
