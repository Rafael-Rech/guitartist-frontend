import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tcc/connection/connection.dart';
import 'package:tcc/connection/my_client.dart';
import 'package:tcc/global/date_converter.dart';
import 'package:tcc/helper/token_helper.dart';
import 'package:tcc/helper/user_helper.dart';
import 'package:tcc/model/user.dart';

final serverIpAddress = Connection.serverIpAddress;
final port = Connection.port;
final baseUrl = "http://$serverIpAddress:$port/api";

Future<String> login(String email, String password) async {
  Map<String, String> bodyMap = {"email": email, "password": password};
  var bodyJson = json.encode(bodyMap);

  http.Response response;
  try {
    response = await MyClient.post(Uri.parse("$baseUrl/auth"), bodyJson,
        {"Content-Type": "application/json"});
  } on http.ClientException {
    return "Servidor inalcançável";
  } on TimeoutException {
    return "Servidor inalcançável";
  }

  if (response.statusCode == 200) {
    Map responseBody = json.decode(response.body);
    if (responseBody.containsKey("token")) {
      await TokenHelper.internal().saveToken(responseBody["token"]);
      if (responseBody.containsKey("userResponseDTO")) {
        User user = UserHelper.mapToUser(responseBody["userResponseDTO"]);
        user.password = password;
        await UserHelper.saveUser(user);
      }
      return "OK";
    }
  }
  final responseMap = json.decode(response.body);
  try {
    return responseMap["message"];
  } on Exception {
    return response.body;
  }
}

Future<String> register(String username, String email, String password) async {
  Map<String, dynamic> bodyMap = {
    "name": username,
    "email": email,
    "password": password,
    "appVersion": 0,
    "lessons": [],
    "time": DateConverter.dateToString(DateTime.now())
  };
  var bodyJson = json.encode(bodyMap);

  http.Response response;
  try {
    response = await MyClient.post(Uri.parse("$baseUrl/user"), bodyJson,
        {"Content-Type": "application/json"});
  } on http.ClientException {
    return "Servidor inalcançável";
  } on TimeoutException {
    return "Servidor inalcançável";
  }

  if (response.statusCode == 201) {
    // Created
    await login(email, password);
    return "CREATED";
  }

  if (response.statusCode == 400) {
    // Bad request
    return response.body;
  }

  return "?";
}

Future<String> getTokenFromDataBase() async {
  String token = await TokenHelper().getToken();
  return token;
}

Future<bool> getUserFromServer() async {
  String token = await getTokenFromDataBase();

  if (token == "") {
    return false;
  }

  User? userLocal = await UserHelper.getUser();

  if (userLocal == null) {
    return false;
  }

  String? userId = userLocal.id;

  if (userId == null) {
    return false;
  }

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": token
  };

  http.Response response;
  try {
    response = await MyClient.get(Uri.parse("$baseUrl/user/$userId"), headers);
  } on http.ClientException {
    return false;
  } on TimeoutException {
    return false;
  }

  if (response.statusCode == 200) {

    User userServer = UserHelper.mapToUser(json.decode(response.body));
    if (DateConverter.stringToDate(userLocal.time)
        .subtract(Duration(days: 1))
        .isBefore(DateConverter.stringToDate(userServer.time))) {
      userServer.password = userLocal.password;
      await UserHelper.saveUser(userServer);
    }
    return true;
  }
  return false;
}

Future<String> update(User user) async {
  Map<String, dynamic> bodyMap = user.toMap();
  bodyMap["time"] = DateConverter.dateToString(DateTime.now());
  var bodyJson = json.encode(bodyMap);

  if (user.id == null) {
    return "Erro ao obter ID de usuário"; //TODO: Must go back to the login screen
  }
  String token = await getTokenFromDataBase();

  http.Response response;
  try {
    response = await MyClient.put(Uri.parse("$baseUrl/user/${user.id}"),
        bodyJson, {"Content-Type": "application/json", "Authorization": token});
  } on http.ClientException {
    return "Servidor inalcançável";
  } on TimeoutException {
    return "Servidor inalcançável";
  }

  if (response.statusCode == 200) {
    // Created
    return "OK";
  }

  if (response.statusCode == 400) {
    // Bad request
    try {
      return json.decode(response.body)["message"];
    } on Exception {
      return response.body;
    }
  }

  return "?";
}

Future<String> delete() async {
  User? user = await UserHelper.getUser();

  if (user == null) {
    return "Não há usuário "; //TODO: Must go back to the login screen
  }

  String? userId = user.id;

  if (userId == null) {
    return "Usuário no banco local sem ID";
  }
  String token = await getTokenFromDataBase();

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": token
  };

  http.Response response;
  try {
    response =
        await MyClient.delete(Uri.parse("$baseUrl/user/$userId"), headers);
  } on http.ClientException {
    return "Servidor inalcançável";
  } on TimeoutException {
    return "Servidor inalcançável";
  }

  if (response.statusCode == 204) {
    await UserHelper.deleteUser();
    await TokenHelper.internal().deleteToken();
    return "DELETED";
  }

  return response.body;
}

Future<String> changePassword(String password) async {
  User? user = await UserHelper.getUser();

  if (user == null) {
    return "Não há usuário "; //TODO: Must go back to the login screen
  }

  user.password = password;

  final serverResponse = await update(user);
  if (serverResponse == "OK") {
    await UserHelper.saveUser(user);
    return "OK";
  }

  return serverResponse;
}
