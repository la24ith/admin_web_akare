import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/pending_agent.dart';
import '../repositories/agent_verification_repository.dart';

class GetPendingAgents implements UseCase<List<PendingAgent>, NoParams> {
  final AgentVerificationRepository repository;
  GetPendingAgents(this.repository);

  @override
  Future<Either<Failure, List<PendingAgent>>> call(NoParams params) {
    return repository.getPendingAgents();
  }
}
