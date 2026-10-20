import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../models/match_enums.dart';
import '../repositories/match_repo.dart';

class JoinMatchUseCase extends UseCase<void, JoinMatchParams> {
  final MatchRepo repository;

  JoinMatchUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(JoinMatchParams params) {
    return repository.joinMatch(
      code: params.code,
      role: params.role,
      name: params.name,
    );
  }
}

class JoinMatchParams extends Equatable {
  final String code;
  final JoinRole role;
  final String name;

  const JoinMatchParams({
    required this.code,
    required this.role,
    required this.name,
  });

  @override
  List<Object?> get props => [code, role, name];
}

/// Enter without an ID: the server matches the user; returns the match code.
class QuickMatchUseCase extends UseCase<String, QuickMatchParams> {
  final MatchRepo repository;

  QuickMatchUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(QuickMatchParams params) {
    return repository.quickMatch(
      role: params.role,
      name: params.name,
      mode: params.mode,
    );
  }
}

class QuickMatchParams extends Equatable {
  final JoinRole role;
  final String name;
  final MatchMode mode;

  const QuickMatchParams({
    required this.role,
    required this.name,
    required this.mode,
  });

  @override
  List<Object?> get props => [role, name, mode];
}
