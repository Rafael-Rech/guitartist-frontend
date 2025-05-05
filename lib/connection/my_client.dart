import 'package:http/http.dart';

abstract class MyClient {
  static final Client _client = Client();
  static final Duration _duration = Duration(seconds: 10);

  static Future<Response> get(Uri url, Map<String, String>? headers) async {
    return _client.get(url, headers: headers).timeout(_duration);
  }

  static Future<Response> post(
      Uri url, Object? body, Map<String, String>? headers) async {
    return _client.post(url, body: body, headers: headers).timeout(_duration);
  }

  static Future<Response> put(
      Uri url, Object? body, Map<String, String>? headers) async {
    return _client.put(url, body: body, headers: headers).timeout(_duration);
  }

  static Future<Response> delete(Uri url, Map<String, String>? headers)async{
    return _client.delete(url, headers: headers).timeout(_duration);
  }
}
