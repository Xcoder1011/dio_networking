import 'dart:math';
import 'package:example/model/news_response.dart';
import 'package:flutter/material.dart';

typedef ClickCallBack<T> = void Function(T value);

class NewsCell extends StatelessWidget {
  final SKDataModel item;
  final ClickCallBack? callback;

  const NewsCell(this.item, {super.key, this.callback});

  void _tapDetail() {
    if (callback != null) {
      callback!(item);
    }
  }

  Widget line() {
    return Container(
      color: const Color(0xFFE5E5E5),
      height: 0.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _tapDetail,
      child: Container(
        height: 111,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 110,
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title ?? '',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      Text(item.source ?? '',
                          style: const TextStyle(fontSize: 10)),
                    ],
                  )),
                  const SizedBox(width: 5),
                  Image.network(item.imgsrc ?? '')
                ],
              ),
            ),
            line(),
          ],
        ),
      ),
    );
  }
}

class SKColors {
  static Color randomColor() {
    int r = Random.secure().nextInt(255);
    int g = Random.secure().nextInt(255);
    int b = Random.secure().nextInt(255);
    return Color.fromARGB(255, r, g, b);
  }
}
