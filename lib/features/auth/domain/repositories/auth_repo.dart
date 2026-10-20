import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../models/user_model.dart';

abstract class AuthRepo {
  /// The account signed in on this device, if any (no network).
  Future<Either<Failure, UserModel?>> currentUser();

  Future<Either<Failure, UserModel>> register({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> logout();

  /// Deletes the signed-in account (the password confirms it), then signs out.
  Future<Either<Failure, void>> deleteAccount(String password);

  /// The signed-in player's stats and recent matches.
  Future<Either<Failure, ProfileModel>> profile();

  Future<Either<Failure, List<LeaderboardRowModel>>> leaderboard();
}
