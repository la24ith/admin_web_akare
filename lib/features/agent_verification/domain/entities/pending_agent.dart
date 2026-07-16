import 'package:equatable/equatable.dart';

class PendingAgent extends Equatable {
  final String agentId;
  final String agentName;
  final String? companyName;
  final String? licenseNumber;
  final DateTime registeredAt;

  const PendingAgent({
    required this.agentId,
    required this.agentName,
    required this.companyName,
    required this.licenseNumber,
    required this.registeredAt,
  });

  @override
  List<Object?> get props =>
      [agentId, agentName, companyName, licenseNumber, registeredAt];
}
