import '../../domain/entities/first_aid_protocol.dart';
import '../../domain/entities/protocol_step.dart';
import 'seed_parser.dart';

/// Chuyển một dòng `protocols_remote` (jsonb) sang entity domain.
/// Giá trị enum lạ => SeedFormatException (không đoán).
FirstAidProtocol protocolFromRemoteRow(Map<String, dynamic> r) =>
    FirstAidProtocol(
      code: r['code'] as String,
      title: r['title'] as String,
      topicId: r['topic_id'] as String,
      severity: r['severity'] as String,
      targetAudience: r['target_audience'] as String,
      ageGroup: r['age_group'] as String,
      version: r['version'] as String,
      updatedAt: r['updated_at'] as String,
      notes: r['notes'] as String?,
      steps: [
        for (final s in (r['steps'] as List<dynamic>? ?? const <dynamic>[]))
          ProtocolStep(
            order: (s as Map<String, dynamic>)['order'] as int,
            text: s['text'] as String,
            citation: s['citation'] as String?,
          ),
      ],
      doNot: parseCitedTexts(r['do_not']),
      call115Conditions: parseCitedTexts(r['call_115_conditions']),
      citations: parseCitations(r['citations']),
      sourceVerification: parseSourceVerification(
        r['source_verification'] as String,
      ),
      clinicalReview: parseClinicalReview(r['clinical_review'] as String),
      reusePermission: parseReusePermission(r['reuse_permission'] as String),
    );
