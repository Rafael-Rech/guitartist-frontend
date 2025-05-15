import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tcc/connection/connection.dart';
import 'package:tcc/connection/my_client.dart';
import 'package:tcc/global/date_converter.dart';
import 'package:tcc/helper/token_helper.dart';
import 'package:tcc/helper/user_helper.dart';
import 'package:tcc/model/user.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

final serverIpAddress = Connection.serverIpAddress;
final port = Connection.port;
final baseUrl = "http://$serverIpAddress:$port/api";

Future<String> login(String email, String password) async {
  print("Iniciando função de login");
  Map<String, String> bodyMap = {"email": email, "password": password};
  var bodyJson = json.encode(bodyMap);

  http.Response response;
  try {
    response = await MyClient.post(Uri.parse("$baseUrl/auth"), bodyJson,
        {"Content-Type": "application/json"});
    print("Response: $response");
  } on http.ClientException {
    print("Servidor inalcançável");
    // return false;
    return "Servidor inalcançável";
  } on TimeoutException {
    print("Servidor inalcançável");
    // return false;
    return "Servidor inalcançável";
  }

  print("Body da response do login ${response.body}");
  print("Código da response do login${response.statusCode}");
  if (response.statusCode == 200) {
    Map responseBody = json.decode(response.body);
    print("Deu boa no login");
    if (responseBody.containsKey("token")) {
      print("Tem token na response, salvando");
      JWT jwt;
      try {
        jwt = JWT.decode(responseBody["token"].substring(7));
        print("Payload: ${jwt.payload}, type: ${jwt.payload.runtimeType}");
      } on Exception catch (e) {
        print("Erro ao decodificar jwt");
        print(e);
        // return false;
        return "Erro ao decodificar jwt";
      }
      print(await TokenHelper.internal().saveToken(responseBody["token"]));
      if (responseBody.containsKey("userResponseDTO")) {
        User user = UserHelper.mapToUser(responseBody["userResponseDTO"]);
        user.password = password;
        await UserHelper.saveUser(user);
      }
      // return true;
      return "OK";
    }
    print("Não tem token na response");
  }
  print("Deu ruim no login");
  // return false;

  final responseMap = json.decode(response.body);

  // print("");
  // print("responseMap: $responseMap");
  // print("Tipo: ${responseMap.runtimeType}");
  // print("É um mapa: ${responseMap.runtimeType == Map}");
  // print("É um mapa<String, dynamic>: ${responseMap.runtimeType == Map<String, dynamic>}");
  // print("Contém a chave: ${responseMap.containsKey("message")}");
  // print("responseMap[message]: ${responseMap["message"]}");
  // print("");
  // if(responseMap.runtimeType == Map && responseMap.containsKey("message")){
  //   print("Retornando mensagem");
  //   return responseMap["message"];
  // }
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
    print("Response: $response");
  } on http.ClientException {
    print("Servidor inalcançável");
    return "Couldn't reach the server";
  } on TimeoutException {
    print("Servidor inalcançável");
    return "Couldn't reach the server";
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
    print("Sem token no banco de dados");
    return false;
  }

  User? userLocal = await UserHelper.getUser();

  if (userLocal == null) {
    print("Sem usuário no banco de dados local");
    return false;
  }

  String? userId = userLocal.id;

  if (userId == null) {
    print("Usuário no banco local sem ID");
    return false;
  }

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": token
  };

  // http.Response response =
  // await http.get(Uri.parse("$baseUrl/user"), headers: headers);

  // print("token antes de solicitar o user: $token");
  http.Response response;
  try {
    response = await MyClient.get(Uri.parse("$baseUrl/user/$userId"), headers);
  } on http.ClientException {
    print("Servidor inalcançável");
    return false;
  } on TimeoutException {
    print("Servidor inalcançável");
    return false;
  }

  print("Status code ao obter: ${response.statusCode}");
  if (response.statusCode == 200) {
    print("Body ao obter: ${response.body}");
    print("Tipo do body: ${response.body.runtimeType}");
    print("");
    print("Convertendo o json para o userServer");
    User userServer = UserHelper.mapToUser(json.decode(response.body));
    if (DateConverter.stringToDate(userLocal.time)
        .subtract(Duration(days: 1))
        .isBefore(DateConverter.stringToDate(userServer.time))) {
      userServer.password = userLocal.password;
      print("");
      print("");
      print("USER DO SERVER ANTES DE SALVAR: $userServer");
      print("");
      print("");
      await UserHelper.saveUser(userServer);
    } else {
      print("");
      print("");
      print("DATA NÃO BATEU");
      print("");
      print("");
    }
    return true;
  }
  print("Nao deu boa o user");
  return false;
}

Future<String> update(User user) async {
  // Map<String, dynamic> bodyMap = {
  //   "name": username,
  //   "email": email,
  //   "password": password,
  //   "appVersion": 0,
  //   "lessons": [],
  //   "time": DateConverter.dateToString(DateTime.now())
  // };

  Map<String, dynamic> bodyMap = user.toMap();
  bodyMap["time"] = DateConverter.dateToString(DateTime.now());
  var bodyJson = json.encode(bodyMap);

  if (user.id == null) {
    return "Erro ao obter ID de usuário"; // Voltar para a tela de login
  }
  String token = await getTokenFromDataBase();

  http.Response response;
  try {
    response = await MyClient.put(Uri.parse("$baseUrl/user/${user.id}"),
        bodyJson, {"Content-Type": "application/json", "Authorization": token});
    print("Response: $response");
  } on http.ClientException {
    print("Servidor inalcançável");
    return "Couldn't reach the server";
  } on TimeoutException {
    print("Servidor inalcançável");
    return "Couldn't reach the server";
  }

  print("Body do update: ${response.body}");
  print("Status do update: ${response.statusCode}");

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
    return "Não há usuário "; // Retornar para a tela de login
  }

  String? userId = user.id;

  if (userId == null) {
    print("Usuário no banco local sem ID");
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
    print("Servidor inalcançável");
    return "Servidor inalcançável";
  } on TimeoutException {
    print("Servidor inalcançável");
    return "Servidor inalcançável";
  }

  if (response.statusCode == 204) {
    await UserHelper.deleteUser();
    await TokenHelper.internal().deleteToken();
    return "DELETED"; // Voltar para a tela inicial
  }

  return response.body;
}

Future<String> changePassword(String password) async {
  User? user = await UserHelper.getUser();

  if (user == null) {
    return "Não há usuário "; // Retornar para a tela de login
  }

  user.password = password;

  final serverResponse = await update(user);
  if (serverResponse == "OK") {
    await UserHelper.saveUser(user);
    return "OK";
  }

  return serverResponse;
}
