import 'package:dio/dio.dart';
import 'package:dio_networking/dio_networking.dart';
import 'json_convert/sk_json_convert.dart';
import 'netcache/cache_obj.dart';

typedef void RequestCallback(SKNetDataResult result);

const NET_CACHE_KEY_ENABLE = 'net_cache_key_enable';
const NET_CACHE_KEY_MAX_DURATION = 'net_cache_key_max_duration';
const NET_CACHE_KEY_CALL_BACK = 'net_cache_key_call_back';
const NET_CACHE_KEY_CALL_BACK_MODEL_TYPE = 'net_cache_key_call_back_model_type';
const NET_CACHE_KEY_URL_HOST_TYPE = 'net_cache_key_url_host_type';
const NET_CACHE_KEY_URL_SUCCESS_CODE = 'net_cache_key_success_code';

class Networking {

  static Networking get instance => _sharedInstance();

  factory Networking() => _sharedInstance();

  Networking._();

  static Networking _instance;

  static Networking _sharedInstance() {
    if (null == _instance) {
      _instance = Networking._();
      _instance._dio = Dio();
    }
    return _instance;
  }

  Dio _dio;

  Dio get dio {
    if (null == _dio) {
      _dio = Dio();
    }
    return _dio;
  }

  /// 默认域名
  String _baseUrl;

  /// 配置默认域名
  configBaseUrl (String baseUrl) {
    _baseUrl = baseUrl;
  }

  /// 是否json解析  默认true
  bool _autoJsonConvert = true;

  bool get autoJsonConvert {
    return _autoJsonConvert;
  }

  /// 是否json解析
  enableAutoJsonConvert(bool enable) {
    _autoJsonConvert = enable;
  }

  /// GET
  get<T>(
      String path, Map<String, dynamic> params, RequestCallback finish, {bool needCache = false, int successCode = 0, String host}) async {

    _realRequest<T>(path, params, finish, 'GET', needCache: needCache, successCode: successCode, host: host);
  }

  /// POST
  post<T>(
      String path, Map<String, dynamic> params, RequestCallback finish, {bool needCache = false, int successCode = 0, String host}) async {

    _realRequest<T>(path, params, finish, 'POST', needCache: needCache, successCode: successCode, host: host);
  }

  /// 统一接口请求, 支持 method
  request<T>(
      String path, Map<String, dynamic> params, RequestCallback finish, {bool needCache = false, int successCode = 0, String host, String method = 'GET'}) async {

    _realRequest<T>(path, params, finish, method, needCache: needCache, successCode: successCode, host: host);
  }

  _realRequest<T>(String path, Map<String, dynamic> params,
      RequestCallback finish, String method, {bool needCache = false, int successCode = 0, String host}) async {

    var _extra = <String, dynamic>{'forceJsonDecode': true};
    if (needCache) {
      _extra.addAll({NET_CACHE_KEY_ENABLE : needCache});
      _extra.addAll({NET_CACHE_KEY_MAX_DURATION : Duration(days: 7)});
      _extra.addAll({NET_CACHE_KEY_URL_HOST_TYPE : host ?? _baseUrl});
      _extra.addAll({NET_CACHE_KEY_URL_SUCCESS_CODE : successCode});
      if (null != finish) _extra.addAll({NET_CACHE_KEY_CALL_BACK : finish});
      if (null != T && List<T>() is List<SKJsonConvert>) {
        _extra.addAll({NET_CACHE_KEY_CALL_BACK_MODEL_TYPE: T.toString()});
      }
    }

    Map queryParameters = <String, dynamic>{};
    if (null != params) {
      queryParameters = params;
    }
    final _formData = FormData.fromMap(queryParameters);
    final response = await dio.request<Map<String, dynamic>>(path,
        queryParameters: queryParameters,
        options: RequestOptions(
            method: method,
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: host ?? _baseUrl),
        data: _formData);
    handleFinishCallBack<T>(response, finish, successCode);
  }

  handleFinishCallBack<T>(Response response, RequestCallback finish, int successCode) {
    if (null != finish) {
      SKNetDataResult result = _buildDataResult<T>(response, successCode);
      finish(result);
    }
  }

  handleLocalCacheFinishCallBack(Response response, RequestCallback finish, int successCode,
      {String dataType}) {
    if (null != finish) {
      SKNetDataResult result = _buildDataResult(response, successCode, dataType: dataType);
      result.fromCache = true;
      finish(result);
    }
  }
}

SKNetDataResult _buildDataResult<T>(Response response, int successCode, {String dataType}) {
  int code = -1;
  String message = '';
  var data;
  if (null != response.data && Networking.instance.autoJsonConvert) {
    final dataMap = response.data;
    if (null != dataMap && dataMap is Map<String, dynamic>) {
      if (dataMap['code'] != null) {
        code = dataMap['code']?.toInt();
      }
      if (dataMap['message'] != null) {
        message = dataMap['message']?.toString();
      }
      if (dataMap['data'] != null) {
        data = dataMap['data'];
      }
      if (dataMap['result'] != null) {
        data = dataMap['result'];
      }

      if (null != dataType && null != data) {
        // data 为map 类型
        if (data is Map<String, dynamic>) {
          data = SKJsonConvert.fromJsonSingle(dataType, data);
          // data 为 list 类型
        } else if (data is List) {
          if (dataType.contains("List<")) {
            // List<T> 类型
            String itemType = dataType.substring(5, dataType.length - 1);
            List tempList = List();
            data.forEach((itemJson) {
              tempList.add(SKJsonConvert.fromJsonSingle(itemType, itemJson));
            });
            data = tempList;
          }
        }
      } else if (null != T && null != data) {

        String type = T.toString();

        print("type = $type, runtimeType: ${type.runtimeType}");

        // data 为map 类型
        if (data is Map<String, dynamic>) {
          if (List<T>() is List<SKJsonConvert>) {
            T value = SKJsonConvert.fromJsonSingle(type, data);
            data = value;
          }
          // data 为 list 类型
        } else if (data is List) {
          if (type.contains("List<")) {
            // List<T> 类型
            String itemType = type.substring(5, type.length - 1);
            List tempList = List();
            data.forEach((itemJson) {
              tempList.add(SKJsonConvert.fromJsonSingle(itemType, itemJson));
            });
            data = tempList as T;
          } else {
            //  <T> 类型
            if (List<T>() is List<SKJsonConvert>) {
              print("List<T>() is List<SKJsonConvert>");
              List tempList = List();
              data.forEach((itemJson) {
                print("itemJson>>>> $itemJson");
                tempList.add(SKJsonConvert.fromJsonSingle(type, itemJson));
                print("END>>>>");
              });
              data = tempList;
            }
          }
        }
      }
    }
  }
  SKNetDataResult result = SKNetDataResult(code: code, msg: message, data: data)
    ..statusCode = response.statusCode
    ..statusMessage = response.statusMessage
    ..response = response
    ..responseData = response.data
    ..successCode = successCode;
  return result;
}
