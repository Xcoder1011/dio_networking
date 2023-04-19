import 'package:dio_networking/src/net_cache/cache_obj.dart';

class LinkedList {
  // 伪头部节点head， 伪尾部节点tail
  LinkNode? head, tail;

  // 链表元素数 (不包含 头尾的伪节点)
  int size;

  LinkedList({this.head, this.tail, this.size = 0}) {
    head = LinkNode();
    tail = LinkNode();
    head?.next = tail;
    tail?.prev = head;
  }

  addNodeBehindHead(LinkNode node) {
    node.next = head?.next;
    head?.next?.prev = node;
    node.prev = head;
    head?.next = node;
    size += 1;
  }

  removeNode(LinkNode node) {
    node.prev?.next = node.next;
    node.next?.prev = node.prev;
    size -= 1;
  }

  LinkNode removeLastNode() {
    if (size > 0) {
      final lastNode = tail?.prev;
      if (lastNode != null) {
        removeNode(lastNode);
        return lastNode;
      }
    }
    return LinkNode();
  }

  removeAll() {
    head?.next = tail;
    tail?.prev = head;
    size = 0;
  }
}

class LinkNode {
  String? key;
  CacheObj? value;
  LinkNode? prev;
  LinkNode? next;

  LinkNode({this.key, this.value});
}
