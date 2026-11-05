import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../domain/entities/first_aid_protocol.dart';
import '../../../domain/entities/protocol_step.dart';
import '../../../domain/entities/triage_node.dart';
import '../../models/seed_parser.dart';
import 'app_database.dart';
import 'seed_loader.dart';

/// Đọc dữ liệu y tế từ Drift. Read-only: không có API ghi ngoài SeedLoader.
class ProtocolLocalDataSource {
  const ProtocolLocalDataSource(this._db);

  final AppDatabase _db;

  Future<List<FirstAidProtocol>> getAllProtocols() async {
    final rows = await (_db.select(
      _db.protocols,
    )..orderBy([(t) => OrderingTerm.asc(t.code)])).get();
    return [for (final r in rows) await _toEntity(r)];
  }

  Future<FirstAidProtocol?> getProtocolByCode(String code) async {
    final row = await (_db.select(
      _db.protocols,
    )..where((t) => t.code.equals(code))).getSingleOrNull();
    return row == null ? null : _toEntity(row);
  }

  Future<TriageNode?> getTriageNode(String id) async {
    final row = await (_db.select(
      _db.triageNodes,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return TriageNode(
      id: row.id,
      question: row.question,
      yesNodeId: row.yesNodeId,
      noNodeId: row.noNodeId,
      protocolCode: row.protocolCode,
      callEmergencyNow: row.callEmergencyNow,
      citations: parseCitations(jsonDecode(row.citationsJson)),
      note: row.note,
    );
  }

  Future<String?> getTriageRootId() async {
    final row = await (_db.select(
      _db.meta,
    )..where((m) => m.key.equals(triageRootKey))).getSingleOrNull();
    return row?.value;
  }

  Future<String?> getDataVersion() async {
    final row = await (_db.select(
      _db.meta,
    )..where((m) => m.key.equals(dataVersionKey))).getSingleOrNull();
    return row?.value;
  }

  Future<FirstAidProtocol> _toEntity(ProtocolRow r) async {
    final stepRows =
        await (_db.select(_db.protocolSteps)
              ..where((s) => s.protocolCode.equals(r.code))
              ..orderBy([(s) => OrderingTerm.asc(s.stepOrder)]))
            .get();
    return FirstAidProtocol(
      code: r.code,
      title: r.title,
      topicId: r.topicId,
      severity: r.severity,
      targetAudience: r.targetAudience,
      ageGroup: r.ageGroup,
      steps: [
        for (final s in stepRows)
          ProtocolStep(
            order: s.stepOrder,
            text: s.stepText,
            citation: s.citation,
          ),
      ],
      doNot: parseCitedTexts(jsonDecode(r.doNotJson)),
      call115Conditions: parseCitedTexts(jsonDecode(r.call115Json)),
      citations: parseCitations(jsonDecode(r.citationsJson)),
      version: r.version,
      updatedAt: r.updatedAt,
      notes: r.notes,
      sourceVerification: parseSourceVerification(r.sourceVerification),
      clinicalReview: parseClinicalReview(r.clinicalReview),
      reusePermission: parseReusePermission(r.reusePermission),
    );
  }
}
