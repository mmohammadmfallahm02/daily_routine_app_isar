import 'dart:convert';

import 'package:dio/dio.dart';

enum Method { POST, GET, DELETE, PATCH }

class HttpServices {
  late Dio? dio;

  Future<HttpServices> init(BaseOptions options) async {
    dio = Dio(options);
    return this;
  }

  Future<dynamic> request({
    required String endpoint,
    required Method method,
    Map<String, dynamic>? params,
  }) async {
    Response response;
    try {
      if (method == Method.GET) {
        response = await dio!.get(endpoint, queryParameters: params);
      } else if (method == Method.POST) {
        response = await dio!.post(endpoint, data: json.encode(params));
      } else if (method == Method.DELETE) {
        response = await dio!.delete(endpoint);
      } else {
        response = await dio!.patch(endpoint);
      }

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Something went wrong');
      }
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }
}
