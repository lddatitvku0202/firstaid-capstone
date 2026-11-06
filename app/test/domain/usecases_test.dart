import 'package:app/domain/entities/app_settings.dart';
import 'package:app/domain/entities/first_aid_protocol.dart';
import 'package:app/domain/entities/protocol_step.dart';
import 'package:app/domain/entities/triage_node.dart';
import 'package:app/domain/repositories/emergency_repository.dart';
import 'package:app/domain/repositories/protocol_repository.dart';
import 'package:app/domain/usecases/advance_triage.dart';
import 'package:app/domain/usecases/search_protocols.dart';
import 'package:flutter_test/flutter_test.dart';

class _Protocols implements ProtocolRepository {
  @override
  Future<List<FirstAidProtocol>> getOfflineProtocols() async => const [
    FirstAidProtocol(
      code: 'burns',
      title: 'Bỏng',
      topicId: 'burns',
      severity: 'urgent',
      targetAudience: 'x',
      ageGroup: 'all',
      version: '1',
      updatedAt: '2026-11-06',
      steps: [ProtocolStep(order: 1, text: 'Làm mát bằng nước')],
    ),
    FirstAidProtocol(
      code: 'cpr',
      title: 'Ngừng tuần hoàn',
      topicId: 'cardiac_arrest_cpr',
      severity: 'life_threatening',
      targetAudience: 'x',
      ageGroup: 'adult',
      version: '1',
      updatedAt: '2026-11-06',
      steps: [ProtocolStep(order: 1, text: 'Ép ngực')],
    ),
  ];

  @override
  Future<FirstAidProtocol?> getProtocolByCode(String code) async => null;
}

class _Emergency implements EmergencyRepository {
  static const a = TriageNode(id: 'a', question: 'q', yesNodeId: 'b');
  static const b = TriageNode(
    id: 'b',
    question: 'leaf',
    callEmergencyNow: true,
  );

  @override
  Future<TriageNode> getTriageRoot() async => a;

  @override
  Future<TriageNode?> getTriageNode(String id) async => {'a': a, 'b': b}[id];
}

void main() {
  test('normalizeForSearch bỏ dấu tiếng Việt (bảng ánh xạ cùng độ dài)', () {
    expect(normalizeForSearch('Đường thở'), 'duong tho');
    expect(normalizeForSearch('Hóc dị vật'), 'hoc di vat');
    expect(normalizeForSearch('Ép NGỰC'), 'ep nguc');
    expect(normalizeForSearch('Ngừng tuần hoàn'), 'ngung tuan hoan');
  });

  test('SearchProtocols lọc theo tiêu đề/bước, rỗng trả tất cả', () async {
    final uc = SearchProtocols(_Protocols());
    expect(await uc.call(''), hasLength(2));
    expect((await uc.call('bong')).single.code, 'burns');
    expect((await uc.call('ep nguc')).single.code, 'cpr');
    expect(await uc.call('khong co'), isEmpty);
  });

  test('AdvanceTriage đi theo yes/no, null ở nhánh không có', () async {
    final uc = AdvanceTriage(_Emergency());
    expect((await uc.call(_Emergency.a, answerYes: true))?.id, 'b');
    expect(await uc.call(_Emergency.a, answerYes: false), isNull);
    expect(await uc.call(_Emergency.b, answerYes: true), isNull);
  });

  test('AppSettings.copyWith kẹp cỡ chữ trong khoảng cho phép', () {
    const s = AppSettings();
    expect(s.copyWith(textScale: 9).textScale, AppSettings.maxTextScale);
    expect(s.copyWith(textScale: 0.1).textScale, AppSettings.minTextScale);
  });
}
