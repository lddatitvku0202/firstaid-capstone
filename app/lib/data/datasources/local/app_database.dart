import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('ProtocolRow')
class Protocols extends Table {
  TextColumn get code => text()();
  TextColumn get title => text()();
  TextColumn get topicId => text()();
  TextColumn get severity => text()();
  TextColumn get targetAudience => text()();
  TextColumn get ageGroup => text()();
  TextColumn get version => text()();
  TextColumn get updatedAt => text()();
  TextColumn get sourceVerification => text()();
  TextColumn get clinicalReview => text()();
  TextColumn get reusePermission => text()();
  TextColumn get notes => text().nullable()();

  /// JSON-encoded List<{text,citation}> / List<{source_id,pages}>.
  TextColumn get doNotJson => text()();
  TextColumn get call115Json => text()();
  TextColumn get citationsJson => text()();

  @override
  Set<Column<Object>> get primaryKey => {code};
}

@DataClassName('ProtocolStepRow')
class ProtocolSteps extends Table {
  TextColumn get protocolCode => text().references(Protocols, #code)();
  IntColumn get stepOrder => integer()();
  TextColumn get stepText => text()();
  TextColumn get citation => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {protocolCode, stepOrder};
}

@DataClassName('TriageNodeRow')
class TriageNodes extends Table {
  TextColumn get id => text()();
  TextColumn get question => text()();
  TextColumn get yesNodeId => text().nullable()();
  TextColumn get noNodeId => text().nullable()();
  TextColumn get protocolCode => text().nullable()();
  BoolColumn get callEmergencyNow =>
      boolean().withDefault(const Constant(false))();
  TextColumn get citationsJson => text()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('MetaRow')
class Meta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DataClassName('SyncJobRow')
class SyncJobs extends Table {
  TextColumn get id => text()();
  TextColumn get kind => text()();
  TextColumn get payloadJson => text()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();

  /// pending | failed | done
  TextColumn get status => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get nextAttemptAt => dateTime()();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [Protocols, ProtocolSteps, TriageNodes, Meta, SyncJobs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openOnDevice());

  /// Dùng cho test: SQLite trong bộ nhớ.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(syncJobs);
      }
    },
  );
}

LazyDatabase _openOnDevice() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/firstaid.sqlite');
    return NativeDatabase.createInBackground(file);
  });
}
