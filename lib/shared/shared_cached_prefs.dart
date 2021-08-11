import 'package:shared_preferences/shared_preferences.dart';

enum CachePriority{Cache, Func}

class CachedPrefs{
  static CachedPrefs st;
  SharedPreferences _sp;

  Future<void> init() async{
    _sp = await SharedPreferences.getInstance();
  }

  Future<String> getSetString(String _key, Future<String> Function() func, Duration duration, CachePriority cachePriority) async {
    int millis = DateTime.now().millisecondsSinceEpoch;
    if (cachePriority == CachePriority.Cache){
      if (_sp.containsKey(_key + 'DUR')){
        if (millis - _sp.getInt(_key + 'DUR') <= duration.inMilliseconds) {
          return _sp.getString(_key);
        }
      }
      String val = await func();
      await _sp.setInt(_key + 'DUR', millis);
      await _sp.setString(_key, val);
      return val;
    }
    else{
      try{
        String val = await func();
        await _sp.setInt(_key + 'DUR', millis);
        await _sp.setString(_key, val);
        return val;
      }
      catch (e){
        if (_sp.containsKey(_key + 'DUR')){
          int n = _sp.getInt(_key + 'DUR');
          print('n is $n');
          if (millis - n <= duration.inMilliseconds) {
            return _sp.getString(_key);
          }
        }
        // throw Exception('getSetString error with key:($_key)');
        return null;
      }
    }
  }

  Future<int> getSetInt(String _key, Future<int> Function() func, Duration duration, CachePriority cachePriority) async {
    int millis = DateTime.now().millisecondsSinceEpoch;
    if (cachePriority == CachePriority.Cache){
      if (_sp.containsKey(_key + 'DUR')){
        if (millis - _sp.getInt(_key + 'DUR') <= duration.inMilliseconds) {
          return _sp.getInt(_key);
        }
      }
      int val = await func();
      await _sp.setInt(_key + 'DUR', millis);
      await _sp.setInt(_key, val);
      return val;
    }
    else{
      try{
        int val = await func();
        await _sp.setInt(_key + 'DUR', millis);
        await _sp.setInt(_key, val);
        return val;
      }
      catch (e){
        if (_sp.containsKey(_key + 'DUR')){
          if (millis - _sp.getInt(_key + 'DUR') <= duration.inMilliseconds) {
            return _sp.getInt(_key);
          }
        }
        // throw Exception('getSetInt error with key:($_key)');
        return null;
      }
    }
  }
}