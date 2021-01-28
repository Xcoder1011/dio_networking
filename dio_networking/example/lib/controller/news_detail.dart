
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetailWidget extends StatefulWidget {

  final String url;
  String title;

  NewsDetailWidget({this.url, this.title});

  @override
  State<StatefulWidget> createState() {
    return _NewsDetailWidget();
  }
}

class _NewsDetailWidget extends State<NewsDetailWidget> {
  WebViewController _webViewController;
  bool _webViewReady = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: SafeArea(
          child: _webViewWidget(),
        ));
  }

  _webViewWidget() {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController controller) {
              _webViewController = controller;
              controller.loadUrl(widget.url);
            },
            onPageFinished: (String value) {
              _webViewReady = true;
              _webViewController
                  .evaluateJavascript('document.title')
                  .then((title) {
                setState(() {
                  widget.title = title;
                });
              });
            },
            onPageStarted: (String value) {
              _webViewReady = false;
            },
          ),
        ),
        
        Container(
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: !_webViewReady
                    ? null
                    : () async {
                        if (await _webViewController.canGoBack()) {
                          await _webViewController.goBack();
                        }
                      },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: !_webViewReady
                    ? null
                    : () async {
                        if (await _webViewController.canGoForward()) {
                          await _webViewController.goForward();
                        }
                      },
              ),
              IconButton(
                icon: const Icon(Icons.replay),
                onPressed: !_webViewReady
                    ? null
                    : () {
                        _webViewController.reload();
                      },
              ),
            ],
          ),
        )
      ],
    );
  }
}
