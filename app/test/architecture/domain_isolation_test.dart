import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _importPattern = RegExp(
  r"""^\s*(?:import|export)\s+['"]([^'"]*)['"]""",
  multiLine: true,
);

const _bannedFragments = [
  'presentation/',
  'data/',
  'package:flutter/',
  'package:flutter_',
  'package:drift',
  'package:supabase',
  'package:http',
  'riverpod',
];

/// Trả về danh sách vi phạm "file: uri" trong nội dung một file Dart.
List<String> findViolations(String path, String source) {
  final out = <String>[];
  for (final m in _importPattern.allMatches(source)) {
    final uri = m.group(1)!;
    if (_bannedFragments.any(uri.contains)) out.add('$path: $uri');
  }
  return out;
}

void main() {
  test('detector flags forbidden imports', () {
    expect(
      findViolations('x.dart', "import 'package:flutter/material.dart';"),
      isNotEmpty,
    );
    expect(
      findViolations('x.dart', "import '../../data/foo.dart';"),
      isNotEmpty,
    );
    expect(
      findViolations('x.dart', "import 'package:flutter_riverpod/a.dart';"),
      isNotEmpty,
    );
    expect(
      findViolations('x.dart', "import 'package:drift/drift.dart';"),
      isNotEmpty,
    );
    expect(
      findViolations('x.dart', "import 'first_aid_protocol.dart';"),
      isEmpty,
    );
  });

  test('lib/domain has no forbidden imports', () {
    final dir = Directory('lib/domain');
    expect(dir.existsSync(), isTrue);
    final files = dir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .toList();
    expect(files, isNotEmpty);
    final violations = <String>[
      for (final f in files) ...findViolations(f.path, f.readAsStringSync()),
    ];
    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}
