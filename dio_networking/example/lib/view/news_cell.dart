import 'dart:math';

import 'package:example/model/news_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef ClickCallBack<T> = void Function(T value);

class NewsCell extends StatelessWidget {
  final SKDataModel item;
  final ClickCallBack callback;

  NewsCell(this.item, {this.callback});

  void _tapDetail() {
    if (callback != null) {
      callback(item);
    }
  }

  Widget line() {
    return Container(
      color: Color(0xFFE5E5E5),
      height: 0.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 110,
              color: Colors.white,
              padding: EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      Text(item.source, style: TextStyle(fontSize: 10)),
                    ],
                  )),
                  SizedBox(width: 5),
                  Image.network(item.imgsrc)
                ],
              ),
            ),
            line(),
          ],
        ),
        height: 111,
        color: Colors.white,
      ),
      onTap: _tapDetail,
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
