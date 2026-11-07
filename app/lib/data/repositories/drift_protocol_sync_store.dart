import 'package:drift/drift.dart';

import '../../domain/entities/first_aid_protocol.dart';
import '../../domain/repositories/protocol_sync_store.dart';
import '../datasources/local/app_database.dart';
import '../datasources/local/seed_loader.dart';
import '../models/seed_parser.dart';

class DriftProtocolSyncStore implements ProtocolSyncStore {
  const DriftProtocolSyncStore(this._db);

  final AppDatabase _db;

  @override
  Future<Map<String, String>> localVersions() async {
    final rows = await _db.select(_db.protocols).get();
    return {for (final r in rows) r.code: r.version};
  }

  @override
  Future<void> applyRemote(List<FirstAidProtocol> protocols) {
    // Một transaction: lỗi giữa chừng thì rollback, bản local giữ nguyên.
    return _db.transaction(() async {
      for (final p in protocols) {
        await (_db.delete(
          _db.protocolSteps,
        )..where((s) => s.protocolCode.equals(p.code))).go();
        await _db
            .into(_db.protocols)
            .insert(
              ProtocolsCompanion.insert(
                code: p.code,
                title: p.title,
                topicId: p.topicId,
                severity: p.severity,
                targetAudience: p.targetAudience,
                ageGroup: p.ageGroup,
                version: p.version,
                updatedAt: p.updatedAt,
                sourceVerification: sourceVerificationWire(
                  p.sourceVerification,
                ),
                clinicalReview: clinicalReviewWire(p.clinicalReview),
                reusePermission: reusePermissionWire(p.reusePermission),
                notes: Value(p.notes),
                doNotJson: encodeJson(citedTextsToJson(p.doNot)),
                call115Json: encodeJson(citedTextsToJson(p.call115Conditions)),
                citationsJson: encodeJson(citationsToJson(p.citations)),
              ),
              mode: InsertMode.insertOrReplace,
            );
        for (final s in p.steps) {
          await _db
              .into(_db.protocolSteps)
              .insert(
                ProtocolStepsCompanion.insert(
                  protocolCode: p.code,
                  stepOrder: s.order,
                  stepText: s.text,
                  citation: Value(s.citation),
                ),
              );
        }
        await _db
            .into(_db.meta)
            .insertOnConflictUpdate(
              MetaCompanion.insert(
                key: '$remoteVersionPrefix${p.code}',
                value: p.version,
              ),
            );
      }
    });
  }
}
