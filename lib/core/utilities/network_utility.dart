import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_app11/core/enums/request_type.dart';

class NetworkUtility {
  static String baseUrl = "sssdsy.pythonanywhere.com";
  static var client = http.Client();

  static Future<dynamic> sendRequest({
    required String url,
    required requesType request,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    var uri = Uri.https(baseUrl, url, params);
    http.Response response;
    int statusCode = -1;
    String strResponse = "";
    Map<String, dynamic> jsonResponse = {};

    switch (request) {
      case requesType.GET:
        response = await client.get(uri, headers: headers);
        break;

      case requesType.POST:
        response = await client.post(
          uri,
          body: jsonEncode(body),
          headers: headers,
        );
        break;

      case requesType.PUT:
        response = await client.put(
          uri,
          body: jsonEncode(body),
          headers: headers,
        );
        break;

      case requesType.DELETE:
        response = await client.delete(
          uri,
          body: jsonEncode(body),
          headers: headers,
        );
        break;
    }
    dynamic result;

    try {
      result = jsonDecode(const Utf8Codec().decode(response.bodyBytes));
    } catch (e) {}
    jsonResponse.putIfAbsent(
      'responseData',
      () => result ?? {'message': const Utf8Codec().decode(response.bodyBytes)},
    );
    jsonResponse.putIfAbsent('statusCode', () => response.statusCode);
    return jsonResponse;
  }
}
