import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/pending_agent.dart';
import '../../domain/usecases/get_pending_agents.dart';
import '../../domain/usecases/verify_agent.dart';

part 'agent_verification_state.dart';

class AgentVerificationCubit extends Cubit<AgentVerificationState> {
  final GetPendingAgents getPendingAgents;
  final VerifyAgent verifyAgent;

  AgentVerificationCubit({
    required this.getPendingAgents,
    required this.verifyAgent,
  }) : super(const AgentVerificationInitial());

  Future<void> load() async {
    emit(const AgentVerificationLoading());

    final result = await getPendingAgents(const NoParams());

    result.fold(
      (failure) => emit(AgentVerificationError(failure.message)),
      (agents) => emit(AgentVerificationLoaded(agents)),
    );
  }

  Future<void> verify(String agentId) async {
    final current = state;
    if (current is! AgentVerificationLoaded) return;

    emit(current.copyWith(verifyingAgentId: agentId));

    final result = await verifyAgent(VerifyAgentParams(agentId));

    result.fold(
      (failure) => emit(AgentVerificationError(failure.message)),
      (_) => load(),
    );
  }
}
