import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../models/match_enums.dart';
import '../repositories/match_repo.dart';

class CreateMatchUseCase extends UseCase<String, CreateMatchParams> {
  final MatchRepo repository;

  CreateMatchUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(CreateMatchParams params) {
    return repository.createMatch(
      params.mode,
      code: params.code,
      asReferee: params.asReferee,
    );
  }
}

class CreateMatchParams extends Equatable {
  final MatchMode mode;

  /// A chosen match ID; null for a random code.
  final String? code;

  /// A referee's match starts as a draft to prepare and publish.
  final bool asReferee;

  const CreateMatchParams({
    required this.mode,
    this.code,
    this.asReferee = false,
  });

  @override
  List<Object?> get props => [mode, code, asReferee];
}
