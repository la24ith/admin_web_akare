part of 'agent_verification_cubit.dart';

abstract class AgentVerificationState extends Equatable {
  const AgentVerificationState();

  @override
  List<Object?> get props => [];
}

class AgentVerificationInitial extends AgentVerificationState {
  const AgentVerificationInitial();
}

class AgentVerificationLoading extends AgentVerificationState {
  const AgentVerificationLoading();
}

class AgentVerificationLoaded extends AgentVerificationState {
  final List<PendingAgent> agents;
  final String? verifyingAgentId;

  const AgentVerificationLoaded(this.agents, {this.verifyingAgentId});

  AgentVerificationLoaded copyWith({String? verifyingAgentId}) {
    return AgentVerificationLoaded(agents, verifyingAgentId: verifyingAgentId);
  }

  @override
  List<Object?> get props => [agents, verifyingAgentId];
}

class AgentVerificationError extends AgentVerificationState {
  final String message;
  const AgentVerificationError(this.message);

  @override
  List<Object?> get props => [message];
}
