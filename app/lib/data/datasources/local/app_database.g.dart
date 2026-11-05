// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProtocolsTable extends Protocols
    with TableInfo<$ProtocolsTable, ProtocolRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProtocolsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicIdMeta = const VerificationMeta(
    'topicId',
  );
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
    'topic_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetAudienceMeta = const VerificationMeta(
    'targetAudience',
  );
  @override
  late final GeneratedColumn<String> targetAudience = GeneratedColumn<String>(
    'target_audience',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageGroupMeta = const VerificationMeta(
    'ageGroup',
  );
  @override
  late final GeneratedColumn<String> ageGroup = GeneratedColumn<String>(
    'age_group',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceVerificationMeta =
      const VerificationMeta('sourceVerification');
  @override
  late final GeneratedColumn<String> sourceVerification =
      GeneratedColumn<String>(
        'source_verification',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _clinicalReviewMeta = const VerificationMeta(
    'clinicalReview',
  );
  @override
  late final GeneratedColumn<String> clinicalReview = GeneratedColumn<String>(
    'clinical_review',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reusePermissionMeta = const VerificationMeta(
    'reusePermission',
  );
  @override
  late final GeneratedColumn<String> reusePermission = GeneratedColumn<String>(
    'reuse_permission',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doNotJsonMeta = const VerificationMeta(
    'doNotJson',
  );
  @override
  late final GeneratedColumn<String> doNotJson = GeneratedColumn<String>(
    'do_not_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _call115JsonMeta = const VerificationMeta(
    'call115Json',
  );
  @override
  late final GeneratedColumn<String> call115Json = GeneratedColumn<String>(
    'call115_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _citationsJsonMeta = const VerificationMeta(
    'citationsJson',
  );
  @override
  late final GeneratedColumn<String> citationsJson = GeneratedColumn<String>(
    'citations_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    code,
    title,
    topicId,
    severity,
    targetAudience,
    ageGroup,
    version,
    updatedAt,
    sourceVerification,
    clinicalReview,
    reusePermission,
    notes,
    doNotJson,
    call115Json,
    citationsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'protocols';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProtocolRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(
        _topicIdMeta,
        topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta),
      );
    } else if (isInserting) {
      context.missing(_topicIdMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('target_audience')) {
      context.handle(
        _targetAudienceMeta,
        targetAudience.isAcceptableOrUnknown(
          data['target_audience']!,
          _targetAudienceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetAudienceMeta);
    }
    if (data.containsKey('age_group')) {
      context.handle(
        _ageGroupMeta,
        ageGroup.isAcceptableOrUnknown(data['age_group']!, _ageGroupMeta),
      );
    } else if (isInserting) {
      context.missing(_ageGroupMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('source_verification')) {
      context.handle(
        _sourceVerificationMeta,
        sourceVerification.isAcceptableOrUnknown(
          data['source_verification']!,
          _sourceVerificationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceVerificationMeta);
    }
    if (data.containsKey('clinical_review')) {
      context.handle(
        _clinicalReviewMeta,
        clinicalReview.isAcceptableOrUnknown(
          data['clinical_review']!,
          _clinicalReviewMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clinicalReviewMeta);
    }
    if (data.containsKey('reuse_permission')) {
      context.handle(
        _reusePermissionMeta,
        reusePermission.isAcceptableOrUnknown(
          data['reuse_permission']!,
          _reusePermissionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reusePermissionMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('do_not_json')) {
      context.handle(
        _doNotJsonMeta,
        doNotJson.isAcceptableOrUnknown(data['do_not_json']!, _doNotJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_doNotJsonMeta);
    }
    if (data.containsKey('call115_json')) {
      context.handle(
        _call115JsonMeta,
        call115Json.isAcceptableOrUnknown(
          data['call115_json']!,
          _call115JsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_call115JsonMeta);
    }
    if (data.containsKey('citations_json')) {
      context.handle(
        _citationsJsonMeta,
        citationsJson.isAcceptableOrUnknown(
          data['citations_json']!,
          _citationsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_citationsJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  ProtocolRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProtocolRow(
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      topicId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic_id'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}severity'],
      )!,
      targetAudience: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_audience'],
      )!,
      ageGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}age_group'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      sourceVerification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_verification'],
      )!,
      clinicalReview: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clinical_review'],
      )!,
      reusePermission: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reuse_permission'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      doNotJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}do_not_json'],
      )!,
      call115Json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}call115_json'],
      )!,
      citationsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}citations_json'],
      )!,
    );
  }

  @override
  $ProtocolsTable createAlias(String alias) {
    return $ProtocolsTable(attachedDatabase, alias);
  }
}

class ProtocolRow extends DataClass implements Insertable<ProtocolRow> {
  final String code;
  final String title;
  final String topicId;
  final String severity;
  final String targetAudience;
  final String ageGroup;
  final String version;
  final String updatedAt;
  final String sourceVerification;
  final String clinicalReview;
  final String reusePermission;
  final String? notes;

  /// JSON-encoded List<{text,citation}> / List<{source_id,pages}>.
  final String doNotJson;
  final String call115Json;
  final String citationsJson;
  const ProtocolRow({
    required this.code,
    required this.title,
    required this.topicId,
    required this.severity,
    required this.targetAudience,
    required this.ageGroup,
    required this.version,
    required this.updatedAt,
    required this.sourceVerification,
    required this.clinicalReview,
    required this.reusePermission,
    this.notes,
    required this.doNotJson,
    required this.call115Json,
    required this.citationsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['title'] = Variable<String>(title);
    map['topic_id'] = Variable<String>(topicId);
    map['severity'] = Variable<String>(severity);
    map['target_audience'] = Variable<String>(targetAudience);
    map['age_group'] = Variable<String>(ageGroup);
    map['version'] = Variable<String>(version);
    map['updated_at'] = Variable<String>(updatedAt);
    map['source_verification'] = Variable<String>(sourceVerification);
    map['clinical_review'] = Variable<String>(clinicalReview);
    map['reuse_permission'] = Variable<String>(reusePermission);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['do_not_json'] = Variable<String>(doNotJson);
    map['call115_json'] = Variable<String>(call115Json);
    map['citations_json'] = Variable<String>(citationsJson);
    return map;
  }

  ProtocolsCompanion toCompanion(bool nullToAbsent) {
    return ProtocolsCompanion(
      code: Value(code),
      title: Value(title),
      topicId: Value(topicId),
      severity: Value(severity),
      targetAudience: Value(targetAudience),
      ageGroup: Value(ageGroup),
      version: Value(version),
      updatedAt: Value(updatedAt),
      sourceVerification: Value(sourceVerification),
      clinicalReview: Value(clinicalReview),
      reusePermission: Value(reusePermission),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      doNotJson: Value(doNotJson),
      call115Json: Value(call115Json),
      citationsJson: Value(citationsJson),
    );
  }

  factory ProtocolRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProtocolRow(
      code: serializer.fromJson<String>(json['code']),
      title: serializer.fromJson<String>(json['title']),
      topicId: serializer.fromJson<String>(json['topicId']),
      severity: serializer.fromJson<String>(json['severity']),
      targetAudience: serializer.fromJson<String>(json['targetAudience']),
      ageGroup: serializer.fromJson<String>(json['ageGroup']),
      version: serializer.fromJson<String>(json['version']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      sourceVerification: serializer.fromJson<String>(
        json['sourceVerification'],
      ),
      clinicalReview: serializer.fromJson<String>(json['clinicalReview']),
      reusePermission: serializer.fromJson<String>(json['reusePermission']),
      notes: serializer.fromJson<String?>(json['notes']),
      doNotJson: serializer.fromJson<String>(json['doNotJson']),
      call115Json: serializer.fromJson<String>(json['call115Json']),
      citationsJson: serializer.fromJson<String>(json['citationsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'title': serializer.toJson<String>(title),
      'topicId': serializer.toJson<String>(topicId),
      'severity': serializer.toJson<String>(severity),
      'targetAudience': serializer.toJson<String>(targetAudience),
      'ageGroup': serializer.toJson<String>(ageGroup),
      'version': serializer.toJson<String>(version),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'sourceVerification': serializer.toJson<String>(sourceVerification),
      'clinicalReview': serializer.toJson<String>(clinicalReview),
      'reusePermission': serializer.toJson<String>(reusePermission),
      'notes': serializer.toJson<String?>(notes),
      'doNotJson': serializer.toJson<String>(doNotJson),
      'call115Json': serializer.toJson<String>(call115Json),
      'citationsJson': serializer.toJson<String>(citationsJson),
    };
  }

  ProtocolRow copyWith({
    String? code,
    String? title,
    String? topicId,
    String? severity,
    String? targetAudience,
    String? ageGroup,
    String? version,
    String? updatedAt,
    String? sourceVerification,
    String? clinicalReview,
    String? reusePermission,
    Value<String?> notes = const Value.absent(),
    String? doNotJson,
    String? call115Json,
    String? citationsJson,
  }) => ProtocolRow(
    code: code ?? this.code,
    title: title ?? this.title,
    topicId: topicId ?? this.topicId,
    severity: severity ?? this.severity,
    targetAudience: targetAudience ?? this.targetAudience,
    ageGroup: ageGroup ?? this.ageGroup,
    version: version ?? this.version,
    updatedAt: updatedAt ?? this.updatedAt,
    sourceVerification: sourceVerification ?? this.sourceVerification,
    clinicalReview: clinicalReview ?? this.clinicalReview,
    reusePermission: reusePermission ?? this.reusePermission,
    notes: notes.present ? notes.value : this.notes,
    doNotJson: doNotJson ?? this.doNotJson,
    call115Json: call115Json ?? this.call115Json,
    citationsJson: citationsJson ?? this.citationsJson,
  );
  ProtocolRow copyWithCompanion(ProtocolsCompanion data) {
    return ProtocolRow(
      code: data.code.present ? data.code.value : this.code,
      title: data.title.present ? data.title.value : this.title,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      severity: data.severity.present ? data.severity.value : this.severity,
      targetAudience: data.targetAudience.present
          ? data.targetAudience.value
          : this.targetAudience,
      ageGroup: data.ageGroup.present ? data.ageGroup.value : this.ageGroup,
      version: data.version.present ? data.version.value : this.version,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sourceVerification: data.sourceVerification.present
          ? data.sourceVerification.value
          : this.sourceVerification,
      clinicalReview: data.clinicalReview.present
          ? data.clinicalReview.value
          : this.clinicalReview,
      reusePermission: data.reusePermission.present
          ? data.reusePermission.value
          : this.reusePermission,
      notes: data.notes.present ? data.notes.value : this.notes,
      doNotJson: data.doNotJson.present ? data.doNotJson.value : this.doNotJson,
      call115Json: data.call115Json.present
          ? data.call115Json.value
          : this.call115Json,
      citationsJson: data.citationsJson.present
          ? data.citationsJson.value
          : this.citationsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProtocolRow(')
          ..write('code: $code, ')
          ..write('title: $title, ')
          ..write('topicId: $topicId, ')
          ..write('severity: $severity, ')
          ..write('targetAudience: $targetAudience, ')
          ..write('ageGroup: $ageGroup, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sourceVerification: $sourceVerification, ')
          ..write('clinicalReview: $clinicalReview, ')
          ..write('reusePermission: $reusePermission, ')
          ..write('notes: $notes, ')
          ..write('doNotJson: $doNotJson, ')
          ..write('call115Json: $call115Json, ')
          ..write('citationsJson: $citationsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    code,
    title,
    topicId,
    severity,
    targetAudience,
    ageGroup,
    version,
    updatedAt,
    sourceVerification,
    clinicalReview,
    reusePermission,
    notes,
    doNotJson,
    call115Json,
    citationsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProtocolRow &&
          other.code == this.code &&
          other.title == this.title &&
          other.topicId == this.topicId &&
          other.severity == this.severity &&
          other.targetAudience == this.targetAudience &&
          other.ageGroup == this.ageGroup &&
          other.version == this.version &&
          other.updatedAt == this.updatedAt &&
          other.sourceVerification == this.sourceVerification &&
          other.clinicalReview == this.clinicalReview &&
          other.reusePermission == this.reusePermission &&
          other.notes == this.notes &&
          other.doNotJson == this.doNotJson &&
          other.call115Json == this.call115Json &&
          other.citationsJson == this.citationsJson);
}

class ProtocolsCompanion extends UpdateCompanion<ProtocolRow> {
  final Value<String> code;
  final Value<String> title;
  final Value<String> topicId;
  final Value<String> severity;
  final Value<String> targetAudience;
  final Value<String> ageGroup;
  final Value<String> version;
  final Value<String> updatedAt;
  final Value<String> sourceVerification;
  final Value<String> clinicalReview;
  final Value<String> reusePermission;
  final Value<String?> notes;
  final Value<String> doNotJson;
  final Value<String> call115Json;
  final Value<String> citationsJson;
  final Value<int> rowid;
  const ProtocolsCompanion({
    this.code = const Value.absent(),
    this.title = const Value.absent(),
    this.topicId = const Value.absent(),
    this.severity = const Value.absent(),
    this.targetAudience = const Value.absent(),
    this.ageGroup = const Value.absent(),
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sourceVerification = const Value.absent(),
    this.clinicalReview = const Value.absent(),
    this.reusePermission = const Value.absent(),
    this.notes = const Value.absent(),
    this.doNotJson = const Value.absent(),
    this.call115Json = const Value.absent(),
    this.citationsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProtocolsCompanion.insert({
    required String code,
    required String title,
    required String topicId,
    required String severity,
    required String targetAudience,
    required String ageGroup,
    required String version,
    required String updatedAt,
    required String sourceVerification,
    required String clinicalReview,
    required String reusePermission,
    this.notes = const Value.absent(),
    required String doNotJson,
    required String call115Json,
    required String citationsJson,
    this.rowid = const Value.absent(),
  }) : code = Value(code),
       title = Value(title),
       topicId = Value(topicId),
       severity = Value(severity),
       targetAudience = Value(targetAudience),
       ageGroup = Value(ageGroup),
       version = Value(version),
       updatedAt = Value(updatedAt),
       sourceVerification = Value(sourceVerification),
       clinicalReview = Value(clinicalReview),
       reusePermission = Value(reusePermission),
       doNotJson = Value(doNotJson),
       call115Json = Value(call115Json),
       citationsJson = Value(citationsJson);
  static Insertable<ProtocolRow> custom({
    Expression<String>? code,
    Expression<String>? title,
    Expression<String>? topicId,
    Expression<String>? severity,
    Expression<String>? targetAudience,
    Expression<String>? ageGroup,
    Expression<String>? version,
    Expression<String>? updatedAt,
    Expression<String>? sourceVerification,
    Expression<String>? clinicalReview,
    Expression<String>? reusePermission,
    Expression<String>? notes,
    Expression<String>? doNotJson,
    Expression<String>? call115Json,
    Expression<String>? citationsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (title != null) 'title': title,
      if (topicId != null) 'topic_id': topicId,
      if (severity != null) 'severity': severity,
      if (targetAudience != null) 'target_audience': targetAudience,
      if (ageGroup != null) 'age_group': ageGroup,
      if (version != null) 'version': version,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sourceVerification != null) 'source_verification': sourceVerification,
      if (clinicalReview != null) 'clinical_review': clinicalReview,
      if (reusePermission != null) 'reuse_permission': reusePermission,
      if (notes != null) 'notes': notes,
      if (doNotJson != null) 'do_not_json': doNotJson,
      if (call115Json != null) 'call115_json': call115Json,
      if (citationsJson != null) 'citations_json': citationsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProtocolsCompanion copyWith({
    Value<String>? code,
    Value<String>? title,
    Value<String>? topicId,
    Value<String>? severity,
    Value<String>? targetAudience,
    Value<String>? ageGroup,
    Value<String>? version,
    Value<String>? updatedAt,
    Value<String>? sourceVerification,
    Value<String>? clinicalReview,
    Value<String>? reusePermission,
    Value<String?>? notes,
    Value<String>? doNotJson,
    Value<String>? call115Json,
    Value<String>? citationsJson,
    Value<int>? rowid,
  }) {
    return ProtocolsCompanion(
      code: code ?? this.code,
      title: title ?? this.title,
      topicId: topicId ?? this.topicId,
      severity: severity ?? this.severity,
      targetAudience: targetAudience ?? this.targetAudience,
      ageGroup: ageGroup ?? this.ageGroup,
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
      sourceVerification: sourceVerification ?? this.sourceVerification,
      clinicalReview: clinicalReview ?? this.clinicalReview,
      reusePermission: reusePermission ?? this.reusePermission,
      notes: notes ?? this.notes,
      doNotJson: doNotJson ?? this.doNotJson,
      call115Json: call115Json ?? this.call115Json,
      citationsJson: citationsJson ?? this.citationsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (targetAudience.present) {
      map['target_audience'] = Variable<String>(targetAudience.value);
    }
    if (ageGroup.present) {
      map['age_group'] = Variable<String>(ageGroup.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (sourceVerification.present) {
      map['source_verification'] = Variable<String>(sourceVerification.value);
    }
    if (clinicalReview.present) {
      map['clinical_review'] = Variable<String>(clinicalReview.value);
    }
    if (reusePermission.present) {
      map['reuse_permission'] = Variable<String>(reusePermission.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (doNotJson.present) {
      map['do_not_json'] = Variable<String>(doNotJson.value);
    }
    if (call115Json.present) {
      map['call115_json'] = Variable<String>(call115Json.value);
    }
    if (citationsJson.present) {
      map['citations_json'] = Variable<String>(citationsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProtocolsCompanion(')
          ..write('code: $code, ')
          ..write('title: $title, ')
          ..write('topicId: $topicId, ')
          ..write('severity: $severity, ')
          ..write('targetAudience: $targetAudience, ')
          ..write('ageGroup: $ageGroup, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sourceVerification: $sourceVerification, ')
          ..write('clinicalReview: $clinicalReview, ')
          ..write('reusePermission: $reusePermission, ')
          ..write('notes: $notes, ')
          ..write('doNotJson: $doNotJson, ')
          ..write('call115Json: $call115Json, ')
          ..write('citationsJson: $citationsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProtocolStepsTable extends ProtocolSteps
    with TableInfo<$ProtocolStepsTable, ProtocolStepRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProtocolStepsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _protocolCodeMeta = const VerificationMeta(
    'protocolCode',
  );
  @override
  late final GeneratedColumn<String> protocolCode = GeneratedColumn<String>(
    'protocol_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES protocols (code)',
    ),
  );
  static const VerificationMeta _stepOrderMeta = const VerificationMeta(
    'stepOrder',
  );
  @override
  late final GeneratedColumn<int> stepOrder = GeneratedColumn<int>(
    'step_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepTextMeta = const VerificationMeta(
    'stepText',
  );
  @override
  late final GeneratedColumn<String> stepText = GeneratedColumn<String>(
    'step_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _citationMeta = const VerificationMeta(
    'citation',
  );
  @override
  late final GeneratedColumn<String> citation = GeneratedColumn<String>(
    'citation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    protocolCode,
    stepOrder,
    stepText,
    citation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'protocol_steps';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProtocolStepRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('protocol_code')) {
      context.handle(
        _protocolCodeMeta,
        protocolCode.isAcceptableOrUnknown(
          data['protocol_code']!,
          _protocolCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_protocolCodeMeta);
    }
    if (data.containsKey('step_order')) {
      context.handle(
        _stepOrderMeta,
        stepOrder.isAcceptableOrUnknown(data['step_order']!, _stepOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_stepOrderMeta);
    }
    if (data.containsKey('step_text')) {
      context.handle(
        _stepTextMeta,
        stepText.isAcceptableOrUnknown(data['step_text']!, _stepTextMeta),
      );
    } else if (isInserting) {
      context.missing(_stepTextMeta);
    }
    if (data.containsKey('citation')) {
      context.handle(
        _citationMeta,
        citation.isAcceptableOrUnknown(data['citation']!, _citationMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {protocolCode, stepOrder};
  @override
  ProtocolStepRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProtocolStepRow(
      protocolCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}protocol_code'],
      )!,
      stepOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}step_order'],
      )!,
      stepText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}step_text'],
      )!,
      citation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}citation'],
      ),
    );
  }

  @override
  $ProtocolStepsTable createAlias(String alias) {
    return $ProtocolStepsTable(attachedDatabase, alias);
  }
}

class ProtocolStepRow extends DataClass implements Insertable<ProtocolStepRow> {
  final String protocolCode;
  final int stepOrder;
  final String stepText;
  final String? citation;
  const ProtocolStepRow({
    required this.protocolCode,
    required this.stepOrder,
    required this.stepText,
    this.citation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['protocol_code'] = Variable<String>(protocolCode);
    map['step_order'] = Variable<int>(stepOrder);
    map['step_text'] = Variable<String>(stepText);
    if (!nullToAbsent || citation != null) {
      map['citation'] = Variable<String>(citation);
    }
    return map;
  }

  ProtocolStepsCompanion toCompanion(bool nullToAbsent) {
    return ProtocolStepsCompanion(
      protocolCode: Value(protocolCode),
      stepOrder: Value(stepOrder),
      stepText: Value(stepText),
      citation: citation == null && nullToAbsent
          ? const Value.absent()
          : Value(citation),
    );
  }

  factory ProtocolStepRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProtocolStepRow(
      protocolCode: serializer.fromJson<String>(json['protocolCode']),
      stepOrder: serializer.fromJson<int>(json['stepOrder']),
      stepText: serializer.fromJson<String>(json['stepText']),
      citation: serializer.fromJson<String?>(json['citation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'protocolCode': serializer.toJson<String>(protocolCode),
      'stepOrder': serializer.toJson<int>(stepOrder),
      'stepText': serializer.toJson<String>(stepText),
      'citation': serializer.toJson<String?>(citation),
    };
  }

  ProtocolStepRow copyWith({
    String? protocolCode,
    int? stepOrder,
    String? stepText,
    Value<String?> citation = const Value.absent(),
  }) => ProtocolStepRow(
    protocolCode: protocolCode ?? this.protocolCode,
    stepOrder: stepOrder ?? this.stepOrder,
    stepText: stepText ?? this.stepText,
    citation: citation.present ? citation.value : this.citation,
  );
  ProtocolStepRow copyWithCompanion(ProtocolStepsCompanion data) {
    return ProtocolStepRow(
      protocolCode: data.protocolCode.present
          ? data.protocolCode.value
          : this.protocolCode,
      stepOrder: data.stepOrder.present ? data.stepOrder.value : this.stepOrder,
      stepText: data.stepText.present ? data.stepText.value : this.stepText,
      citation: data.citation.present ? data.citation.value : this.citation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProtocolStepRow(')
          ..write('protocolCode: $protocolCode, ')
          ..write('stepOrder: $stepOrder, ')
          ..write('stepText: $stepText, ')
          ..write('citation: $citation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(protocolCode, stepOrder, stepText, citation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProtocolStepRow &&
          other.protocolCode == this.protocolCode &&
          other.stepOrder == this.stepOrder &&
          other.stepText == this.stepText &&
          other.citation == this.citation);
}

class ProtocolStepsCompanion extends UpdateCompanion<ProtocolStepRow> {
  final Value<String> protocolCode;
  final Value<int> stepOrder;
  final Value<String> stepText;
  final Value<String?> citation;
  final Value<int> rowid;
  const ProtocolStepsCompanion({
    this.protocolCode = const Value.absent(),
    this.stepOrder = const Value.absent(),
    this.stepText = const Value.absent(),
    this.citation = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProtocolStepsCompanion.insert({
    required String protocolCode,
    required int stepOrder,
    required String stepText,
    this.citation = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : protocolCode = Value(protocolCode),
       stepOrder = Value(stepOrder),
       stepText = Value(stepText);
  static Insertable<ProtocolStepRow> custom({
    Expression<String>? protocolCode,
    Expression<int>? stepOrder,
    Expression<String>? stepText,
    Expression<String>? citation,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (protocolCode != null) 'protocol_code': protocolCode,
      if (stepOrder != null) 'step_order': stepOrder,
      if (stepText != null) 'step_text': stepText,
      if (citation != null) 'citation': citation,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProtocolStepsCompanion copyWith({
    Value<String>? protocolCode,
    Value<int>? stepOrder,
    Value<String>? stepText,
    Value<String?>? citation,
    Value<int>? rowid,
  }) {
    return ProtocolStepsCompanion(
      protocolCode: protocolCode ?? this.protocolCode,
      stepOrder: stepOrder ?? this.stepOrder,
      stepText: stepText ?? this.stepText,
      citation: citation ?? this.citation,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (protocolCode.present) {
      map['protocol_code'] = Variable<String>(protocolCode.value);
    }
    if (stepOrder.present) {
      map['step_order'] = Variable<int>(stepOrder.value);
    }
    if (stepText.present) {
      map['step_text'] = Variable<String>(stepText.value);
    }
    if (citation.present) {
      map['citation'] = Variable<String>(citation.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProtocolStepsCompanion(')
          ..write('protocolCode: $protocolCode, ')
          ..write('stepOrder: $stepOrder, ')
          ..write('stepText: $stepText, ')
          ..write('citation: $citation, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TriageNodesTable extends TriageNodes
    with TableInfo<$TriageNodesTable, TriageNodeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TriageNodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionMeta = const VerificationMeta(
    'question',
  );
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
    'question',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yesNodeIdMeta = const VerificationMeta(
    'yesNodeId',
  );
  @override
  late final GeneratedColumn<String> yesNodeId = GeneratedColumn<String>(
    'yes_node_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noNodeIdMeta = const VerificationMeta(
    'noNodeId',
  );
  @override
  late final GeneratedColumn<String> noNodeId = GeneratedColumn<String>(
    'no_node_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _protocolCodeMeta = const VerificationMeta(
    'protocolCode',
  );
  @override
  late final GeneratedColumn<String> protocolCode = GeneratedColumn<String>(
    'protocol_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _callEmergencyNowMeta = const VerificationMeta(
    'callEmergencyNow',
  );
  @override
  late final GeneratedColumn<bool> callEmergencyNow = GeneratedColumn<bool>(
    'call_emergency_now',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("call_emergency_now" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _citationsJsonMeta = const VerificationMeta(
    'citationsJson',
  );
  @override
  late final GeneratedColumn<String> citationsJson = GeneratedColumn<String>(
    'citations_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    question,
    yesNodeId,
    noNodeId,
    protocolCode,
    callEmergencyNow,
    citationsJson,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'triage_nodes';
  @override
  VerificationContext validateIntegrity(
    Insertable<TriageNodeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('question')) {
      context.handle(
        _questionMeta,
        question.isAcceptableOrUnknown(data['question']!, _questionMeta),
      );
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('yes_node_id')) {
      context.handle(
        _yesNodeIdMeta,
        yesNodeId.isAcceptableOrUnknown(data['yes_node_id']!, _yesNodeIdMeta),
      );
    }
    if (data.containsKey('no_node_id')) {
      context.handle(
        _noNodeIdMeta,
        noNodeId.isAcceptableOrUnknown(data['no_node_id']!, _noNodeIdMeta),
      );
    }
    if (data.containsKey('protocol_code')) {
      context.handle(
        _protocolCodeMeta,
        protocolCode.isAcceptableOrUnknown(
          data['protocol_code']!,
          _protocolCodeMeta,
        ),
      );
    }
    if (data.containsKey('call_emergency_now')) {
      context.handle(
        _callEmergencyNowMeta,
        callEmergencyNow.isAcceptableOrUnknown(
          data['call_emergency_now']!,
          _callEmergencyNowMeta,
        ),
      );
    }
    if (data.containsKey('citations_json')) {
      context.handle(
        _citationsJsonMeta,
        citationsJson.isAcceptableOrUnknown(
          data['citations_json']!,
          _citationsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_citationsJsonMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TriageNodeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TriageNodeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      question: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question'],
      )!,
      yesNodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}yes_node_id'],
      ),
      noNodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}no_node_id'],
      ),
      protocolCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}protocol_code'],
      ),
      callEmergencyNow: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}call_emergency_now'],
      )!,
      citationsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}citations_json'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $TriageNodesTable createAlias(String alias) {
    return $TriageNodesTable(attachedDatabase, alias);
  }
}

class TriageNodeRow extends DataClass implements Insertable<TriageNodeRow> {
  final String id;
  final String question;
  final String? yesNodeId;
  final String? noNodeId;
  final String? protocolCode;
  final bool callEmergencyNow;
  final String citationsJson;
  final String? note;
  const TriageNodeRow({
    required this.id,
    required this.question,
    this.yesNodeId,
    this.noNodeId,
    this.protocolCode,
    required this.callEmergencyNow,
    required this.citationsJson,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['question'] = Variable<String>(question);
    if (!nullToAbsent || yesNodeId != null) {
      map['yes_node_id'] = Variable<String>(yesNodeId);
    }
    if (!nullToAbsent || noNodeId != null) {
      map['no_node_id'] = Variable<String>(noNodeId);
    }
    if (!nullToAbsent || protocolCode != null) {
      map['protocol_code'] = Variable<String>(protocolCode);
    }
    map['call_emergency_now'] = Variable<bool>(callEmergencyNow);
    map['citations_json'] = Variable<String>(citationsJson);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  TriageNodesCompanion toCompanion(bool nullToAbsent) {
    return TriageNodesCompanion(
      id: Value(id),
      question: Value(question),
      yesNodeId: yesNodeId == null && nullToAbsent
          ? const Value.absent()
          : Value(yesNodeId),
      noNodeId: noNodeId == null && nullToAbsent
          ? const Value.absent()
          : Value(noNodeId),
      protocolCode: protocolCode == null && nullToAbsent
          ? const Value.absent()
          : Value(protocolCode),
      callEmergencyNow: Value(callEmergencyNow),
      citationsJson: Value(citationsJson),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory TriageNodeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TriageNodeRow(
      id: serializer.fromJson<String>(json['id']),
      question: serializer.fromJson<String>(json['question']),
      yesNodeId: serializer.fromJson<String?>(json['yesNodeId']),
      noNodeId: serializer.fromJson<String?>(json['noNodeId']),
      protocolCode: serializer.fromJson<String?>(json['protocolCode']),
      callEmergencyNow: serializer.fromJson<bool>(json['callEmergencyNow']),
      citationsJson: serializer.fromJson<String>(json['citationsJson']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'question': serializer.toJson<String>(question),
      'yesNodeId': serializer.toJson<String?>(yesNodeId),
      'noNodeId': serializer.toJson<String?>(noNodeId),
      'protocolCode': serializer.toJson<String?>(protocolCode),
      'callEmergencyNow': serializer.toJson<bool>(callEmergencyNow),
      'citationsJson': serializer.toJson<String>(citationsJson),
      'note': serializer.toJson<String?>(note),
    };
  }

  TriageNodeRow copyWith({
    String? id,
    String? question,
    Value<String?> yesNodeId = const Value.absent(),
    Value<String?> noNodeId = const Value.absent(),
    Value<String?> protocolCode = const Value.absent(),
    bool? callEmergencyNow,
    String? citationsJson,
    Value<String?> note = const Value.absent(),
  }) => TriageNodeRow(
    id: id ?? this.id,
    question: question ?? this.question,
    yesNodeId: yesNodeId.present ? yesNodeId.value : this.yesNodeId,
    noNodeId: noNodeId.present ? noNodeId.value : this.noNodeId,
    protocolCode: protocolCode.present ? protocolCode.value : this.protocolCode,
    callEmergencyNow: callEmergencyNow ?? this.callEmergencyNow,
    citationsJson: citationsJson ?? this.citationsJson,
    note: note.present ? note.value : this.note,
  );
  TriageNodeRow copyWithCompanion(TriageNodesCompanion data) {
    return TriageNodeRow(
      id: data.id.present ? data.id.value : this.id,
      question: data.question.present ? data.question.value : this.question,
      yesNodeId: data.yesNodeId.present ? data.yesNodeId.value : this.yesNodeId,
      noNodeId: data.noNodeId.present ? data.noNodeId.value : this.noNodeId,
      protocolCode: data.protocolCode.present
          ? data.protocolCode.value
          : this.protocolCode,
      callEmergencyNow: data.callEmergencyNow.present
          ? data.callEmergencyNow.value
          : this.callEmergencyNow,
      citationsJson: data.citationsJson.present
          ? data.citationsJson.value
          : this.citationsJson,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TriageNodeRow(')
          ..write('id: $id, ')
          ..write('question: $question, ')
          ..write('yesNodeId: $yesNodeId, ')
          ..write('noNodeId: $noNodeId, ')
          ..write('protocolCode: $protocolCode, ')
          ..write('callEmergencyNow: $callEmergencyNow, ')
          ..write('citationsJson: $citationsJson, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    question,
    yesNodeId,
    noNodeId,
    protocolCode,
    callEmergencyNow,
    citationsJson,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TriageNodeRow &&
          other.id == this.id &&
          other.question == this.question &&
          other.yesNodeId == this.yesNodeId &&
          other.noNodeId == this.noNodeId &&
          other.protocolCode == this.protocolCode &&
          other.callEmergencyNow == this.callEmergencyNow &&
          other.citationsJson == this.citationsJson &&
          other.note == this.note);
}

class TriageNodesCompanion extends UpdateCompanion<TriageNodeRow> {
  final Value<String> id;
  final Value<String> question;
  final Value<String?> yesNodeId;
  final Value<String?> noNodeId;
  final Value<String?> protocolCode;
  final Value<bool> callEmergencyNow;
  final Value<String> citationsJson;
  final Value<String?> note;
  final Value<int> rowid;
  const TriageNodesCompanion({
    this.id = const Value.absent(),
    this.question = const Value.absent(),
    this.yesNodeId = const Value.absent(),
    this.noNodeId = const Value.absent(),
    this.protocolCode = const Value.absent(),
    this.callEmergencyNow = const Value.absent(),
    this.citationsJson = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TriageNodesCompanion.insert({
    required String id,
    required String question,
    this.yesNodeId = const Value.absent(),
    this.noNodeId = const Value.absent(),
    this.protocolCode = const Value.absent(),
    this.callEmergencyNow = const Value.absent(),
    required String citationsJson,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       question = Value(question),
       citationsJson = Value(citationsJson);
  static Insertable<TriageNodeRow> custom({
    Expression<String>? id,
    Expression<String>? question,
    Expression<String>? yesNodeId,
    Expression<String>? noNodeId,
    Expression<String>? protocolCode,
    Expression<bool>? callEmergencyNow,
    Expression<String>? citationsJson,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (question != null) 'question': question,
      if (yesNodeId != null) 'yes_node_id': yesNodeId,
      if (noNodeId != null) 'no_node_id': noNodeId,
      if (protocolCode != null) 'protocol_code': protocolCode,
      if (callEmergencyNow != null) 'call_emergency_now': callEmergencyNow,
      if (citationsJson != null) 'citations_json': citationsJson,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TriageNodesCompanion copyWith({
    Value<String>? id,
    Value<String>? question,
    Value<String?>? yesNodeId,
    Value<String?>? noNodeId,
    Value<String?>? protocolCode,
    Value<bool>? callEmergencyNow,
    Value<String>? citationsJson,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return TriageNodesCompanion(
      id: id ?? this.id,
      question: question ?? this.question,
      yesNodeId: yesNodeId ?? this.yesNodeId,
      noNodeId: noNodeId ?? this.noNodeId,
      protocolCode: protocolCode ?? this.protocolCode,
      callEmergencyNow: callEmergencyNow ?? this.callEmergencyNow,
      citationsJson: citationsJson ?? this.citationsJson,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (yesNodeId.present) {
      map['yes_node_id'] = Variable<String>(yesNodeId.value);
    }
    if (noNodeId.present) {
      map['no_node_id'] = Variable<String>(noNodeId.value);
    }
    if (protocolCode.present) {
      map['protocol_code'] = Variable<String>(protocolCode.value);
    }
    if (callEmergencyNow.present) {
      map['call_emergency_now'] = Variable<bool>(callEmergencyNow.value);
    }
    if (citationsJson.present) {
      map['citations_json'] = Variable<String>(citationsJson.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TriageNodesCompanion(')
          ..write('id: $id, ')
          ..write('question: $question, ')
          ..write('yesNodeId: $yesNodeId, ')
          ..write('noNodeId: $noNodeId, ')
          ..write('protocolCode: $protocolCode, ')
          ..write('callEmergencyNow: $callEmergencyNow, ')
          ..write('citationsJson: $citationsJson, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MetaTable extends Meta with TableInfo<$MetaTable, MetaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<MetaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  MetaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetaRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $MetaTable createAlias(String alias) {
    return $MetaTable(attachedDatabase, alias);
  }
}

class MetaRow extends DataClass implements Insertable<MetaRow> {
  final String key;
  final String value;
  const MetaRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  MetaCompanion toCompanion(bool nullToAbsent) {
    return MetaCompanion(key: Value(key), value: Value(value));
  }

  factory MetaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetaRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  MetaRow copyWith({String? key, String? value}) =>
      MetaRow(key: key ?? this.key, value: value ?? this.value);
  MetaRow copyWithCompanion(MetaCompanion data) {
    return MetaRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetaRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetaRow && other.key == this.key && other.value == this.value);
}

class MetaCompanion extends UpdateCompanion<MetaRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const MetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<MetaRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MetaCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return MetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProtocolsTable protocols = $ProtocolsTable(this);
  late final $ProtocolStepsTable protocolSteps = $ProtocolStepsTable(this);
  late final $TriageNodesTable triageNodes = $TriageNodesTable(this);
  late final $MetaTable meta = $MetaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    protocols,
    protocolSteps,
    triageNodes,
    meta,
  ];
}

typedef $$ProtocolsTableCreateCompanionBuilder = ProtocolsCompanion Function({
  required String code,
  required String title,
  required String topicId,
  required String severity,
  required String targetAudience,
  required String ageGroup,
  required String version,
  required String updatedAt,
  required String sourceVerification,
  required String clinicalReview,
  required String reusePermission,
  Value<String?> notes,
  required String doNotJson,
  required String call115Json,
  required String citationsJson,
  Value<int> rowid,
});
typedef $$ProtocolsTableUpdateCompanionBuilder = ProtocolsCompanion Function({
  Value<String> code,
  Value<String> title,
  Value<String> topicId,
  Value<String> severity,
  Value<String> targetAudience,
  Value<String> ageGroup,
  Value<String> version,
  Value<String> updatedAt,
  Value<String> sourceVerification,
  Value<String> clinicalReview,
  Value<String> reusePermission,
  Value<String?> notes,
  Value<String> doNotJson,
  Value<String> call115Json,
  Value<String> citationsJson,
  Value<int> rowid,
});

final class $$ProtocolsTableReferences
    extends BaseReferences<_$AppDatabase, $ProtocolsTable, ProtocolRow> {
  $$ProtocolsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProtocolStepsTable, List<ProtocolStepRow>>
  _protocolStepsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.protocolSteps,
    aliasName: 'protocols__code__protocol_steps__protocol_code',
  );

  $$ProtocolStepsTableProcessedTableManager get protocolStepsRefs {
    final manager = $$ProtocolStepsTableTableManager($_db, $_db.protocolSteps)
        .filter(
          (f) => f.protocolCode.code.sqlEquals($_itemColumn<String>('code')!),
        );

    final cache = $_typedResult.readTableOrNull(_protocolStepsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProtocolsTableFilterComposer
    extends Composer<_$AppDatabase, $ProtocolsTable> {
  $$ProtocolsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topicId => $composableBuilder(
    column: $table.topicId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetAudience => $composableBuilder(
    column: $table.targetAudience,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ageGroup => $composableBuilder(
    column: $table.ageGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceVerification => $composableBuilder(
    column: $table.sourceVerification,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clinicalReview => $composableBuilder(
    column: $table.clinicalReview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reusePermission => $composableBuilder(
    column: $table.reusePermission,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doNotJson => $composableBuilder(
    column: $table.doNotJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get call115Json => $composableBuilder(
    column: $table.call115Json,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get citationsJson => $composableBuilder(
    column: $table.citationsJson,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> protocolStepsRefs(
    Expression<bool> Function($$ProtocolStepsTableFilterComposer f) f,
  ) {
    final $$ProtocolStepsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.protocolSteps,
      getReferencedColumn: (t) => t.protocolCode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProtocolStepsTableFilterComposer(
            $db: $db,
            $table: $db.protocolSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProtocolsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProtocolsTable> {
  $$ProtocolsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topicId => $composableBuilder(
    column: $table.topicId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetAudience => $composableBuilder(
    column: $table.targetAudience,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ageGroup => $composableBuilder(
    column: $table.ageGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceVerification => $composableBuilder(
    column: $table.sourceVerification,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clinicalReview => $composableBuilder(
    column: $table.clinicalReview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reusePermission => $composableBuilder(
    column: $table.reusePermission,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doNotJson => $composableBuilder(
    column: $table.doNotJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get call115Json => $composableBuilder(
    column: $table.call115Json,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get citationsJson => $composableBuilder(
    column: $table.citationsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProtocolsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProtocolsTable> {
  $$ProtocolsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get topicId =>
      $composableBuilder(column: $table.topicId, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get targetAudience => $composableBuilder(
    column: $table.targetAudience,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ageGroup =>
      $composableBuilder(column: $table.ageGroup, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get sourceVerification => $composableBuilder(
    column: $table.sourceVerification,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clinicalReview => $composableBuilder(
    column: $table.clinicalReview,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reusePermission => $composableBuilder(
    column: $table.reusePermission,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get doNotJson =>
      $composableBuilder(column: $table.doNotJson, builder: (column) => column);

  GeneratedColumn<String> get call115Json => $composableBuilder(
    column: $table.call115Json,
    builder: (column) => column,
  );

  GeneratedColumn<String> get citationsJson => $composableBuilder(
    column: $table.citationsJson,
    builder: (column) => column,
  );

  Expression<T> protocolStepsRefs<T extends Object>(
    Expression<T> Function($$ProtocolStepsTableAnnotationComposer a) f,
  ) {
    final $$ProtocolStepsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.protocolSteps,
      getReferencedColumn: (t) => t.protocolCode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProtocolStepsTableAnnotationComposer(
            $db: $db,
            $table: $db.protocolSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProtocolsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProtocolsTable,
          ProtocolRow,
          $$ProtocolsTableFilterComposer,
          $$ProtocolsTableOrderingComposer,
          $$ProtocolsTableAnnotationComposer,
          $$ProtocolsTableCreateCompanionBuilder,
          $$ProtocolsTableUpdateCompanionBuilder,
          (ProtocolRow, $$ProtocolsTableReferences),
          ProtocolRow,
          PrefetchHooks Function({bool protocolStepsRefs})
        > {
  $$ProtocolsTableTableManager(_$AppDatabase db, $ProtocolsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProtocolsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProtocolsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProtocolsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> code = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> topicId = const Value.absent(),
                Value<String> severity = const Value.absent(),
                Value<String> targetAudience = const Value.absent(),
                Value<String> ageGroup = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String> sourceVerification = const Value.absent(),
                Value<String> clinicalReview = const Value.absent(),
                Value<String> reusePermission = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> doNotJson = const Value.absent(),
                Value<String> call115Json = const Value.absent(),
                Value<String> citationsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProtocolsCompanion(
                code: code,
                title: title,
                topicId: topicId,
                severity: severity,
                targetAudience: targetAudience,
                ageGroup: ageGroup,
                version: version,
                updatedAt: updatedAt,
                sourceVerification: sourceVerification,
                clinicalReview: clinicalReview,
                reusePermission: reusePermission,
                notes: notes,
                doNotJson: doNotJson,
                call115Json: call115Json,
                citationsJson: citationsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String code,
                required String title,
                required String topicId,
                required String severity,
                required String targetAudience,
                required String ageGroup,
                required String version,
                required String updatedAt,
                required String sourceVerification,
                required String clinicalReview,
                required String reusePermission,
                Value<String?> notes = const Value.absent(),
                required String doNotJson,
                required String call115Json,
                required String citationsJson,
                Value<int> rowid = const Value.absent(),
              }) => ProtocolsCompanion.insert(
                code: code,
                title: title,
                topicId: topicId,
                severity: severity,
                targetAudience: targetAudience,
                ageGroup: ageGroup,
                version: version,
                updatedAt: updatedAt,
                sourceVerification: sourceVerification,
                clinicalReview: clinicalReview,
                reusePermission: reusePermission,
                notes: notes,
                doNotJson: doNotJson,
                call115Json: call115Json,
                citationsJson: citationsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProtocolsTable, ProtocolRow>(table),
                  $$ProtocolsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({protocolStepsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (protocolStepsRefs) db.protocolSteps,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (protocolStepsRefs)
                    await $_getPrefetchedDataByColumns<
                      ProtocolRow,
                      $ProtocolsTable,
                      ProtocolStepRow,
                      $ProtocolStepsTable
                    >(
                      currentTable: table,
                      referencedTable: $$ProtocolsTableReferences
                          ._protocolStepsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProtocolsTableReferences(
                            db,
                            table,
                            p0,
                          ).protocolStepsRefs,
                      currentColumn: 'code',
                      referencedColumn: 'protocol_code',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProtocolsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProtocolsTable,
      ProtocolRow,
      $$ProtocolsTableFilterComposer,
      $$ProtocolsTableOrderingComposer,
      $$ProtocolsTableAnnotationComposer,
      $$ProtocolsTableCreateCompanionBuilder,
      $$ProtocolsTableUpdateCompanionBuilder,
      (ProtocolRow, $$ProtocolsTableReferences),
      ProtocolRow,
      PrefetchHooks Function({bool protocolStepsRefs})
    >;
typedef $$ProtocolStepsTableCreateCompanionBuilder =
    ProtocolStepsCompanion Function({
      required String protocolCode,
      required int stepOrder,
      required String stepText,
      Value<String?> citation,
      Value<int> rowid,
    });
typedef $$ProtocolStepsTableUpdateCompanionBuilder =
    ProtocolStepsCompanion Function({
      Value<String> protocolCode,
      Value<int> stepOrder,
      Value<String> stepText,
      Value<String?> citation,
      Value<int> rowid,
    });

final class $$ProtocolStepsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ProtocolStepsTable, ProtocolStepRow> {
  $$ProtocolStepsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProtocolsTable _protocolCodeTable(_$AppDatabase db) => db.protocols
      .createAlias('protocol_steps__protocol_code__protocols__code');

  $$ProtocolsTableProcessedTableManager get protocolCode {
    final $_column = $_itemColumn<String>('protocol_code')!;

    final manager = $$ProtocolsTableTableManager(
      $_db,
      $_db.protocols,
    ).filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_protocolCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProtocolStepsTableFilterComposer
    extends Composer<_$AppDatabase, $ProtocolStepsTable> {
  $$ProtocolStepsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get stepOrder => $composableBuilder(
    column: $table.stepOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stepText => $composableBuilder(
    column: $table.stepText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get citation => $composableBuilder(
    column: $table.citation,
    builder: (column) => ColumnFilters(column),
  );

  $$ProtocolsTableFilterComposer get protocolCode {
    final $$ProtocolsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.protocolCode,
      referencedTable: $db.protocols,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProtocolsTableFilterComposer(
            $db: $db,
            $table: $db.protocols,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProtocolStepsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProtocolStepsTable> {
  $$ProtocolStepsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get stepOrder => $composableBuilder(
    column: $table.stepOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stepText => $composableBuilder(
    column: $table.stepText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get citation => $composableBuilder(
    column: $table.citation,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProtocolsTableOrderingComposer get protocolCode {
    final $$ProtocolsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.protocolCode,
      referencedTable: $db.protocols,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProtocolsTableOrderingComposer(
            $db: $db,
            $table: $db.protocols,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProtocolStepsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProtocolStepsTable> {
  $$ProtocolStepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get stepOrder =>
      $composableBuilder(column: $table.stepOrder, builder: (column) => column);

  GeneratedColumn<String> get stepText =>
      $composableBuilder(column: $table.stepText, builder: (column) => column);

  GeneratedColumn<String> get citation =>
      $composableBuilder(column: $table.citation, builder: (column) => column);

  $$ProtocolsTableAnnotationComposer get protocolCode {
    final $$ProtocolsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.protocolCode,
      referencedTable: $db.protocols,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProtocolsTableAnnotationComposer(
            $db: $db,
            $table: $db.protocols,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProtocolStepsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProtocolStepsTable,
          ProtocolStepRow,
          $$ProtocolStepsTableFilterComposer,
          $$ProtocolStepsTableOrderingComposer,
          $$ProtocolStepsTableAnnotationComposer,
          $$ProtocolStepsTableCreateCompanionBuilder,
          $$ProtocolStepsTableUpdateCompanionBuilder,
          (ProtocolStepRow, $$ProtocolStepsTableReferences),
          ProtocolStepRow,
          PrefetchHooks Function({bool protocolCode})
        > {
  $$ProtocolStepsTableTableManager(_$AppDatabase db, $ProtocolStepsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProtocolStepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProtocolStepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProtocolStepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> protocolCode = const Value.absent(),
                Value<int> stepOrder = const Value.absent(),
                Value<String> stepText = const Value.absent(),
                Value<String?> citation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProtocolStepsCompanion(
                protocolCode: protocolCode,
                stepOrder: stepOrder,
                stepText: stepText,
                citation: citation,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String protocolCode,
                required int stepOrder,
                required String stepText,
                Value<String?> citation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProtocolStepsCompanion.insert(
                protocolCode: protocolCode,
                stepOrder: stepOrder,
                stepText: stepText,
                citation: citation,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProtocolStepsTable, ProtocolStepRow>(table),
                  $$ProtocolStepsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({protocolCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (protocolCode) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.protocolCode,
                        referencedTable: $$ProtocolStepsTableReferences
                            ._protocolCodeTable(db),
                        referencedColumn: $$ProtocolStepsTableReferences
                            ._protocolCodeTable(db)
                            .code,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProtocolStepsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProtocolStepsTable,
      ProtocolStepRow,
      $$ProtocolStepsTableFilterComposer,
      $$ProtocolStepsTableOrderingComposer,
      $$ProtocolStepsTableAnnotationComposer,
      $$ProtocolStepsTableCreateCompanionBuilder,
      $$ProtocolStepsTableUpdateCompanionBuilder,
      (ProtocolStepRow, $$ProtocolStepsTableReferences),
      ProtocolStepRow,
      PrefetchHooks Function({bool protocolCode})
    >;
typedef $$TriageNodesTableCreateCompanionBuilder =
    TriageNodesCompanion Function({
      required String id,
      required String question,
      Value<String?> yesNodeId,
      Value<String?> noNodeId,
      Value<String?> protocolCode,
      Value<bool> callEmergencyNow,
      required String citationsJson,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$TriageNodesTableUpdateCompanionBuilder =
    TriageNodesCompanion Function({
      Value<String> id,
      Value<String> question,
      Value<String?> yesNodeId,
      Value<String?> noNodeId,
      Value<String?> protocolCode,
      Value<bool> callEmergencyNow,
      Value<String> citationsJson,
      Value<String?> note,
      Value<int> rowid,
    });

class $$TriageNodesTableFilterComposer
    extends Composer<_$AppDatabase, $TriageNodesTable> {
  $$TriageNodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get yesNodeId => $composableBuilder(
    column: $table.yesNodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noNodeId => $composableBuilder(
    column: $table.noNodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get protocolCode => $composableBuilder(
    column: $table.protocolCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get callEmergencyNow => $composableBuilder(
    column: $table.callEmergencyNow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get citationsJson => $composableBuilder(
    column: $table.citationsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TriageNodesTableOrderingComposer
    extends Composer<_$AppDatabase, $TriageNodesTable> {
  $$TriageNodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get yesNodeId => $composableBuilder(
    column: $table.yesNodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noNodeId => $composableBuilder(
    column: $table.noNodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get protocolCode => $composableBuilder(
    column: $table.protocolCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get callEmergencyNow => $composableBuilder(
    column: $table.callEmergencyNow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get citationsJson => $composableBuilder(
    column: $table.citationsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TriageNodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TriageNodesTable> {
  $$TriageNodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumn<String> get yesNodeId =>
      $composableBuilder(column: $table.yesNodeId, builder: (column) => column);

  GeneratedColumn<String> get noNodeId =>
      $composableBuilder(column: $table.noNodeId, builder: (column) => column);

  GeneratedColumn<String> get protocolCode => $composableBuilder(
    column: $table.protocolCode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get callEmergencyNow => $composableBuilder(
    column: $table.callEmergencyNow,
    builder: (column) => column,
  );

  GeneratedColumn<String> get citationsJson => $composableBuilder(
    column: $table.citationsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$TriageNodesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TriageNodesTable,
          TriageNodeRow,
          $$TriageNodesTableFilterComposer,
          $$TriageNodesTableOrderingComposer,
          $$TriageNodesTableAnnotationComposer,
          $$TriageNodesTableCreateCompanionBuilder,
          $$TriageNodesTableUpdateCompanionBuilder,
          (
            TriageNodeRow,
            BaseReferences<_$AppDatabase, $TriageNodesTable, TriageNodeRow>,
          ),
          TriageNodeRow,
          PrefetchHooks Function()
        > {
  $$TriageNodesTableTableManager(_$AppDatabase db, $TriageNodesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TriageNodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TriageNodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TriageNodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> question = const Value.absent(),
                Value<String?> yesNodeId = const Value.absent(),
                Value<String?> noNodeId = const Value.absent(),
                Value<String?> protocolCode = const Value.absent(),
                Value<bool> callEmergencyNow = const Value.absent(),
                Value<String> citationsJson = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TriageNodesCompanion(
                id: id,
                question: question,
                yesNodeId: yesNodeId,
                noNodeId: noNodeId,
                protocolCode: protocolCode,
                callEmergencyNow: callEmergencyNow,
                citationsJson: citationsJson,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String question,
                Value<String?> yesNodeId = const Value.absent(),
                Value<String?> noNodeId = const Value.absent(),
                Value<String?> protocolCode = const Value.absent(),
                Value<bool> callEmergencyNow = const Value.absent(),
                required String citationsJson,
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TriageNodesCompanion.insert(
                id: id,
                question: question,
                yesNodeId: yesNodeId,
                noNodeId: noNodeId,
                protocolCode: protocolCode,
                callEmergencyNow: callEmergencyNow,
                citationsJson: citationsJson,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TriageNodesTable, TriageNodeRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $TriageNodesTable,
                    TriageNodeRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TriageNodesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TriageNodesTable,
      TriageNodeRow,
      $$TriageNodesTableFilterComposer,
      $$TriageNodesTableOrderingComposer,
      $$TriageNodesTableAnnotationComposer,
      $$TriageNodesTableCreateCompanionBuilder,
      $$TriageNodesTableUpdateCompanionBuilder,
      (
        TriageNodeRow,
        BaseReferences<_$AppDatabase, $TriageNodesTable, TriageNodeRow>,
      ),
      TriageNodeRow,
      PrefetchHooks Function()
    >;
typedef $$MetaTableCreateCompanionBuilder = MetaCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$MetaTableUpdateCompanionBuilder = MetaCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$MetaTableFilterComposer extends Composer<_$AppDatabase, $MetaTable> {
  $$MetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MetaTableOrderingComposer extends Composer<_$AppDatabase, $MetaTable> {
  $$MetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $MetaTable> {
  $$MetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$MetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MetaTable,
          MetaRow,
          $$MetaTableFilterComposer,
          $$MetaTableOrderingComposer,
          $$MetaTableAnnotationComposer,
          $$MetaTableCreateCompanionBuilder,
          $$MetaTableUpdateCompanionBuilder,
          (MetaRow, BaseReferences<_$AppDatabase, $MetaTable, MetaRow>),
          MetaRow,
          PrefetchHooks Function()
        > {
  $$MetaTableTableManager(_$AppDatabase db, $MetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => MetaCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => MetaCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MetaTable, MetaRow>(table),
                  BaseReferences<_$AppDatabase, $MetaTable, MetaRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MetaTable,
      MetaRow,
      $$MetaTableFilterComposer,
      $$MetaTableOrderingComposer,
      $$MetaTableAnnotationComposer,
      $$MetaTableCreateCompanionBuilder,
      $$MetaTableUpdateCompanionBuilder,
      (MetaRow, BaseReferences<_$AppDatabase, $MetaTable, MetaRow>),
      MetaRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProtocolsTableTableManager get protocols =>
      $$ProtocolsTableTableManager(_db, _db.protocols);
  $$ProtocolStepsTableTableManager get protocolSteps =>
      $$ProtocolStepsTableTableManager(_db, _db.protocolSteps);
  $$TriageNodesTableTableManager get triageNodes =>
      $$TriageNodesTableTableManager(_db, _db.triageNodes);
  $$MetaTableTableManager get meta => $$MetaTableTableManager(_db, _db.meta);
}
