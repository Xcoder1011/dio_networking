import 'cache_obj.dart';
import 'net_cache.dart';
import 'net_linked_list.dart';

class NetMemoryCache extends NetCache {
  /// 容量
  final int capacity;

  /// Hash
  late Map<String, LinkNode> _hashMap;

  /// 双链表
  late LinkedList _linkedList;

  NetMemoryCache({this.capacity = 0}) {
    _linkedList = LinkedList();
    _hashMap = {};
  }

  String _dealKey(String key, {String? subKey}) {
    String realKey = key;
    if (null != subKey) realKey += '_$subKey';
    return realKey;
  }

  @override
  Future<CacheObj?> cacheObjectForKey(String key, {String? subKey}) async {
    final realKey = _dealKey(key, subKey: subKey);
    var node = _hashMap[realKey];
    if (null == node) return null;
    if (node.value != null) {
      saveObject(node.value!);
    }
    return node.value;
  }

  @override
  Future<bool> saveObject(CacheObj cacheObj) async {
    final key = cacheObj.urlPath ?? '';
    final subKey = cacheObj.subKey;
    final realKey = _dealKey(key, subKey: subKey);
    if (realKey.isEmpty) return false;
    var node = _hashMap[realKey];
    if (null == node) {
      // key不存在
      if (capacity == _linkedList.size) {
        // 如果达到最大容量，则删除双向链表的尾部节点
        final lastDeleteNode = _linkedList.removeLastNode();
        // 删除哈希表中对应的项
        _hashMap.remove(lastDeleteNode.key);
      }
      final newNode = LinkNode(key: realKey, value: cacheObj);
      // 在双向链表的头部添加该节点
      _linkedList.addNodeBehindHead(newNode);
      // 更新该节点的值
      _hashMap.update(realKey, (value) => newNode);
    } else {
      // key已经存在
      // 删除该旧节点
      _linkedList.removeNode(node);
      final newNode = LinkNode(key: realKey, value: cacheObj);
      // 在双向链表的头部添加该节点
      _linkedList.addNodeBehindHead(newNode);
      // 更新该节点的值
      _hashMap.update(realKey, (value) => newNode);
    }
    return true;
  }

  @override
  Future<bool> containsObjectForKey(String key, {String? subKey}) async {
    final realKey = _dealKey(key, subKey: subKey);
    if (realKey.isEmpty) return false;
    var node = _hashMap[realKey];
    if (null == node) return false;
    return true;
  }

  @override
  Future<bool> removeAllObjects() async {
    _hashMap.clear();
    _linkedList.removeAll();
    return true;
  }

  @override
  Future<bool> removeObjectForKey(String key, {String? subKey}) async {
    final realKey = _dealKey(key, subKey: subKey);
    if (realKey.isEmpty) return false;
    var node = _hashMap[realKey];
    if (null == node) return false;
    _linkedList.removeNode(node);
    _hashMap.remove(realKey);
    return true;
  }

  @override
  Future<bool> clearExpiredObjects() async {
    return false;
  }
}
