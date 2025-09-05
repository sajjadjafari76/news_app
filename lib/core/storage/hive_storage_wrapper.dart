import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:interview/feature/news/domain/entities/news_entities.dart';

import 'i_storage.dart';

class HiveStorageWrapper<B> implements IStorage {
  @override
  read(String key) {
    final box = Hive.box('newsBox');
    var cities = box.get(key, defaultValue: <B>[]);
    return (cities as List).cast<B>();
  }

  @override
  Future<void> remove(String key) async {
    final box = Hive.box('newsBox');
    await box.put(key, "");
  }

  @override
  Future<void> write(String key, String value) async {
    final box = Hive.box('newsBox');
    await box.put(key, value);
  }
}
