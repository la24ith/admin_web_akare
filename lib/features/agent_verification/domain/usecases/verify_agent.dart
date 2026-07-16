import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/agent_verification_repository.dart';

class VerifyAgent implements UseCase<void, VerifyAgentParams> {
  final AgentVerificationRepository repository;
  VerifyAgent(this.repository);

  @override
  Future<Either<Failure, void>> call(VerifyAgentParams params) {
    return repository.verifyAgent(params.agentId);
  }
}

class VerifyAgentParams extends Equatable {
  final String agentId;
  const VerifyAgentParams(this.agentId);

  @override
  List<Object?> get props => [agentId];
}
