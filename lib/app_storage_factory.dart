import 'data/local/app_storage.dart';

abstract class AppStorageFactory {
  const AppStorageFactory();

  AppStorage create();
}

class LocalStorageFactory extends AppStorageFactory {
  const LocalStorageFactory();

  @override
  AppStorage create() => AppStorage.local();
}

class InMemoryStorageFactory extends AppStorageFactory {
  const InMemoryStorageFactory();

  @override
  AppStorage create() => AppStorage.memory();
}
