// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppMetaEntriesTable extends AppMetaEntries
    with TableInfo<$AppMetaEntriesTable, AppMetaEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppMetaEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'app_meta_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppMetaEntry> instance, {
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
  AppMetaEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppMetaEntry(
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
  $AppMetaEntriesTable createAlias(String alias) {
    return $AppMetaEntriesTable(attachedDatabase, alias);
  }
}

class AppMetaEntry extends DataClass implements Insertable<AppMetaEntry> {
  final String key;
  final String value;
  const AppMetaEntry({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppMetaEntriesCompanion toCompanion(bool nullToAbsent) {
    return AppMetaEntriesCompanion(key: Value(key), value: Value(value));
  }

  factory AppMetaEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppMetaEntry(
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

  AppMetaEntry copyWith({String? key, String? value}) =>
      AppMetaEntry(key: key ?? this.key, value: value ?? this.value);
  AppMetaEntry copyWithCompanion(AppMetaEntriesCompanion data) {
    return AppMetaEntry(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppMetaEntry(')
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
      (other is AppMetaEntry &&
          other.key == this.key &&
          other.value == this.value);
}

class AppMetaEntriesCompanion extends UpdateCompanion<AppMetaEntry> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppMetaEntriesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppMetaEntriesCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppMetaEntry> custom({
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

  AppMetaEntriesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppMetaEntriesCompanion(
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
    return (StringBuffer('AppMetaEntriesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _courseMeta = const VerificationMeta('course');
  @override
  late final GeneratedColumn<String> course = GeneratedColumn<String>(
    'course',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedMinutesMeta = const VerificationMeta(
    'estimatedMinutes',
  );
  @override
  late final GeneratedColumn<int> estimatedMinutes = GeneratedColumn<int>(
    'estimated_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deadlineMeta = const VerificationMeta(
    'deadline',
  );
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
    'deadline',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _proofTextMeta = const VerificationMeta(
    'proofText',
  );
  @override
  late final GeneratedColumn<String> proofText = GeneratedColumn<String>(
    'proof_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _proofLinkMeta = const VerificationMeta(
    'proofLink',
  );
  @override
  late final GeneratedColumn<String> proofLink = GeneratedColumn<String>(
    'proof_link',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _overduePenaltyAppliedMeta =
      const VerificationMeta('overduePenaltyApplied');
  @override
  late final GeneratedColumn<bool> overduePenaltyApplied =
      GeneratedColumn<bool>(
        'overdue_penalty_applied',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("overdue_penalty_applied" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    course,
    type,
    priority,
    points,
    estimatedMinutes,
    createdAt,
    deadline,
    note,
    proofText,
    proofLink,
    done,
    completedAt,
    overduePenaltyApplied,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('course')) {
      context.handle(
        _courseMeta,
        course.isAcceptableOrUnknown(data['course']!, _courseMeta),
      );
    } else if (isInserting) {
      context.missing(_courseMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    } else if (isInserting) {
      context.missing(_pointsMeta);
    }
    if (data.containsKey('estimated_minutes')) {
      context.handle(
        _estimatedMinutesMeta,
        estimatedMinutes.isAcceptableOrUnknown(
          data['estimated_minutes']!,
          _estimatedMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estimatedMinutesMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('deadline')) {
      context.handle(
        _deadlineMeta,
        deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('proof_text')) {
      context.handle(
        _proofTextMeta,
        proofText.isAcceptableOrUnknown(data['proof_text']!, _proofTextMeta),
      );
    }
    if (data.containsKey('proof_link')) {
      context.handle(
        _proofLinkMeta,
        proofLink.isAcceptableOrUnknown(data['proof_link']!, _proofLinkMeta),
      );
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('overdue_penalty_applied')) {
      context.handle(
        _overduePenaltyAppliedMeta,
        overduePenaltyApplied.isAcceptableOrUnknown(
          data['overdue_penalty_applied']!,
          _overduePenaltyAppliedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      course: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points'],
      )!,
      estimatedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_minutes'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deadline: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deadline'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      proofText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proof_text'],
      )!,
      proofLink: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proof_link'],
      )!,
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      overduePenaltyApplied: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}overdue_penalty_applied'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final String id;
  final String title;
  final String course;
  final String type;
  final String priority;
  final int points;
  final int estimatedMinutes;
  final DateTime createdAt;
  final DateTime? deadline;
  final String note;
  final String proofText;
  final String proofLink;
  final bool done;
  final DateTime? completedAt;
  final bool overduePenaltyApplied;
  const Task({
    required this.id,
    required this.title,
    required this.course,
    required this.type,
    required this.priority,
    required this.points,
    required this.estimatedMinutes,
    required this.createdAt,
    this.deadline,
    required this.note,
    required this.proofText,
    required this.proofLink,
    required this.done,
    this.completedAt,
    required this.overduePenaltyApplied,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['course'] = Variable<String>(course);
    map['type'] = Variable<String>(type);
    map['priority'] = Variable<String>(priority);
    map['points'] = Variable<int>(points);
    map['estimated_minutes'] = Variable<int>(estimatedMinutes);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<DateTime>(deadline);
    }
    map['note'] = Variable<String>(note);
    map['proof_text'] = Variable<String>(proofText);
    map['proof_link'] = Variable<String>(proofLink);
    map['done'] = Variable<bool>(done);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['overdue_penalty_applied'] = Variable<bool>(overduePenaltyApplied);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      course: Value(course),
      type: Value(type),
      priority: Value(priority),
      points: Value(points),
      estimatedMinutes: Value(estimatedMinutes),
      createdAt: Value(createdAt),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      note: Value(note),
      proofText: Value(proofText),
      proofLink: Value(proofLink),
      done: Value(done),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      overduePenaltyApplied: Value(overduePenaltyApplied),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      course: serializer.fromJson<String>(json['course']),
      type: serializer.fromJson<String>(json['type']),
      priority: serializer.fromJson<String>(json['priority']),
      points: serializer.fromJson<int>(json['points']),
      estimatedMinutes: serializer.fromJson<int>(json['estimatedMinutes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deadline: serializer.fromJson<DateTime?>(json['deadline']),
      note: serializer.fromJson<String>(json['note']),
      proofText: serializer.fromJson<String>(json['proofText']),
      proofLink: serializer.fromJson<String>(json['proofLink']),
      done: serializer.fromJson<bool>(json['done']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      overduePenaltyApplied: serializer.fromJson<bool>(
        json['overduePenaltyApplied'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'course': serializer.toJson<String>(course),
      'type': serializer.toJson<String>(type),
      'priority': serializer.toJson<String>(priority),
      'points': serializer.toJson<int>(points),
      'estimatedMinutes': serializer.toJson<int>(estimatedMinutes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deadline': serializer.toJson<DateTime?>(deadline),
      'note': serializer.toJson<String>(note),
      'proofText': serializer.toJson<String>(proofText),
      'proofLink': serializer.toJson<String>(proofLink),
      'done': serializer.toJson<bool>(done),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'overduePenaltyApplied': serializer.toJson<bool>(overduePenaltyApplied),
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? course,
    String? type,
    String? priority,
    int? points,
    int? estimatedMinutes,
    DateTime? createdAt,
    Value<DateTime?> deadline = const Value.absent(),
    String? note,
    String? proofText,
    String? proofLink,
    bool? done,
    Value<DateTime?> completedAt = const Value.absent(),
    bool? overduePenaltyApplied,
  }) => Task(
    id: id ?? this.id,
    title: title ?? this.title,
    course: course ?? this.course,
    type: type ?? this.type,
    priority: priority ?? this.priority,
    points: points ?? this.points,
    estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    createdAt: createdAt ?? this.createdAt,
    deadline: deadline.present ? deadline.value : this.deadline,
    note: note ?? this.note,
    proofText: proofText ?? this.proofText,
    proofLink: proofLink ?? this.proofLink,
    done: done ?? this.done,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    overduePenaltyApplied: overduePenaltyApplied ?? this.overduePenaltyApplied,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      course: data.course.present ? data.course.value : this.course,
      type: data.type.present ? data.type.value : this.type,
      priority: data.priority.present ? data.priority.value : this.priority,
      points: data.points.present ? data.points.value : this.points,
      estimatedMinutes: data.estimatedMinutes.present
          ? data.estimatedMinutes.value
          : this.estimatedMinutes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      note: data.note.present ? data.note.value : this.note,
      proofText: data.proofText.present ? data.proofText.value : this.proofText,
      proofLink: data.proofLink.present ? data.proofLink.value : this.proofLink,
      done: data.done.present ? data.done.value : this.done,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      overduePenaltyApplied: data.overduePenaltyApplied.present
          ? data.overduePenaltyApplied.value
          : this.overduePenaltyApplied,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('course: $course, ')
          ..write('type: $type, ')
          ..write('priority: $priority, ')
          ..write('points: $points, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('deadline: $deadline, ')
          ..write('note: $note, ')
          ..write('proofText: $proofText, ')
          ..write('proofLink: $proofLink, ')
          ..write('done: $done, ')
          ..write('completedAt: $completedAt, ')
          ..write('overduePenaltyApplied: $overduePenaltyApplied')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    course,
    type,
    priority,
    points,
    estimatedMinutes,
    createdAt,
    deadline,
    note,
    proofText,
    proofLink,
    done,
    completedAt,
    overduePenaltyApplied,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.title == this.title &&
          other.course == this.course &&
          other.type == this.type &&
          other.priority == this.priority &&
          other.points == this.points &&
          other.estimatedMinutes == this.estimatedMinutes &&
          other.createdAt == this.createdAt &&
          other.deadline == this.deadline &&
          other.note == this.note &&
          other.proofText == this.proofText &&
          other.proofLink == this.proofLink &&
          other.done == this.done &&
          other.completedAt == this.completedAt &&
          other.overduePenaltyApplied == this.overduePenaltyApplied);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> course;
  final Value<String> type;
  final Value<String> priority;
  final Value<int> points;
  final Value<int> estimatedMinutes;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deadline;
  final Value<String> note;
  final Value<String> proofText;
  final Value<String> proofLink;
  final Value<bool> done;
  final Value<DateTime?> completedAt;
  final Value<bool> overduePenaltyApplied;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.course = const Value.absent(),
    this.type = const Value.absent(),
    this.priority = const Value.absent(),
    this.points = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deadline = const Value.absent(),
    this.note = const Value.absent(),
    this.proofText = const Value.absent(),
    this.proofLink = const Value.absent(),
    this.done = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.overduePenaltyApplied = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String title,
    required String course,
    required String type,
    required String priority,
    required int points,
    required int estimatedMinutes,
    required DateTime createdAt,
    this.deadline = const Value.absent(),
    this.note = const Value.absent(),
    this.proofText = const Value.absent(),
    this.proofLink = const Value.absent(),
    this.done = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.overduePenaltyApplied = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       course = Value(course),
       type = Value(type),
       priority = Value(priority),
       points = Value(points),
       estimatedMinutes = Value(estimatedMinutes),
       createdAt = Value(createdAt);
  static Insertable<Task> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? course,
    Expression<String>? type,
    Expression<String>? priority,
    Expression<int>? points,
    Expression<int>? estimatedMinutes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deadline,
    Expression<String>? note,
    Expression<String>? proofText,
    Expression<String>? proofLink,
    Expression<bool>? done,
    Expression<DateTime>? completedAt,
    Expression<bool>? overduePenaltyApplied,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (course != null) 'course': course,
      if (type != null) 'type': type,
      if (priority != null) 'priority': priority,
      if (points != null) 'points': points,
      if (estimatedMinutes != null) 'estimated_minutes': estimatedMinutes,
      if (createdAt != null) 'created_at': createdAt,
      if (deadline != null) 'deadline': deadline,
      if (note != null) 'note': note,
      if (proofText != null) 'proof_text': proofText,
      if (proofLink != null) 'proof_link': proofLink,
      if (done != null) 'done': done,
      if (completedAt != null) 'completed_at': completedAt,
      if (overduePenaltyApplied != null)
        'overdue_penalty_applied': overduePenaltyApplied,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? course,
    Value<String>? type,
    Value<String>? priority,
    Value<int>? points,
    Value<int>? estimatedMinutes,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deadline,
    Value<String>? note,
    Value<String>? proofText,
    Value<String>? proofLink,
    Value<bool>? done,
    Value<DateTime?>? completedAt,
    Value<bool>? overduePenaltyApplied,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      course: course ?? this.course,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      points: points ?? this.points,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      createdAt: createdAt ?? this.createdAt,
      deadline: deadline ?? this.deadline,
      note: note ?? this.note,
      proofText: proofText ?? this.proofText,
      proofLink: proofLink ?? this.proofLink,
      done: done ?? this.done,
      completedAt: completedAt ?? this.completedAt,
      overduePenaltyApplied:
          overduePenaltyApplied ?? this.overduePenaltyApplied,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (course.present) {
      map['course'] = Variable<String>(course.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (estimatedMinutes.present) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (proofText.present) {
      map['proof_text'] = Variable<String>(proofText.value);
    }
    if (proofLink.present) {
      map['proof_link'] = Variable<String>(proofLink.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (overduePenaltyApplied.present) {
      map['overdue_penalty_applied'] = Variable<bool>(
        overduePenaltyApplied.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('course: $course, ')
          ..write('type: $type, ')
          ..write('priority: $priority, ')
          ..write('points: $points, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('deadline: $deadline, ')
          ..write('note: $note, ')
          ..write('proofText: $proofText, ')
          ..write('proofLink: $proofLink, ')
          ..write('done: $done, ')
          ..write('completedAt: $completedAt, ')
          ..write('overduePenaltyApplied: $overduePenaltyApplied, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FocusSessionRecordsTable extends FocusSessionRecords
    with TableInfo<$FocusSessionRecordsTable, FocusSessionRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusSessionRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courseMeta = const VerificationMeta('course');
  @override
  late final GeneratedColumn<String> course = GeneratedColumn<String>(
    'course',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedMinutesMeta = const VerificationMeta(
    'plannedMinutes',
  );
  @override
  late final GeneratedColumn<int> plannedMinutes = GeneratedColumn<int>(
    'planned_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualMinutesMeta = const VerificationMeta(
    'actualMinutes',
  );
  @override
  late final GeneratedColumn<int> actualMinutes = GeneratedColumn<int>(
    'actual_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _interruptedMeta = const VerificationMeta(
    'interrupted',
  );
  @override
  late final GeneratedColumn<bool> interrupted = GeneratedColumn<bool>(
    'interrupted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("interrupted" IN (0, 1))',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    course,
    mode,
    plannedMinutes,
    actualMinutes,
    completed,
    interrupted,
    startedAt,
    endedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_session_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<FocusSessionRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('course')) {
      context.handle(
        _courseMeta,
        course.isAcceptableOrUnknown(data['course']!, _courseMeta),
      );
    } else if (isInserting) {
      context.missing(_courseMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('planned_minutes')) {
      context.handle(
        _plannedMinutesMeta,
        plannedMinutes.isAcceptableOrUnknown(
          data['planned_minutes']!,
          _plannedMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedMinutesMeta);
    }
    if (data.containsKey('actual_minutes')) {
      context.handle(
        _actualMinutesMeta,
        actualMinutes.isAcceptableOrUnknown(
          data['actual_minutes']!,
          _actualMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actualMinutesMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    } else if (isInserting) {
      context.missing(_completedMeta);
    }
    if (data.containsKey('interrupted')) {
      context.handle(
        _interruptedMeta,
        interrupted.isAcceptableOrUnknown(
          data['interrupted']!,
          _interruptedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_interruptedMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusSessionRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusSessionRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      course: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      plannedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_minutes'],
      )!,
      actualMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_minutes'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      interrupted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}interrupted'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      )!,
    );
  }

  @override
  $FocusSessionRecordsTable createAlias(String alias) {
    return $FocusSessionRecordsTable(attachedDatabase, alias);
  }
}

class FocusSessionRecord extends DataClass
    implements Insertable<FocusSessionRecord> {
  final String id;
  final String course;
  final String mode;
  final int plannedMinutes;
  final int actualMinutes;
  final bool completed;
  final bool interrupted;
  final DateTime startedAt;
  final DateTime endedAt;
  const FocusSessionRecord({
    required this.id,
    required this.course,
    required this.mode,
    required this.plannedMinutes,
    required this.actualMinutes,
    required this.completed,
    required this.interrupted,
    required this.startedAt,
    required this.endedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['course'] = Variable<String>(course);
    map['mode'] = Variable<String>(mode);
    map['planned_minutes'] = Variable<int>(plannedMinutes);
    map['actual_minutes'] = Variable<int>(actualMinutes);
    map['completed'] = Variable<bool>(completed);
    map['interrupted'] = Variable<bool>(interrupted);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    return map;
  }

  FocusSessionRecordsCompanion toCompanion(bool nullToAbsent) {
    return FocusSessionRecordsCompanion(
      id: Value(id),
      course: Value(course),
      mode: Value(mode),
      plannedMinutes: Value(plannedMinutes),
      actualMinutes: Value(actualMinutes),
      completed: Value(completed),
      interrupted: Value(interrupted),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
    );
  }

  factory FocusSessionRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusSessionRecord(
      id: serializer.fromJson<String>(json['id']),
      course: serializer.fromJson<String>(json['course']),
      mode: serializer.fromJson<String>(json['mode']),
      plannedMinutes: serializer.fromJson<int>(json['plannedMinutes']),
      actualMinutes: serializer.fromJson<int>(json['actualMinutes']),
      completed: serializer.fromJson<bool>(json['completed']),
      interrupted: serializer.fromJson<bool>(json['interrupted']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime>(json['endedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'course': serializer.toJson<String>(course),
      'mode': serializer.toJson<String>(mode),
      'plannedMinutes': serializer.toJson<int>(plannedMinutes),
      'actualMinutes': serializer.toJson<int>(actualMinutes),
      'completed': serializer.toJson<bool>(completed),
      'interrupted': serializer.toJson<bool>(interrupted),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime>(endedAt),
    };
  }

  FocusSessionRecord copyWith({
    String? id,
    String? course,
    String? mode,
    int? plannedMinutes,
    int? actualMinutes,
    bool? completed,
    bool? interrupted,
    DateTime? startedAt,
    DateTime? endedAt,
  }) => FocusSessionRecord(
    id: id ?? this.id,
    course: course ?? this.course,
    mode: mode ?? this.mode,
    plannedMinutes: plannedMinutes ?? this.plannedMinutes,
    actualMinutes: actualMinutes ?? this.actualMinutes,
    completed: completed ?? this.completed,
    interrupted: interrupted ?? this.interrupted,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
  );
  FocusSessionRecord copyWithCompanion(FocusSessionRecordsCompanion data) {
    return FocusSessionRecord(
      id: data.id.present ? data.id.value : this.id,
      course: data.course.present ? data.course.value : this.course,
      mode: data.mode.present ? data.mode.value : this.mode,
      plannedMinutes: data.plannedMinutes.present
          ? data.plannedMinutes.value
          : this.plannedMinutes,
      actualMinutes: data.actualMinutes.present
          ? data.actualMinutes.value
          : this.actualMinutes,
      completed: data.completed.present ? data.completed.value : this.completed,
      interrupted: data.interrupted.present
          ? data.interrupted.value
          : this.interrupted,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionRecord(')
          ..write('id: $id, ')
          ..write('course: $course, ')
          ..write('mode: $mode, ')
          ..write('plannedMinutes: $plannedMinutes, ')
          ..write('actualMinutes: $actualMinutes, ')
          ..write('completed: $completed, ')
          ..write('interrupted: $interrupted, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    course,
    mode,
    plannedMinutes,
    actualMinutes,
    completed,
    interrupted,
    startedAt,
    endedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusSessionRecord &&
          other.id == this.id &&
          other.course == this.course &&
          other.mode == this.mode &&
          other.plannedMinutes == this.plannedMinutes &&
          other.actualMinutes == this.actualMinutes &&
          other.completed == this.completed &&
          other.interrupted == this.interrupted &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt);
}

class FocusSessionRecordsCompanion extends UpdateCompanion<FocusSessionRecord> {
  final Value<String> id;
  final Value<String> course;
  final Value<String> mode;
  final Value<int> plannedMinutes;
  final Value<int> actualMinutes;
  final Value<bool> completed;
  final Value<bool> interrupted;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<int> rowid;
  const FocusSessionRecordsCompanion({
    this.id = const Value.absent(),
    this.course = const Value.absent(),
    this.mode = const Value.absent(),
    this.plannedMinutes = const Value.absent(),
    this.actualMinutes = const Value.absent(),
    this.completed = const Value.absent(),
    this.interrupted = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FocusSessionRecordsCompanion.insert({
    required String id,
    required String course,
    required String mode,
    required int plannedMinutes,
    required int actualMinutes,
    required bool completed,
    required bool interrupted,
    required DateTime startedAt,
    required DateTime endedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       course = Value(course),
       mode = Value(mode),
       plannedMinutes = Value(plannedMinutes),
       actualMinutes = Value(actualMinutes),
       completed = Value(completed),
       interrupted = Value(interrupted),
       startedAt = Value(startedAt),
       endedAt = Value(endedAt);
  static Insertable<FocusSessionRecord> custom({
    Expression<String>? id,
    Expression<String>? course,
    Expression<String>? mode,
    Expression<int>? plannedMinutes,
    Expression<int>? actualMinutes,
    Expression<bool>? completed,
    Expression<bool>? interrupted,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (course != null) 'course': course,
      if (mode != null) 'mode': mode,
      if (plannedMinutes != null) 'planned_minutes': plannedMinutes,
      if (actualMinutes != null) 'actual_minutes': actualMinutes,
      if (completed != null) 'completed': completed,
      if (interrupted != null) 'interrupted': interrupted,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FocusSessionRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? course,
    Value<String>? mode,
    Value<int>? plannedMinutes,
    Value<int>? actualMinutes,
    Value<bool>? completed,
    Value<bool>? interrupted,
    Value<DateTime>? startedAt,
    Value<DateTime>? endedAt,
    Value<int>? rowid,
  }) {
    return FocusSessionRecordsCompanion(
      id: id ?? this.id,
      course: course ?? this.course,
      mode: mode ?? this.mode,
      plannedMinutes: plannedMinutes ?? this.plannedMinutes,
      actualMinutes: actualMinutes ?? this.actualMinutes,
      completed: completed ?? this.completed,
      interrupted: interrupted ?? this.interrupted,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (course.present) {
      map['course'] = Variable<String>(course.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (plannedMinutes.present) {
      map['planned_minutes'] = Variable<int>(plannedMinutes.value);
    }
    if (actualMinutes.present) {
      map['actual_minutes'] = Variable<int>(actualMinutes.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (interrupted.present) {
      map['interrupted'] = Variable<bool>(interrupted.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionRecordsCompanion(')
          ..write('id: $id, ')
          ..write('course: $course, ')
          ..write('mode: $mode, ')
          ..write('plannedMinutes: $plannedMinutes, ')
          ..write('actualMinutes: $actualMinutes, ')
          ..write('completed: $completed, ')
          ..write('interrupted: $interrupted, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyStatRecordsTable extends DailyStatRecords
    with TableInfo<$DailyStatRecordsTable, DailyStatRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyStatRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateKeyMeta = const VerificationMeta(
    'dateKey',
  );
  @override
  late final GeneratedColumn<String> dateKey = GeneratedColumn<String>(
    'date_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedTasksMeta = const VerificationMeta(
    'completedTasks',
  );
  @override
  late final GeneratedColumn<int> completedTasks = GeneratedColumn<int>(
    'completed_tasks',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalTasksMeta = const VerificationMeta(
    'totalTasks',
  );
  @override
  late final GeneratedColumn<int> totalTasks = GeneratedColumn<int>(
    'total_tasks',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _focusMinutesMeta = const VerificationMeta(
    'focusMinutes',
  );
  @override
  late final GeneratedColumn<int> focusMinutes = GeneratedColumn<int>(
    'focus_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _disciplineScoreMeta = const VerificationMeta(
    'disciplineScore',
  );
  @override
  late final GeneratedColumn<int> disciplineScore = GeneratedColumn<int>(
    'discipline_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _successMeta = const VerificationMeta(
    'success',
  );
  @override
  late final GeneratedColumn<bool> success = GeneratedColumn<bool>(
    'success',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("success" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    dateKey,
    completedTasks,
    totalTasks,
    focusMinutes,
    disciplineScore,
    success,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_stat_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyStatRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date_key')) {
      context.handle(
        _dateKeyMeta,
        dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('completed_tasks')) {
      context.handle(
        _completedTasksMeta,
        completedTasks.isAcceptableOrUnknown(
          data['completed_tasks']!,
          _completedTasksMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedTasksMeta);
    }
    if (data.containsKey('total_tasks')) {
      context.handle(
        _totalTasksMeta,
        totalTasks.isAcceptableOrUnknown(data['total_tasks']!, _totalTasksMeta),
      );
    } else if (isInserting) {
      context.missing(_totalTasksMeta);
    }
    if (data.containsKey('focus_minutes')) {
      context.handle(
        _focusMinutesMeta,
        focusMinutes.isAcceptableOrUnknown(
          data['focus_minutes']!,
          _focusMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_focusMinutesMeta);
    }
    if (data.containsKey('discipline_score')) {
      context.handle(
        _disciplineScoreMeta,
        disciplineScore.isAcceptableOrUnknown(
          data['discipline_score']!,
          _disciplineScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_disciplineScoreMeta);
    }
    if (data.containsKey('success')) {
      context.handle(
        _successMeta,
        success.isAcceptableOrUnknown(data['success']!, _successMeta),
      );
    } else if (isInserting) {
      context.missing(_successMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dateKey};
  @override
  DailyStatRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyStatRecord(
      dateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_key'],
      )!,
      completedTasks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_tasks'],
      )!,
      totalTasks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_tasks'],
      )!,
      focusMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}focus_minutes'],
      )!,
      disciplineScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discipline_score'],
      )!,
      success: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}success'],
      )!,
    );
  }

  @override
  $DailyStatRecordsTable createAlias(String alias) {
    return $DailyStatRecordsTable(attachedDatabase, alias);
  }
}

class DailyStatRecord extends DataClass implements Insertable<DailyStatRecord> {
  final String dateKey;
  final int completedTasks;
  final int totalTasks;
  final int focusMinutes;
  final int disciplineScore;
  final bool success;
  const DailyStatRecord({
    required this.dateKey,
    required this.completedTasks,
    required this.totalTasks,
    required this.focusMinutes,
    required this.disciplineScore,
    required this.success,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date_key'] = Variable<String>(dateKey);
    map['completed_tasks'] = Variable<int>(completedTasks);
    map['total_tasks'] = Variable<int>(totalTasks);
    map['focus_minutes'] = Variable<int>(focusMinutes);
    map['discipline_score'] = Variable<int>(disciplineScore);
    map['success'] = Variable<bool>(success);
    return map;
  }

  DailyStatRecordsCompanion toCompanion(bool nullToAbsent) {
    return DailyStatRecordsCompanion(
      dateKey: Value(dateKey),
      completedTasks: Value(completedTasks),
      totalTasks: Value(totalTasks),
      focusMinutes: Value(focusMinutes),
      disciplineScore: Value(disciplineScore),
      success: Value(success),
    );
  }

  factory DailyStatRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyStatRecord(
      dateKey: serializer.fromJson<String>(json['dateKey']),
      completedTasks: serializer.fromJson<int>(json['completedTasks']),
      totalTasks: serializer.fromJson<int>(json['totalTasks']),
      focusMinutes: serializer.fromJson<int>(json['focusMinutes']),
      disciplineScore: serializer.fromJson<int>(json['disciplineScore']),
      success: serializer.fromJson<bool>(json['success']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dateKey': serializer.toJson<String>(dateKey),
      'completedTasks': serializer.toJson<int>(completedTasks),
      'totalTasks': serializer.toJson<int>(totalTasks),
      'focusMinutes': serializer.toJson<int>(focusMinutes),
      'disciplineScore': serializer.toJson<int>(disciplineScore),
      'success': serializer.toJson<bool>(success),
    };
  }

  DailyStatRecord copyWith({
    String? dateKey,
    int? completedTasks,
    int? totalTasks,
    int? focusMinutes,
    int? disciplineScore,
    bool? success,
  }) => DailyStatRecord(
    dateKey: dateKey ?? this.dateKey,
    completedTasks: completedTasks ?? this.completedTasks,
    totalTasks: totalTasks ?? this.totalTasks,
    focusMinutes: focusMinutes ?? this.focusMinutes,
    disciplineScore: disciplineScore ?? this.disciplineScore,
    success: success ?? this.success,
  );
  DailyStatRecord copyWithCompanion(DailyStatRecordsCompanion data) {
    return DailyStatRecord(
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      completedTasks: data.completedTasks.present
          ? data.completedTasks.value
          : this.completedTasks,
      totalTasks: data.totalTasks.present
          ? data.totalTasks.value
          : this.totalTasks,
      focusMinutes: data.focusMinutes.present
          ? data.focusMinutes.value
          : this.focusMinutes,
      disciplineScore: data.disciplineScore.present
          ? data.disciplineScore.value
          : this.disciplineScore,
      success: data.success.present ? data.success.value : this.success,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyStatRecord(')
          ..write('dateKey: $dateKey, ')
          ..write('completedTasks: $completedTasks, ')
          ..write('totalTasks: $totalTasks, ')
          ..write('focusMinutes: $focusMinutes, ')
          ..write('disciplineScore: $disciplineScore, ')
          ..write('success: $success')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    dateKey,
    completedTasks,
    totalTasks,
    focusMinutes,
    disciplineScore,
    success,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyStatRecord &&
          other.dateKey == this.dateKey &&
          other.completedTasks == this.completedTasks &&
          other.totalTasks == this.totalTasks &&
          other.focusMinutes == this.focusMinutes &&
          other.disciplineScore == this.disciplineScore &&
          other.success == this.success);
}

class DailyStatRecordsCompanion extends UpdateCompanion<DailyStatRecord> {
  final Value<String> dateKey;
  final Value<int> completedTasks;
  final Value<int> totalTasks;
  final Value<int> focusMinutes;
  final Value<int> disciplineScore;
  final Value<bool> success;
  final Value<int> rowid;
  const DailyStatRecordsCompanion({
    this.dateKey = const Value.absent(),
    this.completedTasks = const Value.absent(),
    this.totalTasks = const Value.absent(),
    this.focusMinutes = const Value.absent(),
    this.disciplineScore = const Value.absent(),
    this.success = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyStatRecordsCompanion.insert({
    required String dateKey,
    required int completedTasks,
    required int totalTasks,
    required int focusMinutes,
    required int disciplineScore,
    required bool success,
    this.rowid = const Value.absent(),
  }) : dateKey = Value(dateKey),
       completedTasks = Value(completedTasks),
       totalTasks = Value(totalTasks),
       focusMinutes = Value(focusMinutes),
       disciplineScore = Value(disciplineScore),
       success = Value(success);
  static Insertable<DailyStatRecord> custom({
    Expression<String>? dateKey,
    Expression<int>? completedTasks,
    Expression<int>? totalTasks,
    Expression<int>? focusMinutes,
    Expression<int>? disciplineScore,
    Expression<bool>? success,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dateKey != null) 'date_key': dateKey,
      if (completedTasks != null) 'completed_tasks': completedTasks,
      if (totalTasks != null) 'total_tasks': totalTasks,
      if (focusMinutes != null) 'focus_minutes': focusMinutes,
      if (disciplineScore != null) 'discipline_score': disciplineScore,
      if (success != null) 'success': success,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyStatRecordsCompanion copyWith({
    Value<String>? dateKey,
    Value<int>? completedTasks,
    Value<int>? totalTasks,
    Value<int>? focusMinutes,
    Value<int>? disciplineScore,
    Value<bool>? success,
    Value<int>? rowid,
  }) {
    return DailyStatRecordsCompanion(
      dateKey: dateKey ?? this.dateKey,
      completedTasks: completedTasks ?? this.completedTasks,
      totalTasks: totalTasks ?? this.totalTasks,
      focusMinutes: focusMinutes ?? this.focusMinutes,
      disciplineScore: disciplineScore ?? this.disciplineScore,
      success: success ?? this.success,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dateKey.present) {
      map['date_key'] = Variable<String>(dateKey.value);
    }
    if (completedTasks.present) {
      map['completed_tasks'] = Variable<int>(completedTasks.value);
    }
    if (totalTasks.present) {
      map['total_tasks'] = Variable<int>(totalTasks.value);
    }
    if (focusMinutes.present) {
      map['focus_minutes'] = Variable<int>(focusMinutes.value);
    }
    if (disciplineScore.present) {
      map['discipline_score'] = Variable<int>(disciplineScore.value);
    }
    if (success.present) {
      map['success'] = Variable<bool>(success.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyStatRecordsCompanion(')
          ..write('dateKey: $dateKey, ')
          ..write('completedTasks: $completedTasks, ')
          ..write('totalTasks: $totalTasks, ')
          ..write('focusMinutes: $focusMinutes, ')
          ..write('disciplineScore: $disciplineScore, ')
          ..write('success: $success, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppMetaEntriesTable appMetaEntries = $AppMetaEntriesTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $FocusSessionRecordsTable focusSessionRecords =
      $FocusSessionRecordsTable(this);
  late final $DailyStatRecordsTable dailyStatRecords = $DailyStatRecordsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appMetaEntries,
    tasks,
    focusSessionRecords,
    dailyStatRecords,
  ];
}

typedef $$AppMetaEntriesTableCreateCompanionBuilder =
    AppMetaEntriesCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppMetaEntriesTableUpdateCompanionBuilder =
    AppMetaEntriesCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppMetaEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $AppMetaEntriesTable> {
  $$AppMetaEntriesTableFilterComposer({
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

class $$AppMetaEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AppMetaEntriesTable> {
  $$AppMetaEntriesTableOrderingComposer({
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

class $$AppMetaEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppMetaEntriesTable> {
  $$AppMetaEntriesTableAnnotationComposer({
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

class $$AppMetaEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppMetaEntriesTable,
          AppMetaEntry,
          $$AppMetaEntriesTableFilterComposer,
          $$AppMetaEntriesTableOrderingComposer,
          $$AppMetaEntriesTableAnnotationComposer,
          $$AppMetaEntriesTableCreateCompanionBuilder,
          $$AppMetaEntriesTableUpdateCompanionBuilder,
          (
            AppMetaEntry,
            BaseReferences<_$AppDatabase, $AppMetaEntriesTable, AppMetaEntry>,
          ),
          AppMetaEntry,
          PrefetchHooks Function()
        > {
  $$AppMetaEntriesTableTableManager(
    _$AppDatabase db,
    $AppMetaEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppMetaEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppMetaEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppMetaEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) =>
                  AppMetaEntriesCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppMetaEntriesCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppMetaEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppMetaEntriesTable,
      AppMetaEntry,
      $$AppMetaEntriesTableFilterComposer,
      $$AppMetaEntriesTableOrderingComposer,
      $$AppMetaEntriesTableAnnotationComposer,
      $$AppMetaEntriesTableCreateCompanionBuilder,
      $$AppMetaEntriesTableUpdateCompanionBuilder,
      (
        AppMetaEntry,
        BaseReferences<_$AppDatabase, $AppMetaEntriesTable, AppMetaEntry>,
      ),
      AppMetaEntry,
      PrefetchHooks Function()
    >;
typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      required String id,
      required String title,
      required String course,
      required String type,
      required String priority,
      required int points,
      required int estimatedMinutes,
      required DateTime createdAt,
      Value<DateTime?> deadline,
      Value<String> note,
      Value<String> proofText,
      Value<String> proofLink,
      Value<bool> done,
      Value<DateTime?> completedAt,
      Value<bool> overduePenaltyApplied,
      Value<int> rowid,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> course,
      Value<String> type,
      Value<String> priority,
      Value<int> points,
      Value<int> estimatedMinutes,
      Value<DateTime> createdAt,
      Value<DateTime?> deadline,
      Value<String> note,
      Value<String> proofText,
      Value<String> proofLink,
      Value<bool> done,
      Value<DateTime?> completedAt,
      Value<bool> overduePenaltyApplied,
      Value<int> rowid,
    });

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get course => $composableBuilder(
    column: $table.course,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proofText => $composableBuilder(
    column: $table.proofText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proofLink => $composableBuilder(
    column: $table.proofLink,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get overduePenaltyApplied => $composableBuilder(
    column: $table.overduePenaltyApplied,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get course => $composableBuilder(
    column: $table.course,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proofText => $composableBuilder(
    column: $table.proofText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proofLink => $composableBuilder(
    column: $table.proofLink,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get overduePenaltyApplied => $composableBuilder(
    column: $table.overduePenaltyApplied,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get course =>
      $composableBuilder(column: $table.course, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get proofText =>
      $composableBuilder(column: $table.proofText, builder: (column) => column);

  GeneratedColumn<String> get proofLink =>
      $composableBuilder(column: $table.proofLink, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get overduePenaltyApplied => $composableBuilder(
    column: $table.overduePenaltyApplied,
    builder: (column) => column,
  );
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
          Task,
          PrefetchHooks Function()
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> course = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<int> estimatedMinutes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deadline = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String> proofText = const Value.absent(),
                Value<String> proofLink = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<bool> overduePenaltyApplied = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                title: title,
                course: course,
                type: type,
                priority: priority,
                points: points,
                estimatedMinutes: estimatedMinutes,
                createdAt: createdAt,
                deadline: deadline,
                note: note,
                proofText: proofText,
                proofLink: proofLink,
                done: done,
                completedAt: completedAt,
                overduePenaltyApplied: overduePenaltyApplied,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String course,
                required String type,
                required String priority,
                required int points,
                required int estimatedMinutes,
                required DateTime createdAt,
                Value<DateTime?> deadline = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String> proofText = const Value.absent(),
                Value<String> proofLink = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<bool> overduePenaltyApplied = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                title: title,
                course: course,
                type: type,
                priority: priority,
                points: points,
                estimatedMinutes: estimatedMinutes,
                createdAt: createdAt,
                deadline: deadline,
                note: note,
                proofText: proofText,
                proofLink: proofLink,
                done: done,
                completedAt: completedAt,
                overduePenaltyApplied: overduePenaltyApplied,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
      Task,
      PrefetchHooks Function()
    >;
typedef $$FocusSessionRecordsTableCreateCompanionBuilder =
    FocusSessionRecordsCompanion Function({
      required String id,
      required String course,
      required String mode,
      required int plannedMinutes,
      required int actualMinutes,
      required bool completed,
      required bool interrupted,
      required DateTime startedAt,
      required DateTime endedAt,
      Value<int> rowid,
    });
typedef $$FocusSessionRecordsTableUpdateCompanionBuilder =
    FocusSessionRecordsCompanion Function({
      Value<String> id,
      Value<String> course,
      Value<String> mode,
      Value<int> plannedMinutes,
      Value<int> actualMinutes,
      Value<bool> completed,
      Value<bool> interrupted,
      Value<DateTime> startedAt,
      Value<DateTime> endedAt,
      Value<int> rowid,
    });

class $$FocusSessionRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $FocusSessionRecordsTable> {
  $$FocusSessionRecordsTableFilterComposer({
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

  ColumnFilters<String> get course => $composableBuilder(
    column: $table.course,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedMinutes => $composableBuilder(
    column: $table.plannedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualMinutes => $composableBuilder(
    column: $table.actualMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get interrupted => $composableBuilder(
    column: $table.interrupted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FocusSessionRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusSessionRecordsTable> {
  $$FocusSessionRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get course => $composableBuilder(
    column: $table.course,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedMinutes => $composableBuilder(
    column: $table.plannedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualMinutes => $composableBuilder(
    column: $table.actualMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get interrupted => $composableBuilder(
    column: $table.interrupted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FocusSessionRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusSessionRecordsTable> {
  $$FocusSessionRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get course =>
      $composableBuilder(column: $table.course, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get plannedMinutes => $composableBuilder(
    column: $table.plannedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualMinutes => $composableBuilder(
    column: $table.actualMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<bool> get interrupted => $composableBuilder(
    column: $table.interrupted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);
}

class $$FocusSessionRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocusSessionRecordsTable,
          FocusSessionRecord,
          $$FocusSessionRecordsTableFilterComposer,
          $$FocusSessionRecordsTableOrderingComposer,
          $$FocusSessionRecordsTableAnnotationComposer,
          $$FocusSessionRecordsTableCreateCompanionBuilder,
          $$FocusSessionRecordsTableUpdateCompanionBuilder,
          (
            FocusSessionRecord,
            BaseReferences<
              _$AppDatabase,
              $FocusSessionRecordsTable,
              FocusSessionRecord
            >,
          ),
          FocusSessionRecord,
          PrefetchHooks Function()
        > {
  $$FocusSessionRecordsTableTableManager(
    _$AppDatabase db,
    $FocusSessionRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusSessionRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusSessionRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FocusSessionRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> course = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<int> plannedMinutes = const Value.absent(),
                Value<int> actualMinutes = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<bool> interrupted = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> endedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocusSessionRecordsCompanion(
                id: id,
                course: course,
                mode: mode,
                plannedMinutes: plannedMinutes,
                actualMinutes: actualMinutes,
                completed: completed,
                interrupted: interrupted,
                startedAt: startedAt,
                endedAt: endedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String course,
                required String mode,
                required int plannedMinutes,
                required int actualMinutes,
                required bool completed,
                required bool interrupted,
                required DateTime startedAt,
                required DateTime endedAt,
                Value<int> rowid = const Value.absent(),
              }) => FocusSessionRecordsCompanion.insert(
                id: id,
                course: course,
                mode: mode,
                plannedMinutes: plannedMinutes,
                actualMinutes: actualMinutes,
                completed: completed,
                interrupted: interrupted,
                startedAt: startedAt,
                endedAt: endedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FocusSessionRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocusSessionRecordsTable,
      FocusSessionRecord,
      $$FocusSessionRecordsTableFilterComposer,
      $$FocusSessionRecordsTableOrderingComposer,
      $$FocusSessionRecordsTableAnnotationComposer,
      $$FocusSessionRecordsTableCreateCompanionBuilder,
      $$FocusSessionRecordsTableUpdateCompanionBuilder,
      (
        FocusSessionRecord,
        BaseReferences<
          _$AppDatabase,
          $FocusSessionRecordsTable,
          FocusSessionRecord
        >,
      ),
      FocusSessionRecord,
      PrefetchHooks Function()
    >;
typedef $$DailyStatRecordsTableCreateCompanionBuilder =
    DailyStatRecordsCompanion Function({
      required String dateKey,
      required int completedTasks,
      required int totalTasks,
      required int focusMinutes,
      required int disciplineScore,
      required bool success,
      Value<int> rowid,
    });
typedef $$DailyStatRecordsTableUpdateCompanionBuilder =
    DailyStatRecordsCompanion Function({
      Value<String> dateKey,
      Value<int> completedTasks,
      Value<int> totalTasks,
      Value<int> focusMinutes,
      Value<int> disciplineScore,
      Value<bool> success,
      Value<int> rowid,
    });

class $$DailyStatRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyStatRecordsTable> {
  $$DailyStatRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedTasks => $composableBuilder(
    column: $table.completedTasks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalTasks => $composableBuilder(
    column: $table.totalTasks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get focusMinutes => $composableBuilder(
    column: $table.focusMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get disciplineScore => $composableBuilder(
    column: $table.disciplineScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get success => $composableBuilder(
    column: $table.success,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyStatRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyStatRecordsTable> {
  $$DailyStatRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedTasks => $composableBuilder(
    column: $table.completedTasks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalTasks => $composableBuilder(
    column: $table.totalTasks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get focusMinutes => $composableBuilder(
    column: $table.focusMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get disciplineScore => $composableBuilder(
    column: $table.disciplineScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get success => $composableBuilder(
    column: $table.success,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyStatRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyStatRecordsTable> {
  $$DailyStatRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<int> get completedTasks => $composableBuilder(
    column: $table.completedTasks,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalTasks => $composableBuilder(
    column: $table.totalTasks,
    builder: (column) => column,
  );

  GeneratedColumn<int> get focusMinutes => $composableBuilder(
    column: $table.focusMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get disciplineScore => $composableBuilder(
    column: $table.disciplineScore,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get success =>
      $composableBuilder(column: $table.success, builder: (column) => column);
}

class $$DailyStatRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyStatRecordsTable,
          DailyStatRecord,
          $$DailyStatRecordsTableFilterComposer,
          $$DailyStatRecordsTableOrderingComposer,
          $$DailyStatRecordsTableAnnotationComposer,
          $$DailyStatRecordsTableCreateCompanionBuilder,
          $$DailyStatRecordsTableUpdateCompanionBuilder,
          (
            DailyStatRecord,
            BaseReferences<
              _$AppDatabase,
              $DailyStatRecordsTable,
              DailyStatRecord
            >,
          ),
          DailyStatRecord,
          PrefetchHooks Function()
        > {
  $$DailyStatRecordsTableTableManager(
    _$AppDatabase db,
    $DailyStatRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyStatRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyStatRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyStatRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> dateKey = const Value.absent(),
                Value<int> completedTasks = const Value.absent(),
                Value<int> totalTasks = const Value.absent(),
                Value<int> focusMinutes = const Value.absent(),
                Value<int> disciplineScore = const Value.absent(),
                Value<bool> success = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyStatRecordsCompanion(
                dateKey: dateKey,
                completedTasks: completedTasks,
                totalTasks: totalTasks,
                focusMinutes: focusMinutes,
                disciplineScore: disciplineScore,
                success: success,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String dateKey,
                required int completedTasks,
                required int totalTasks,
                required int focusMinutes,
                required int disciplineScore,
                required bool success,
                Value<int> rowid = const Value.absent(),
              }) => DailyStatRecordsCompanion.insert(
                dateKey: dateKey,
                completedTasks: completedTasks,
                totalTasks: totalTasks,
                focusMinutes: focusMinutes,
                disciplineScore: disciplineScore,
                success: success,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyStatRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyStatRecordsTable,
      DailyStatRecord,
      $$DailyStatRecordsTableFilterComposer,
      $$DailyStatRecordsTableOrderingComposer,
      $$DailyStatRecordsTableAnnotationComposer,
      $$DailyStatRecordsTableCreateCompanionBuilder,
      $$DailyStatRecordsTableUpdateCompanionBuilder,
      (
        DailyStatRecord,
        BaseReferences<_$AppDatabase, $DailyStatRecordsTable, DailyStatRecord>,
      ),
      DailyStatRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppMetaEntriesTableTableManager get appMetaEntries =>
      $$AppMetaEntriesTableTableManager(_db, _db.appMetaEntries);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$FocusSessionRecordsTableTableManager get focusSessionRecords =>
      $$FocusSessionRecordsTableTableManager(_db, _db.focusSessionRecords);
  $$DailyStatRecordsTableTableManager get dailyStatRecords =>
      $$DailyStatRecordsTableTableManager(_db, _db.dailyStatRecords);
}
