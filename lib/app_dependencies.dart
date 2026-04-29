import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_storage_factory.dart';
import 'data/local/app_storage.dart';

final appStorageFactoryProvider = Provider<AppStorageFactory>(
  (ref) => const LocalStorageFactory(),
);

final appStorageProvider = Provider<AppStorage>((ref) {
  final storage = ref.watch(appStorageFactoryProvider).create();
  ref.onDispose(() => unawaited(storage.close()));
  return storage;
});
