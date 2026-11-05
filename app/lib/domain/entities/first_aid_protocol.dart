import 'cited_text.dart';
import 'protocol_step.dart';
import 'source_citation.dart';
import 'source_status.dart';

class FirstAidProtocol {
  const FirstAidProtocol({
    required this.code,
    required this.title,
    required this.topicId,
    required this.severity,
    required this.targetAudience,
    required this.ageGroup,
    required this.steps,
    required this.version,
    required this.updatedAt,
    this.doNot = const [],
    this.call115Conditions = const [],
    this.citations = const [],
    this.notes,
    this.sourceVerification = SourceVerification.unverified,
    this.clinicalReview = ClinicalReview.notClinicallyReviewed,
    this.reusePermission = ReusePermission.unknown,
  });

  final String code;
  final String title;
  final String topicId;
  final String severity;
  final String targetAudience;
  final String ageGroup;
  final List<ProtocolStep> steps;
  final List<CitedText> doNot;
  final List<CitedText> call115Conditions;
  final List<SourceCitation> citations;
  final String version;
  final String updatedAt;
  final String? notes;
  final SourceVerification sourceVerification;
  final ClinicalReview clinicalReview;
  final ReusePermission reusePermission;

  /// App phải hiện cảnh báo khi chưa được rà soát chuyên môn.
  bool get requiresClinicalWarning => clinicalReview != ClinicalReview.reviewed;
}
