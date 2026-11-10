import 'package:app/data/models/remote_protocol_mapper.dart';
import 'package:app/data/models/seed_parser.dart';
import 'package:app/data/repositories/shared_prefs_settings_repository.dart';
import 'package:app/domain/entities/app_settings.dart';
import 'package:app/domain/entities/source_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Dòng giả lập bảng protocols_remote (dữ liệu thử, không phải nội dung y khoa).
Map<String, dynamic> _row({
  String clinicalReview = 'reviewed',
  Object? steps,
}) => {
  'code': 'test_code',
  'title': 'Tiêu đề thử',
  'topic_id': 'burns',
  'severity': 'urgent',
  'target_audience': 'x',
  'age_group': 'all',
  'version': '1.2.0',
  'updated_at': '2026-11-10',
  'notes': null,
  'steps':
      steps ??
      [
        {'order': 1, 'text': 'bước thử 1', 'citation': 'SRC p1'},
        {'order': 2, 'text': 'bước thử 2', 'citation': null},
      ],
  'do_not': [
    {'text': 'không thử', 'citation': 'SRC p2'},
  ],
  'call_115_conditions': [
    {'text': 'điều kiện thử', 'citation': null},
  ],
  'citations': [
    {'source_id': 'SRC', 'pages': '1-2'},
  ],
  'source_verification': 'verified',
  'clinical_review': clinicalReview,
  'reuse_permission': 'permission_pending',
};

void main() {
  group('protocolFromRemoteRow', () {
    test('ánh xạ đủ trường, enum và trích dẫn', () {
      final p = protocolFromRemoteRow(_row());
      expect(p.code, 'test_code');
      expect(p.version, '1.2.0');
      expect(p.steps.map((s) => s.order), [1, 2]);
      expect(p.steps.first.citation, 'SRC p1');
      expect(p.steps.last.citation, isNull);
      expect(p.doNot.single.text, 'không thử');
      expect(p.call115Conditions.single.citation, isNull);
      expect(p.citations.single.toString(), 'SRC p1-2');
      expect(p.sourceVerification, SourceVerification.verified);
      expect(p.clinicalReview, ClinicalReview.reviewed);
      expect(p.reusePermission, ReusePermission.permissionPending);
      expect(p.requiresClinicalWarning, isFalse);
    });

    test('chưa review -> bắt buộc cảnh báo; steps null -> rỗng', () {
      final p = protocolFromRemoteRow(
        _row(clinicalReview: 'not_clinically_reviewed')..['steps'] = null,
      );
      expect(p.requiresClinicalWarning, isTrue);
      expect(p.steps, isEmpty);
    });

    test('enum lạ -> SeedFormatException (không đoán)', () {
      expect(
        () => protocolFromRemoteRow(_row(clinicalReview: 'approved')),
        throwsA(isA<SeedFormatException>()),
      );
    });
  });

  group('SharedPrefsSettingsRepository', () {
    test('chưa lưu gì -> mặc định (hệ thống, 1.0, chưa đồng ý AI)', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = SharedPrefsSettingsRepository(
        await SharedPreferences.getInstance(),
      );
      final s = await repo.load();
      expect(s.themeMode, AppThemeMode.system);
      expect(s.textScale, 1.0);
      expect(s.aiPrivacyConsent, isFalse);
    });

    test('lưu rồi đọc lại đủ 3 trường', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await SharedPrefsSettingsRepository(prefs).save(
        const AppSettings(
          themeMode: AppThemeMode.dark,
          textScale: 1.3,
          aiPrivacyConsent: true,
        ),
      );
      final s = await SharedPrefsSettingsRepository(prefs).load();
      expect(s.themeMode, AppThemeMode.dark);
      expect(s.textScale, 1.3);
      expect(s.aiPrivacyConsent, isTrue);
    });

    test('giá trị hỏng/ngoài khoảng -> về mặc định / bị kẹp', () async {
      SharedPreferences.setMockInitialValues({
        'theme_mode': 'neon',
        'text_scale': 9.0,
      });
      final s = await SharedPrefsSettingsRepository(
        await SharedPreferences.getInstance(),
      ).load();
      expect(s.themeMode, AppThemeMode.system);
      expect(s.textScale, AppSettings.maxTextScale);
    });
  });
}
