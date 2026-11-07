import '../entities/first_aid_protocol.dart';
import '../entities/source_status.dart';
import '../repositories/protocol_sync_store.dart';
import '../services/remote_sync_source.dart';
import '../utils/version_compare.dart';

enum SyncProtocolsStatus { updated, upToDate, failed }

class SyncProtocolsResult {
  const SyncProtocolsResult(
    this.status, {
    this.applied = 0,
    this.skippedUnreviewed = 0,
    this.error,
  });

  final SyncProtocolsStatus status;
  final int applied;
  final int skippedUnreviewed;
  final String? error;
}

/// Chính sách xung đột: server version thắng, nhưng CHỈ nhận bản
/// `clinical_review = reviewed` và `source_verification = verified`.
/// Chỉ nhận bản có version MỚI HƠN bản trên máy. Lỗi => giữ nguyên bản local.
class SyncProtocols {
  const SyncProtocols(this._remote, this._store);

  final RemoteSyncSource _remote;
  final ProtocolSyncStore _store;

  Future<SyncProtocolsResult> call() async {
    try {
      final remote = await _remote.fetchProtocols();
      final local = await _store.localVersions();
      var skipped = 0;
      final accepted = <FirstAidProtocol>[];
      for (final p in remote) {
        if (p.clinicalReview != ClinicalReview.reviewed ||
            p.sourceVerification != SourceVerification.verified) {
          skipped++;
          continue;
        }
        final have = local[p.code];
        if (have == null || compareVersions(p.version, have) > 0) {
          accepted.add(p);
        }
      }
      if (accepted.isEmpty) {
        return SyncProtocolsResult(
          SyncProtocolsStatus.upToDate,
          skippedUnreviewed: skipped,
        );
      }
      await _store.applyRemote(accepted);
      return SyncProtocolsResult(
        SyncProtocolsStatus.updated,
        applied: accepted.length,
        skippedUnreviewed: skipped,
      );
    } on Object catch (e) {
      return SyncProtocolsResult(
        SyncProtocolsStatus.failed,
        error: e.toString(),
      );
    }
  }
}
