import 'package:flutter_billing_qrcode_test/caches/cache_manager_interface.dart';
import 'package:flutter_billing_qrcode_test/caches/cache_model.dart';
import 'package:flutter_billing_qrcode_test/caches/file_manager.dart';

class FileCacheManager implements ICacheManager {
  final FileManager _fileManager = FileManager.instance;

  @override
  Future<String?> readCache(String key) {
    return _fileManager.readItem(key);
  }

  @override
  Future removeCache(String key) async {
    await _fileManager.removeItem(key);
  }

  @override
  Future<bool> writeCache(String key, String model, Duration time) async {
    final cacheModel = CacheModel(
      time: DateTime.now().add(time),
      model: model,
    );
    await _fileManager.writeItem(
      key,
      cacheModel,
    );
    return true;
  }
}
