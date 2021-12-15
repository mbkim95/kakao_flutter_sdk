import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_common/src/kakao_api_exception.dart';
import 'package:kakao_flutter_sdk_common/src/kakao_auth_exception.dart';
import 'package:kakao_flutter_sdk_common/src/sdk_log.dart';

/// @nodoc
/// Factory for network clients, interceptors, and error transformers used by other libraries.
class ApiFactory {
  /// [Dio] instance for appkey-based Kakao API.
  static final Dio appKeyApi = _appKeyApiInstance();

  static Dio _appKeyApiInstance() {
    var dio = Dio();
    dio.options.baseUrl = "https://${KakaoSdk.hosts.kapi}";
    dio.options.contentType = "application/x-www-form-urlencoded";
    dio.interceptors.addAll([
      appKeyInterceptor,
      kaInterceptor,
      LogInterceptor(
        requestBody: kDebugMode ? true : false,
        responseBody: kDebugMode ? true : false,
        logPrint: SdkLog.i,
      )
    ]);
    return dio;
  }

  static Future<T> handleApiError<T>(
      Future<T> Function() requestFunction) async {
    try {
      return await requestFunction();
    } on DioError catch (e) {
      throw transformApiError(e);
    }
  }

  /// transforms [DioError] to [KakaoException].
  static KakaoException transformApiError(DioError e) {
    var response = e.response;
    var request = e.requestOptions;

    if (response == null) return KakaoClientException(e.message);
    if (response.statusCode == 404) {
      return KakaoClientException(e.message);
    }
    if (Uri.parse(request.baseUrl).host == KakaoSdk.hosts.kauth) {
      return KakaoAuthException.fromJson(response.data);
    }

    return KakaoApiException.fromJson(response.data);
  }

  /// DIO interceptor for App-key based API (Link, Local, Search, etc).
  static Interceptor appKeyInterceptor = InterceptorsWrapper(onRequest:
      (RequestOptions options, RequestInterceptorHandler handler) async {
    var appKey = KakaoSdk.nativeKey;
    options.headers["Authorization"] = "KakaoAK $appKey";
    handler.next(options);
  });

  /// DIO interceptor for all Kakao API that requires KA header.
  static Interceptor kaInterceptor = InterceptorsWrapper(onRequest:
      (RequestOptions options, RequestInterceptorHandler handler) async {
    var kaHeader = await KakaoSdk.kaHeader;
    options.headers["KA"] = kaHeader;
    handler.next(options);
  });
}
