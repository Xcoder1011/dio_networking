import 'dart:convert';
import 'package:dio_networking/dio_networking.dart';
import 'package:example/controller/news_detail.dart';
import 'package:example/model/news_response.dart';
import 'package:example/view/news_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'dio_networking'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RefreshController _refreshController;
  List<SKDataModel> _dataArray = [];
  bool _enableLoadMore = true;
  int _pageIndex = 1;

  void _requestData({int pageIndex = 1, VoidCallback complete}) async {
    rootBundle.loadString('lib/model/local_json_1.json').then((value) {
      if (mounted) {
        setState(() {
          final dataMap = json.decode(value);
          if (null != dataMap && dataMap is Map<String, dynamic>) {
            NewsResponse response = NewsResponse().fromJson(dataMap);
            if (response?.data != null) {
              _dataArray.addAll(response.data);
            }
          }
          if (null != complete) {
            complete();
          }
        });
      }
    });

    // Networking.instance.get("https://v1.alapi.cn/api/new/toutiao", null,
    //     (result) {
    //   final dataMap = result.responseData;
    //   if (null != dataMap && dataMap is Map<String, dynamic>) {
    //     NewsResponse response = NewsResponse().fromJson(dataMap);
    //     if (response?.data != null) {
    //       _dataArray.addAll(response.data);
    //     }
    //   }
    //   if (null != complete) {
    //     complete();
    //   }
    // });
  }

  void _onRefresh() async {
    _pageIndex = 1;
    _dataArray.clear();
    _requestData(
        complete: () {
          if (mounted) {
            setState(() {
              _refreshController.refreshCompleted();
            });
          }
        },
        pageIndex: _pageIndex);
  }

  void _onLoading() async {
    _pageIndex++;
    _requestData(
        complete: () {
          if (mounted) {
            setState(() {
              _refreshController.loadComplete();
            });
          }
        },
        pageIndex: _pageIndex);
  }

  /// 点击进入详情
  void _didSelectItemAt(SKDataModel item) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => NewsDetailWidget(
                url: "${item.m_url}", title: "${item.title}")));
  }

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    _onRefresh();
  }

  /// List View
  Widget _newsListWidget() {
    int dataListCount = _dataArray.length;
    return Container(
        color: Colors.white,
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: _enableLoadMore,
          controller: _refreshController,
          header: WaterDropHeader(),
          footer: ClassicFooter(),
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return NewsCell(_dataArray[index],
                  callback: (e) => _didSelectItemAt(e));
            },
            itemCount: dataListCount,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _newsListWidget(),
    );
  }
}
