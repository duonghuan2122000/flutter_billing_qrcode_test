import 'dart:convert';
import 'dart:io';

import 'package:flutter_billing_qrcode_test/caches/cache_model.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  static final FileManager _instance = FileManager._init();

  FileManager._init();

  static FileManager get instance => _instance;

  final String fileName = "flutter_billing_qrcode_test.json";

  Future<Directory> documentsPath() async {
    String tempPath = (await getApplicationDocumentsDirectory()).path;
    return Directory(tempPath).create();
  }

  Future<String> filePath() async {
    final path = (await documentsPath()).path;
    return "$path/$fileName";
  }

  Future<File> getFile() async {
    File fileTemp = File(await filePath());
    return fileTemp;
  }

  Future<Map<String, dynamic>?> readAllData() async {
    try {
      File fileTemp = await getFile();
      final data = await fileTemp.readAsString();
      final jsonData = jsonDecode(data);
      return jsonData;
    } catch (e) {
      return null;
    }
  }

  Future<File> writeItem(String key, CacheModel model) async {
    final Map<String, dynamic> data = {key: model.toJson()};
    final oldData = await readAllData();
    data.addAll(oldData ?? {});
    var newLocalData = jsonEncode(data);
    File fileTemp = await getFile();
    return await fileTemp.writeAsString(
      newLocalData,
      flush: true,
      mode: FileMode.write,
    );
  }

  Future<String?> readItem(String key) async {
    Map<String, dynamic>? data = await readAllData();
    if (data == null || data[key] == null) {
      return null;
    }

    final model = data[key];
    final item = CacheModel.fromJson(model);
    if (!DateTime.now().isBefore(item.time)) {
      await removeItem(key);
      return null;
    }
    return item.model;
  }

  Future removeItem(String key) async {
    Map<String, dynamic>? data = await readAllData();
    if (data != null) {
      final keyInData = data.keys.isNotEmpty
          ? data.keys.singleWhere(
              (element) => element == key,
              orElse: () => "",
            )
          : "";

      data.remove(keyInData);
      File fileTemp = await getFile();
      await fileTemp.writeAsString(
        jsonEncode(data),
        flush: true,
        mode: FileMode.write,
      );
    }
  }
}
