import 'cache_obj.dart';

abstract class NetCache {
  NetCache();

  Future<bool> containsObjectForKey(String key, {String subKey});

  Future<CacheObj> cacheObjectForKey(String key, {String subKey});

  Future<bool> saveObject(CacheObj cacheObj);

  Future<bool> removeObjectForKey(String key, {String subKey});

  Future<bool> removeAllObjects();

  Future<bool> clearExpiredObjects();
}
