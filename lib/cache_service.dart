import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String _viewsDataKey = 'views_data_cache';
  static const String _lastEditTimeKey = 'last_edit_time';

  static Future<void> saveViewsData(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_viewsDataKey, _mapToJson(data));
      await prefs.setString(_lastEditTimeKey, DateTime.now().toIso8601String());
    } catch (e) {
      print('Error saving views data: $e');
    }
  }

  static Future<Map<String, dynamic>?> loadViewsData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataString = prefs.getString(_viewsDataKey);
      if (dataString != null) {
        return _jsonToMap(dataString);
      }
    } catch (e) {
      print('Error loading views data: $e');
    }
    return null;
  }

  static Future<bool> hasCachedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_viewsDataKey) != null;
    } catch (e) {
      return false;
    }
  }

  static Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_viewsDataKey);
      await prefs.remove(_lastEditTimeKey);
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  static String _mapToJson(Map<String, dynamic> map) {
    return map.entries.map((e) => '${e.key}:${e.value}').join('|');
  }

  static Map<String, dynamic> _jsonToMap(String json) {
    final map = <String, dynamic>{};
    final pairs = json.split('|');
    for (final pair in pairs) {
      final colonIndex = pair.indexOf(':');
      if (colonIndex != -1) {
        final key = pair.substring(0, colonIndex);
        final value = pair.substring(colonIndex + 1);
        map[key] = value;
      }
    }
    return map;
  }
}
