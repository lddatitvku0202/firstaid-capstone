// Tóm tắt coverage/lcov.info (sinh bởi `flutter test --coverage`).
// Chạy: dart run tool/coverage_summary.dart [coverage/lcov.info]
// In số dòng hit/tổng THẬT cho từng file và tổng; phần trăm chỉ để đọc nhanh
// (2 chữ số thập phân, tính từ đúng hai số nguyên in cạnh nó).
// ignore_for_file: avoid_print
import 'dart:io';

void main(List<String> args) {
  final path = args.isEmpty ? 'coverage/lcov.info' : args.first;
  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('Không thấy $path. Chạy flutter test --coverage trước.');
    exitCode = 1;
    return;
  }
  final files = <String, (int found, int hit)>{};
  String? current;
  var found = 0;
  var hit = 0;
  for (final raw in file.readAsLinesSync()) {
    final line = raw.trim();
    if (line.startsWith('SF:')) {
      current = line.substring(3).replaceAll(r'\', '/');
      found = 0;
      hit = 0;
    } else if (line.startsWith('LF:')) {
      found = int.parse(line.substring(3));
    } else if (line.startsWith('LH:')) {
      hit = int.parse(line.substring(3));
    } else if (line == 'end_of_record' && current != null) {
      files[current] = (found, hit);
      current = null;
    }
  }

  String pct(int h, int f) =>
      f == 0 ? 'n/a' : '${(h * 100 / f).toStringAsFixed(2)}%';

  final layers = <String, (int, int)>{};
  var totalFound = 0;
  var totalHit = 0;
  final rows = files.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  print('| File | Dòng hit / tổng | % |');
  print('|---|---|---|');
  for (final e in rows) {
    final (f, h) = e.value;
    totalFound += f;
    totalHit += h;
    final m = RegExp(r'lib/(core|domain|data|presentation)/').firstMatch(e.key);
    final layer = m?.group(1) ?? 'khác';
    final (lf, lh) = layers[layer] ?? (0, 0);
    layers[layer] = (lf + f, lh + h);
    print('| ${e.key} | $h / $f | ${pct(h, f)} |');
  }
  print('');
  print('| Lớp | Dòng hit / tổng | % |');
  print('|---|---|---|');
  for (final e
      in layers.entries.toList()..sort((a, b) => a.key.compareTo(b.key))) {
    final (f, h) = e.value;
    print('| ${e.key} | $h / $f | ${pct(h, f)} |');
  }
  print('');
  print(
    'TỔNG: $totalHit / $totalFound dòng (${pct(totalHit, totalFound)}), '
    '${files.length} file trong lcov.info',
  );
  // File sinh tự động (drift_dev) không do nhóm viết: báo thêm tổng không tính.
  final hand = files.entries.where((e) => !e.key.endsWith('.g.dart'));
  final hf = hand.fold(0, (a, e) => a + e.value.$1);
  final hh = hand.fold(0, (a, e) => a + e.value.$2);
  print(
    'TỔNG KHÔNG TÍNH *.g.dart: $hh / $hf dòng (${pct(hh, hf)}), '
    '${hand.length} file',
  );
}
