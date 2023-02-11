abstract class ICacheManager {
  Future<bool> writeCache(String key, String model, Duration time);
  Future<String?> readCache(String key);
  Future removeCache(String key);
}
