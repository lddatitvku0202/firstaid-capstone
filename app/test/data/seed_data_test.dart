import 'dart:io';

import 'package:app/data/models/seed_parser.dart';
import 'package:app/domain/entities/source_status.dart';
import 'package:flutter_test/flutter_test.dart';

const _register = '../docs/source/medical/source_register.csv';

Set<String> _verifiedSourceIds() {
  final lines = File(_register).readAsLinesSync();
  final ids = <String>{};
  // Cột: source_id (đầu), ..., source_verification (cột thứ 12). Đọc đơn giản
  // theo source_id và chỉ nhận các dòng có chứa ',verified,'.
  for (final line in lines.skip(1)) {
    if (line.trim().isEmpty) continue;
    final id = line.split(',').first;
    if (line.contains(',verified,')) ids.add(id);
  }
  return ids;
}

void main() {
  final protocols = parseProtocolSeed(
    File('assets/protocols/protocols_v1.json').readAsStringSync(),
  );
  final triage = parseTriageSeed(
    File('assets/triage/triage_v1.json').readAsStringSync(),
  );

  test('seed parse: 4 chủ đề MVP đều có phác đồ', () {
    final topics = protocols.protocols.map((p) => p.topicId).toSet();
    expect(
      topics,
      containsAll([
        'bleeding_wounds',
        'burns',
        'choking',
        'cardiac_arrest_cpr',
      ]),
    );
    final codes = protocols.protocols.map((p) => p.code).toList();
    expect(codes.toSet().length, codes.length, reason: 'code phải duy nhất');
  });

  test('mọi phác đồ có >=1 citation với source_id verified trong register', () {
    final ids = _verifiedSourceIds();
    expect(ids, contains('IFRC-2025'));
    for (final p in protocols.protocols) {
      expect(p.citations, isNotEmpty, reason: p.code);
      for (final c in p.citations) {
        expect(ids, contains(c.sourceId), reason: '${p.code}: ${c.sourceId}');
        expect(c.pages.trim(), isNotEmpty, reason: p.code);
      }
    }
  });

  test('mọi bước có citation và có >=1 bước', () {
    for (final p in protocols.protocols) {
      expect(p.steps, isNotEmpty, reason: p.code);
      for (final s in p.steps) {
        expect(s.citation, isNotNull, reason: '${p.code} bước ${s.order}');
      }
    }
  });

  test('trạng thái nguồn hợp lệ và chưa ai rà soát lâm sàng', () {
    for (final p in protocols.protocols) {
      expect(p.clinicalReview, ClinicalReview.notClinicallyReviewed);
      expect(p.requiresClinicalWarning, isTrue);
      expect(p.sourceVerification, isIn(SourceVerification.values));
      expect(p.reusePermission, isIn(ReusePermission.values));
    }
  });

  test('giá trị enum lạ bị từ chối', () {
    expect(
      () => parseClinicalReview('ok'),
      throwsA(isA<SeedFormatException>()),
    );
    expect(
      () => parseSourceVerification('maybe'),
      throwsA(isA<SeedFormatException>()),
    );
    expect(
      () => parseReusePermission('yes'),
      throwsA(isA<SeedFormatException>()),
    );
  });

  test('triage: liên kết nút hợp lệ và mã phác đồ tồn tại', () {
    final ids = triage.nodes.map((n) => n.id).toSet();
    final codes = protocols.protocols.map((p) => p.code).toSet();
    expect(ids, contains(triage.rootId));
    for (final n in triage.nodes) {
      expect(n.citations, isNotEmpty, reason: n.id);
      if (n.yesNodeId != null) expect(ids, contains(n.yesNodeId));
      if (n.noNodeId != null) expect(ids, contains(n.noNodeId));
      if (n.protocolCode != null) expect(codes, contains(n.protocolCode));
      if (n.isLeaf) {
        expect(
          n.protocolCode != null || n.callEmergencyNow,
          isTrue,
          reason: 'nút lá ${n.id} phải dẫn tới phác đồ hoặc gọi 115',
        );
      } else {
        expect(n.yesNodeId, isNotNull, reason: n.id);
        expect(n.noNodeId, isNotNull, reason: n.id);
      }
    }
  });
}
