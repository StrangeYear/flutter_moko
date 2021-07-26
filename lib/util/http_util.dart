library flutter_moko;

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sp_util/sp_util.dart';

class HttpUtil {
  ///超时时间
  static const int CONNECT_TIMEOUT = 30000;
  static const int RECEIVE_TIMEOUT = 30000;
  static const String AuthorizationHeader = "Authorization";
  static const String UserIDHeader = "UserID";

  static HttpUtil? _instance;

  factory HttpUtil() => _getInstance();

  static _getInstance() {
    // 只能有一个实例
    if (_instance == null) {
      _instance = HttpUtil._internal();
    }
    return _instance;
  }

  static late Dio _dio;
  static CancelToken _cancelToken = new CancelToken();

  HttpUtil._internal() {
    BaseOptions options = BaseOptions(
      connectTimeout: CONNECT_TIMEOUT,
      receiveTimeout: RECEIVE_TIMEOUT,
      headers: {
        "Platform": Platform.operatingSystem,
      },
    );

    _dio = new Dio(options);
  }

  ///初始化公共属性
  ///
  /// [baseUrl] 地址前缀
  /// [connectTimeout] 连接超时赶时间
  /// [receiveTimeout] 接收超时赶时间
  /// [interceptors] 基础拦截器
  void init({
    required HttpOptions options,
  }) {
    var contentTypeInHeader =
        _dio.options.headers.containsKey(Headers.contentTypeHeader);
    if (_dio.options.contentType != null && contentTypeInHeader) {
      _dio.options.headers.remove(Headers.contentTypeHeader);
    }

    _dio.options = _dio.options.copyWith(
      baseUrl: options.baseUrl,
      connectTimeout: options.connectTimeout ?? CONNECT_TIMEOUT,
      receiveTimeout: options.receiveTimeout ?? RECEIVE_TIMEOUT,
    );
    if (options.interceptors != null && options.interceptors!.isNotEmpty) {
      _dio.interceptors..addAll(options.interceptors!);
    }
  }

  /// 设置headers
  void setHeaders(Map<String, dynamic> map) {
    _dio.options.headers.addAll(map);
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests({CancelToken? token}) {
    token ?? _cancelToken.cancel("cancelled");
  }

  /// restful get 操作
  static Future get(
    String path, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Response response = await _dio.get(
      path,
      queryParameters: params,
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response.data;
  }

  /// restful post 操作
  static Future post(
    String path, {
    Map<String, dynamic>? params,
    data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var response = await _dio.post(
      path,
      data: data,
      queryParameters: params,
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response.data;
  }

  /// restful put 操作
  static Future put(
    String path, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var response = await _dio.put(
      path,
      data: data,
      queryParameters: params,
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response.data;
  }

  /// restful patch 操作
  static Future patch(
    String path, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var response = await _dio.patch(
      path,
      data: data,
      queryParameters: params,
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response.data;
  }

  /// restful delete 操作
  static Future delete(
    String path, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var response = await _dio.delete(
      path,
      data: data,
      queryParameters: params,
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response.data;
  }

  /// restful post form 表单提交操作
  static Future postForm(
    String path, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var response = await _dio.post(
      path,
      data: FormData.fromMap(params ?? {}),
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response.data;
  }
}

class HttpOptions {
  String baseUrl;
  int? connectTimeout;
  int? receiveTimeout;
  List<Interceptor>? interceptors;

  HttpOptions({
    required this.baseUrl,
    this.connectTimeout,
    this.receiveTimeout,
    this.interceptors,
  });
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String? accessToken =
        SpUtil.getString(HttpUtil.AuthorizationHeader, defValue: null);
    int? userID = SpUtil.getInt(HttpUtil.UserIDHeader, defValue: null);
    if (accessToken != null && userID != null) {
      options.headers[HttpUtil.AuthorizationHeader] = accessToken;
      options.headers[HttpUtil.UserIDHeader] = userID;
    }
    super.onRequest(options, handler);
  }
}

class NewAuthorizationInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.headers["Authorization"] == null ||
        response.headers["Authorization"]!.isEmpty) {
      return super.onResponse(response, handler);
    }

    String accessToken = response.headers["Authorization"]!.first;
    SpUtil.putString(HttpUtil.AuthorizationHeader, accessToken);
    return super.onResponse(response, handler);
  }
}
