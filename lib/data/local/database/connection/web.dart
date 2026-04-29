// ignore_for_file: deprecated_member_use

import 'package:drift/drift.dart';
import 'package:drift/web.dart';

QueryExecutor openStudyDatabase({bool inMemory = false}) {
  final name = inMemory
      ? 'college_study_supervisor_test'
      : 'college_study_supervisor';
  return WebDatabase(name);
}
