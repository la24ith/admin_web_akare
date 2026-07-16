import '../../../../core/network/supabase_config.dart';
import '../models/pending_agent_model.dart';

abstract class AgentVerificationRemoteDataSource {
  Future<List<PendingAgentModel>> getPendingAgents();
  Future<void> verifyAgent(String agentId);
}

class AgentVerificationRemoteDataSourceImpl
    implements AgentVerificationRemoteDataSource {
  // يستخدم متغيّر supabase العام مباشرة (core/network/supabase_config.dart).

  @override
  Future<List<PendingAgentModel>> getPendingAgents() async {
    final rows = await supabase
        .from('agents')
        .select('id, company_name, license_number, users:user_id(full_name, created_at)')
        .eq('is_verified_agent', false);

    return (rows as List)
        .map((row) => PendingAgentModel.fromSupabase(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> verifyAgent(String agentId) async {
    await supabase
        .from('agents')
        .update({'is_verified_agent': true}).eq('id', agentId);
  }
}
