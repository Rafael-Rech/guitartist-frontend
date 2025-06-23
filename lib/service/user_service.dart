import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tcc/connection/connection.dart';
import 'package:tcc/connection/my_client.dart';
import 'package:tcc/global/date_converter.dart';
import 'package:tcc/global/e_result.dart';
import 'package:tcc/helper/token_helper.dart';
import 'package:tcc/helper/user_helper.dart';
import 'package:tcc/model/user.dart';

final serverIpAddress = Connection.serverIpAddress;
final port = Connection.port;
final baseUrl = "http://$serverIpAddress:$port/api";

Future<EResult> login(String email, String password) async {
  Map<String, String> bodyMap = {"email": email, "password": password};
  var bodyJson = json.encode(bodyMap);

  http.Response response;
  try {
    response = await MyClient.post(Uri.parse("$baseUrl/auth"), bodyJson,
        {"Content-Type": "application/json"});
  } on http.ClientException {
    return EResult.communicationError;
  } on TimeoutException {
    return EResult.serverUnreachable;
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
      return EResult.ok;
    }
    return EResult.noTokenReceived;
  }
  final responseMap = json.decode(response.body);
  try {
    return EResult.fromResponseString(responseMap["message"]);
  } on Exception {
    return EResult.fromResponseString(response.body);
  }
}

Future<EResult> register(String username, String email, String password) async {
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
    return EResult.communicationError;
  } on TimeoutException {
    return EResult.serverUnreachable;
  }

  if (response.statusCode == 201) {
    // Created
    final loginResult = await login(email, password);
    if(loginResult == EResult.ok){
      return EResult.ok;
    }
    return EResult.createdButLoginError;
  }

  // if (response.statusCode == 400) {
  //   // Bad request
  //   return response.body;
  // }

  // return "?";
  return EResult.fromResponseString(response.body);
}

Future<String> getTokenFromDataBase() async {
  String token = await TokenHelper().getToken();
  return token;
}

Future<EResult> getUserFromServer() async {
  String token = await getTokenFromDataBase();

  if (token == "") {
    return EResult.noToken;
  }

  User? userLocal = await UserHelper.getUser();

  if (userLocal == null) {
    return EResult.noUser;
  }

  String? userId = userLocal.id;

  if (userId == null) {
    return EResult.noUserId;
  }

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": token
  };

  http.Response response;
  try {
    response = await MyClient.get(Uri.parse("$baseUrl/user/$userId"), headers);
  } on http.ClientException {
    return EResult.communicationError;
  } on TimeoutException {
    return EResult.serverUnreachable;
  }

  if (response.statusCode == 200) {
    User userServer = UserHelper.mapToUser(json.decode(response.body));
    if (DateConverter.stringToDate(userLocal.time)
        .subtract(Duration(days: 1))
        .isBefore(DateConverter.stringToDate(userServer.time))) {
      userServer.password = userLocal.password;
      await UserHelper.saveUser(userServer);
    }
    return EResult.ok;
  }
  return EResult.fromResponseString(response.body);
}

Future<EResult> update(User user) async {
  Map<String, dynamic> bodyMap = user.toMap();
  bodyMap["time"] = DateConverter.dateToString(DateTime.now());
  var bodyJson = json.encode(bodyMap);

  if (user.id == null) {
    return EResult.noUserId; //TODO: Must go back to the login screen
  }
  String token = await getTokenFromDataBase();
  if(token == ""){
    return EResult.noToken;
  }

  http.Response response;
  try {
    response = await MyClient.put(Uri.parse("$baseUrl/user/${user.id}"),
        bodyJson, {"Content-Type": "application/json", "Authorization": token});
  } on http.ClientException {
    return EResult.communicationError;
  } on TimeoutException {
    return EResult.serverUnreachable;
  }

  if (response.statusCode == 200) {
    // Created
    return EResult.ok;
  }

  if (response.statusCode == 400) {
    // Bad request
    try {
      return EResult.fromResponseString(json.decode(response.body)["message"]);
    } on Exception {
      return EResult.fromResponseString(response.body);
    }
  }

  return EResult.fromResponseString(response.body);
}

Future<EResult> delete() async {
  User? user = await UserHelper.getUser();

  if (user == null) {
    return EResult.noUser; //TODO: Must go back to the login screen
  }

  String? userId = user.id;

  if (userId == null) {
    return EResult.noUserId;
  }
  String token = await getTokenFromDataBase();
  if(token == ""){
    return EResult.noToken;    
  }

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": token
  };

  http.Response response;
  try {
    response =
        await MyClient.delete(Uri.parse("$baseUrl/user/$userId"), headers);
  } on http.ClientException {
    return EResult.communicationError;
  } on TimeoutException {
    return EResult.serverUnreachable;
  }

  if (response.statusCode == 204) {
    await UserHelper.deleteUser();
    await TokenHelper.internal().deleteToken();
    return EResult.ok;
  }

  return EResult.fromResponseString(response.body);
}

Future<EResult> changePassword(String password) async {
  User? user = await UserHelper.getUser();

  if (user == null) {
    return EResult.noUser; //TODO: Must go back to the login screen
  }

  user.password = password;

  final serverResponse = await update(user);
  if (serverResponse == EResult.ok) {
    await UserHelper.saveUser(user);
    return EResult.ok;
  }

  return serverResponse;
}
