import 'package:drift/drift.dart';

import '../../models/seed_parser.dart';
import 'app_database.dart';

typedef AssetTextLoader = Future<String> Function(String path);

const protocolsAssetPath = 'assets/protocols/protocols_v1.json';
const triageAssetPath = 'assets/triage/triage_v1.json';
const dataVersionKey = 'data_version';
const triageRootKey = 'triage_root';

/// Seed dữ liệu từ asset JSON vào Drift ở lần chạy đầu hoặc khi data_version đổi.
class SeedLoader {
  const SeedLoader(this._db, this._loadAsset);

  final AppDatabase _db;
  final AssetTextLoader _loadAsset;

  /// Trả về true nếu đã seed lại.
  Future<bool> seedIfNeeded() async {
    final protocolSeed = parseProtocolSeed(
      await _loadAsset(protocolsAssetPath),
    );
    final triageSeed = parseTriageSeed(await _loadAsset(triageAssetPath));
    final version = '${protocolSeed.dataVersion}+${triageSeed.dataVersion}';

    final current = await (_db.select(
      _db.meta,
    )..where((m) => m.key.equals(dataVersionKey))).getSingleOrNull();
    if (current?.value == version) return false;

    await _db.transaction(() async {
      await _db.delete(_db.protocolSteps).go();
      await _db.delete(_db.protocols).go();
      await _db.delete(_db.triageNodes).go();

      for (final p in protocolSeed.protocols) {
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
      }
      for (final n in triageSeed.nodes) {
        await _db
            .into(_db.triageNodes)
            .insert(
              TriageNodesCompanion.insert(
                id: n.id,
                question: n.question,
                yesNodeId: Value(n.yesNodeId),
                noNodeId: Value(n.noNodeId),
                protocolCode: Value(n.protocolCode),
                callEmergencyNow: Value(n.callEmergencyNow),
                citationsJson: encodeJson(citationsToJson(n.citations)),
                note: Value(n.note),
              ),
            );
      }
      await _db
          .into(_db.meta)
          .insertOnConflictUpdate(
            MetaCompanion.insert(key: dataVersionKey, value: version),
          );
      await _db
          .into(_db.meta)
          .insertOnConflictUpdate(
            MetaCompanion.insert(key: triageRootKey, value: triageSeed.rootId),
          );
    });
    return true;
  }
}
