import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/app_constants.dart';

typedef JsonMap = Map<String, dynamic>;

class FlightLogService {
  bool get isConfigured =>
      AppConstants.supabaseUrl.startsWith('https://') &&
      !AppConstants.supabaseUrl.contains('YOUR_PROJECT_ID') &&
      !AppConstants.supabaseAnonKey.contains('YOUR_SUPABASE');

  SupabaseClient get _client => Supabase.instance.client;

  Future<List<JsonMap>> fetchAllLogs() async {
    final response = await _client
        .from(AppConstants.flightLogsTable)
        .select()
        .order('created_at', ascending: false);

    return List<JsonMap>.from(response);
  }

  Future<JsonMap> insertLog(JsonMap payload) async {
    final response = await _client
        .from(AppConstants.flightLogsTable)
        .insert(payload)
        .select()
        .single();

    return JsonMap.from(response);
  }

  Future<JsonMap> updateLog(String id, JsonMap payload) async {
    final response = await _client
        .from(AppConstants.flightLogsTable)
        .update(payload)
        .eq('id', id)
        .select()
        .single();

    return JsonMap.from(response);
  }

  Future<void> deleteLog(String id) async {
    await _client.from(AppConstants.flightLogsTable).delete().eq('id', id);
  }
}