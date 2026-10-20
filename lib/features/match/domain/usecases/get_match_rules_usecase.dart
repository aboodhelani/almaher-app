import 'package:dartz/dartz.dart';

import '../../../../core/network/error/exceptions.dart';
import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../../data/data_sources/remote/match_rules_remote_data_source.dart';
import '../models/match_rules_model.dart';

/// The competition rules as the dashboard set them.
class GetMatchRulesUseCase extends UseCase<MatchRulesModel, NoParams> {
  final MatchRulesRemoteDataSource remote;

  GetMatchRulesUseCase(this.remote);

  @override
  Future<Either<Failure, MatchRulesModel>> call(NoParams params) async {
    try {
      return Right(MatchRulesModel.fromJson(await remote.rules()));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.code));
    }
  }
}
