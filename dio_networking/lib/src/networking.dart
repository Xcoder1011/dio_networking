import 'package:dio/dio.dart';
import 'package:dio_networking/dio_networking.dart';
import 'json_convert/sk_json_convert.dart';
import 'net_cache/cache_obj.dart';

typedef RequestCallback = void Function(SKNetDataResult result);

const NET_CACHE_KEY_ENABLE = 'net_cache_key_enable';
const NET_CACHE_KEY_MAX_DURATION = 'net_cache_key_max_duration';
const NET_CACHE_KEY_CALL_BACK = 'net_cache_key_call_back';
const NET_CACHE_KEY_CALL_BACK_MODEL_TYPE = 'net_cache_key_call_back_model_type';
const NET_CACHE_KEY_URL_HOST_TYPE = 'net_cache_key_url_host_type';
const NET_CACHE_KEY_URL_SUCCESS_CODE = 'net_cache_key_success_code';

class Networking {
  static Networking get instance => _sharedInstance();

  factory Networking() => _sharedInstance();

  Networking._() : _baseUrl = '';

  static Networking? _instance;

  static Networking _sharedInstance() {
    if (null == _instance) {
      _instance = Networking._();
      _instance?._dio = Dio();
    }
    return _instance!;
  }

  Dio? _dio;

  Dio get dio {
    _dio ??= Dio();
    return _dio!;
  }

  /// 默认域名
  String _baseUrl;

  /// 配置默认域名
  configBaseUrl(String url) {
    _baseUrl = url;
  }

  /// 是否json解析  默认false
  bool _autoJsonConvert = false;

  bool get autoJsonConvert {
    return _autoJsonConvert;
  }

  /// 是否json解析
  enableAutoJsonConvert(bool enable) {
    _autoJsonConvert = enable;
  }

  /// GET
  get<T>(String path, Map<String, dynamic>? params, RequestCallback finish,
      {bool needCache = false, int successCode = 0, String? baseUrl}) async {
    _realRequest<T>(path, params, finish, 'GET',
        needCache: needCache, successCode: successCode, baseUrl: baseUrl);
  }

  /// POST
  post<T>(String path, Map<String, dynamic>? params, RequestCallback finish,
      {bool needCache = false, int successCode = 0, String? baseUrl}) async {
    _realRequest<T>(path, params, finish, 'POST',
        needCache: needCache, successCode: successCode, baseUrl: baseUrl);
  }

  /// 统一接口请求, 支持 method
  request<T>(String path, Map<String, dynamic>? params, RequestCallback finish,
      {bool needCache = false,
      int successCode = 0,
      String? baseUrl,
      String method = 'GET'}) async {
    _realRequest<T>(path, params, finish, method,
        needCache: needCache, successCode: successCode, baseUrl: baseUrl);
  }

  _realRequest<T>(String path, Map<String, dynamic>? params,
      RequestCallback finish, String method,
      {bool needCache = false, int successCode = 0, String? baseUrl}) async {
    var extra = <String, dynamic>{'forceJsonDecode': true};
    if (needCache) {
      extra.addAll({NET_CACHE_KEY_ENABLE: needCache});
      extra.addAll({NET_CACHE_KEY_MAX_DURATION: const Duration(days: 7)});
      extra.addAll({NET_CACHE_KEY_URL_HOST_TYPE: baseUrl ?? _baseUrl});
      extra.addAll({NET_CACHE_KEY_URL_SUCCESS_CODE: successCode});
      extra.addAll({NET_CACHE_KEY_CALL_BACK: finish});
      if (<T>[] is List<SKJsonConvert>) {
        extra.addAll({NET_CACHE_KEY_CALL_BACK_MODEL_TYPE: T.toString()});
      }
    }

    var queryParameters = <String, dynamic>{};
    if (null != params) {
      queryParameters = params;
    }
    final formData = FormData.fromMap(queryParameters);
    dio.options.baseUrl = baseUrl ?? _baseUrl;
    Options options = Options(method: method, headers: {}, extra: extra);
    final response = await dio.request<Map<String, dynamic>>(path,
        data: formData, queryParameters: queryParameters, options: options);
    handleFinishCallBack<T>(response, finish, successCode);
  }

  handleFinishCallBack<T>(
      Response response, RequestCallback? finish, int successCode) {
    if (null != finish) {
      SKNetDataResult result = _buildDataResult<T>(response, successCode);
      finish(result);
    }
  }

  handleLocalCacheFinishCallBack(
      Response response, RequestCallback? finish, int successCode,
      {String? dataType}) {
    if (null != finish) {
      SKNetDataResult result =
          _buildDataResult(response, successCode, dataType: dataType);
      result.fromCache = true;
      finish(result);
    }
  }
}

SKNetDataResult _buildDataResult<T>(Response response, int successCode,
    {String? dataType}) {
  int code = -1;
  String? message = '';
  T? data;
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
            List tempList = [];
            for (var item in data) {
              tempList.add(SKJsonConvert.fromJsonSingle(itemType, item));
            }
            data = tempList as T?;
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
