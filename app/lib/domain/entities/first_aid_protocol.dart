import 'protocol_step.dart';
import 'source_status.dart';

class FirstAidProtocol {
  const FirstAidProtocol({
    required this.code,
    required this.title,
    required this.steps,
    this.sourceVerification = SourceVerification.unverified,
    this.clinicalReview = ClinicalReview.notClinicallyReviewed,
    this.reusePermission = ReusePermission.unknown,
  });

  final String code;
  final String title;
  final List<ProtocolStep> steps;
  final SourceVerification sourceVerification;
  final ClinicalReview clinicalReview;
  final ReusePermission reusePermission;

  /// App phải hiện cảnh báo khi chưa được rà soát chuyên môn.
  bool get requiresClinicalWarning => clinicalReview != ClinicalReview.reviewed;
}
