import 'package:web/web.dart' as web;
import 'settings_service.dart';

class WebStorage implements Storage {
  @override
  Future<String?> getString(String key) async {
    return web.window.localStorage.getItem(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    web.window.localStorage.setItem(key, value);
  }
}

Storage createStorage() => WebStorage();
