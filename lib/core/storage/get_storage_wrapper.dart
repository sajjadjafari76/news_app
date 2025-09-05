import 'package:get_storage/get_storage.dart';

import 'i_storage.dart';

class GetStorageWrapper implements IStorage {
  final _storage = GetStorage();

  @override
  Future<void> write(String key, String value) async {
    await _storage.write(key, value);
  }

  @override
  dynamic read(String key) => _storage.read(key);

  @override
  Future<void> remove(String key) async {
    await _storage.remove(key);
  }
}
