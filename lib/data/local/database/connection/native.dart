import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

QueryExecutor openStudyDatabase({bool inMemory = false}) {
  if (inMemory) {
    return NativeDatabase.memory();
  }

  return LazyDatabase(() async {
    final directory = await getApplicationSupportDirectory();
    final file = File(
      p.join(directory.path, 'college_study_supervisor.sqlite'),
    );
    return NativeDatabase.createInBackground(file);
  });
}
