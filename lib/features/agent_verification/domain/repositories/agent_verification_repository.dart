import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/pending_agent.dart';

abstract class AgentVerificationRepository {
  /// كل الوكلاء بحالة is_verified_agent = false
  Future<Either<Failure, List<PendingAgent>>> getPendingAgents();

  /// توثيق الوكيل — is_verified_agent = true
  Future<Either<Failure, void>> verifyAgent(String agentId);
}
