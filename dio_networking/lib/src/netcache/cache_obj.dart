
class SKNetDataResult<T> extends NetDataResult {
  int code;
  String msg;
  T data;
  int successCode;
  bool get success {
    return this.code == this.successCode;
  }
  SKNetDataResult({this.code = -1, this.msg = '', this.data, this.successCode = 0}) : super();
}

class NetDataResult<T> {
  // Http status code.
  int statusCode;
  String statusMessage;
  T responseData;
  // 存储原始response
  T response;
  // 从缓存中读取的数据
  bool fromCache;

  bool get netSuccess {
    bool success = false;
    if (this.responseData != null && this.statusCode == 200) {
      success = true;
    }
    return success;
  }

  NetDataResult(
      {this.statusCode = 0,
        this.statusMessage,
        this.response,
        this.responseData,
        this.fromCache = false});
}

class CacheObj {
  List<int> data;
  List<int> headers;
  String url; // origin url
  String urlPath; // host + path
  String subKey; // query
  int statusCode;
  int endTime;

  CacheObj(
      {this.url,
        this.urlPath,
        this.subKey = '',
        this.statusCode = 200,
        this.data,
        this.headers,
        this.endTime = 0});

  CacheObj.fromJson(Map<String, dynamic> json) {
    if (null != json['url']) {
      url = json['url']?.toString();
    }
    if (null != json['urlPath']) {
      urlPath = json['urlPath']?.toString();
    }
    if (null != json['subKey']) {
      subKey = json['subKey']?.toString();
    }
    if (null != json['statusCode']) {
      statusCode = json['statusCode']?.toInt();
    }
    if (null != json['endTime']) {
      endTime = json['endTime']?.toInt();
    }
    if (null != json['data']) {
      data = json['data']?.map((v) => v.toInt())?.toList()?.cast<int>();
    }
    if (null != json['headers']) {
      headers = json['headers']?.map((v) => v.toInt())?.toList()?.cast<int>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['url'] = url ?? '';
    map['urlPath'] = urlPath ?? '';
    map['subKey'] = subKey ?? '';
    map['statusCode'] = statusCode ?? 200;
    map['endTime'] = endTime ?? 0;
    if (null != headers) {
      map['headers'] = headers;
    }
    if (null != data) {
      map['data'] = data;
    }
    return map;
  }
}
