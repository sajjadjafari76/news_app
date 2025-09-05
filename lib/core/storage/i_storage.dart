abstract class IStorage<B> {
  Future<void> write(String key, String value);
  dynamic read(String key);
  Future<void> remove(String key);
}