import 'package:dartz/dartz.dart';
import 'package:postgrest/postgrest.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/pending_agent.dart';
import '../../domain/repositories/agent_verification_repository.dart';
import '../datasources/agent_verification_remote_data_source.dart';

class AgentVerificationRepositoryImpl implements AgentVerificationRepository {
  final AgentVerificationRemoteDataSource remoteDataSource;
  AgentVerificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<PendingAgent>>> getPendingAgents() {
    return _guard(() => remoteDataSource.getPendingAgents());
  }

  @override
  Future<Either<Failure, void>> verifyAgent(String agentId) {
    return _guard(() => remoteDataSource.verifyAgent(agentId));
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
