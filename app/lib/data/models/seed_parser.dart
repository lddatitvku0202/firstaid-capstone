import 'dart:convert';

import '../../domain/entities/cited_text.dart';
import '../../domain/entities/first_aid_protocol.dart';
import '../../domain/entities/protocol_step.dart';
import '../../domain/entities/source_citation.dart';
import '../../domain/entities/source_status.dart';
import '../../domain/entities/triage_node.dart';

class SeedFormatException implements Exception {
  SeedFormatException(this.message);
  final String message;
  @override
  String toString() => 'SeedFormatException: $message';
}

/// Chuyển giá trị enum "wire" (theo CLAUDE.md §6) sang enum domain.
/// Giá trị lạ -> ném lỗi (không đoán).
SourceVerification parseSourceVerification(String v) => switch (v) {
  'verified' => SourceVerification.verified,
  'unverified' => SourceVerification.unverified,
  _ => throw SeedFormatException('source_verification không hợp lệ: $v'),
};

ClinicalReview parseClinicalReview(String v) => switch (v) {
  'reviewed' => ClinicalReview.reviewed,
  'not_clinically_reviewed' => ClinicalReview.notClinicallyReviewed,
  _ => throw SeedFormatException('clinical_review không hợp lệ: $v'),
};

ReusePermission parseReusePermission(String v) => switch (v) {
  'permitted' => ReusePermission.permitted,
  'permission_pending' => ReusePermission.permissionPending,
  'unknown' => ReusePermission.unknown,
  _ => throw SeedFormatException('reuse_permission không hợp lệ: $v'),
};

String sourceVerificationWire(SourceVerification v) => switch (v) {
  SourceVerification.verified => 'verified',
  SourceVerification.unverified => 'unverified',
};

String clinicalReviewWire(ClinicalReview v) => switch (v) {
  ClinicalReview.reviewed => 'reviewed',
  ClinicalReview.notClinicallyReviewed => 'not_clinically_reviewed',
};

String reusePermissionWire(ReusePermission v) => switch (v) {
  ReusePermission.permitted => 'permitted',
  ReusePermission.permissionPending => 'permission_pending',
  ReusePermission.unknown => 'unknown',
};

List<SourceCitation> parseCitations(Object? raw) => [
  for (final c in (raw as List<dynamic>? ?? const <dynamic>[]))
    SourceCitation(
      sourceId: (c as Map<String, dynamic>)['source_id'] as String,
      pages: c['pages'] as String,
    ),
];

List<Map<String, String>> citationsToJson(List<SourceCitation> list) => [
  for (final c in list) {'source_id': c.sourceId, 'pages': c.pages},
];

List<CitedText> parseCitedTexts(Object? raw) => [
  for (final c in (raw as List<dynamic>? ?? const <dynamic>[]))
    CitedText(
      text: (c as Map<String, dynamic>)['text'] as String,
      citation: c['citation'] as String?,
    ),
];

List<Map<String, String?>> citedTextsToJson(List<CitedText> list) => [
  for (final c in list) {'text': c.text, 'citation': c.citation},
];

String encodeJson(Object o) => jsonEncode(o);

class ProtocolSeed {
  const ProtocolSeed({required this.dataVersion, required this.protocols});
  final String dataVersion;
  final List<FirstAidProtocol> protocols;
}

class TriageSeed {
  const TriageSeed({
    required this.dataVersion,
    required this.rootId,
    required this.nodes,
  });
  final String dataVersion;
  final String rootId;
  final List<TriageNode> nodes;
}

ProtocolSeed parseProtocolSeed(String jsonText) {
  try {
    final root = jsonDecode(jsonText) as Map<String, dynamic>;
    final list = root['protocols'] as List<dynamic>;
    return ProtocolSeed(
      dataVersion: root['data_version'] as String,
      protocols: [for (final p in list) _protocol(p as Map<String, dynamic>)],
    );
  } on SeedFormatException {
    rethrow;
  } on Object catch (e) {
    throw SeedFormatException('protocols seed lỗi: $e');
  }
}

FirstAidProtocol _protocol(Map<String, dynamic> p) => FirstAidProtocol(
  code: p['code'] as String,
  title: p['title'] as String,
  topicId: p['topic_id'] as String,
  severity: p['severity'] as String,
  targetAudience: p['target_audience'] as String,
  ageGroup: p['age_group'] as String,
  steps: [
    for (final s in p['steps'] as List<dynamic>)
      ProtocolStep(
        order: (s as Map<String, dynamic>)['order'] as int,
        text: s['text'] as String,
        citation: s['citation'] as String?,
      ),
  ],
  doNot: parseCitedTexts(p['do_not']),
  call115Conditions: parseCitedTexts(p['call_115_conditions']),
  citations: parseCitations(p['citations']),
  version: p['version'] as String,
  updatedAt: p['updated_at'] as String,
  notes: p['notes'] as String?,
  sourceVerification: parseSourceVerification(
    p['source_verification'] as String,
  ),
  clinicalReview: parseClinicalReview(p['clinical_review'] as String),
  reusePermission: parseReusePermission(p['reuse_permission'] as String),
);

TriageSeed parseTriageSeed(String jsonText) {
  try {
    final root = jsonDecode(jsonText) as Map<String, dynamic>;
    return TriageSeed(
      dataVersion: root['data_version'] as String,
      rootId: root['root'] as String,
      nodes: [
        for (final n in root['nodes'] as List<dynamic>)
          TriageNode(
            id: (n as Map<String, dynamic>)['id'] as String,
            question: n['question'] as String,
            yesNodeId: n['yes'] as String?,
            noNodeId: n['no'] as String?,
            protocolCode: n['protocol_code'] as String?,
            callEmergencyNow: n['call_115_now'] as bool? ?? false,
            citations: parseCitations(n['citations']),
            note: n['note'] as String?,
          ),
      ],
    );
  } on Object catch (e) {
    throw SeedFormatException('triage seed lỗi: $e');
  }
}
