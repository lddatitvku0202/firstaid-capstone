import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../domain/entities/first_aid_protocol.dart';
import '../../../domain/entities/sync_job.dart';
import '../../../domain/services/remote_sync_source.dart';
import '../../models/remote_protocol_mapper.dart';
import '../../models/seed_parser.dart';

/// Supabase: đọc `protocols_remote`, ghi `sos_logs` + `sync_events`.
/// Chưa kiểm chứng với project thật (xem docs/evidence/rls/).
class SupabaseRemoteSyncSource implements RemoteSyncSource {
  SupabaseRemoteSyncSource(this._client);

  final SupabaseClient _client;

  @override
  Future<List<FirstAidProtocol>> fetchProtocols() async {
    try {
      final rows = await _client
          .from('protocols_remote')
          .select()
          .timeout(const Duration(seconds: 15));
      return [for (final r in rows) protocolFromRemoteRow(r)];
    } on PostgrestException catch (e) {
      throw _map(e);
    } on SeedFormatException catch (e) {
      throw RemotePermanentException(e.message);
    } on Object catch (e) {
      throw RemoteTransientException(e.toString());
    }
  }

  @override
  Future<void> submitJob(SyncJob job) async {
    if (_client.auth.currentSession == null) {
      // Chưa đăng nhập: RLS sẽ từ chối. Giữ job, thử lại sau khi có phiên.
      throw RemoteTransientException('Chưa đăng nhập (auth tùy chọn)');
    }
    try {
      final payload = jsonDecode(job.payloadJson) as Map<String, dynamic>;
      await _insertIgnoringDuplicate('sos_logs', payload);
      await _insertIgnoringDuplicate('sync_events', {
        'id': job.id,
        'device_id': payload['device_id'],
        'kind': job.kind,
      });
    } on PostgrestException catch (e) {
      throw _map(e);
    } on Object catch (e) {
      throw RemoteTransientException(e.toString());
    }
  }

  /// Trùng khóa chính (23505) nghĩa là đã gửi trước đó => coi là thành công.
  Future<void> _insertIgnoringDuplicate(
    String table,
    Map<String, dynamic> row,
  ) async {
    try {
      await _client.from(table).insert(row);
    } on PostgrestException catch (e) {
      if (e.code != '23505') rethrow;
    }
  }

  Exception _map(PostgrestException e) {
    final code = e.code ?? '';
    // 42501 = từ chối quyền/RLS; 22xxx/23xxx = dữ liệu sai: thử lại vô ích.
    if (code == '42501' || code.startsWith('22') || code.startsWith('23')) {
      return RemotePermanentException('${e.code}: ${e.message}');
    }
    return RemoteTransientException('${e.code}: ${e.message}');
  }
}
