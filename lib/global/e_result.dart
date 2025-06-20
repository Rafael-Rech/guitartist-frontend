import 'package:flutter/material.dart';
import 'package:tcc/global/alerts.dart';
import 'package:tcc/global/my_colors.dart';
import 'package:tcc/view/login_page.dart';

enum EResult {
  ok(redirectToLogin: false),
  noUserOnServer(
      title: "Usuário não encontrado",
      content:
          "Não foi encontrado um usuário com o endereço de e-mail inserido.",
      redirectToLogin: false),
  userAlreadyRegistered(
      title: "Usuário já cadastrado",
      content:
          "Já existe um usuário cadastrado com o endereço de e-mail inserido.",
      redirectToLogin: false),
  invalidEmailFormat(
      title: "Formato de e-mail inválido",
      content: "Insira um endereço de e-mail válido.",
      redirectToLogin: false),
  emailTooLong(
      title: "E-mail muito longo",
      content: "Insira um endereço de e-mail com até 63 caracteres.",
      redirectToLogin: false),
  emptyEmail(
      title: "Insira um e-mail",
      content: "Insira um endereço de e-mail para continuar.",
      redirectToLogin: false),
  emptyUsername(
      title: "Insira um nome de usuário",
      content: "Insira um nome de usuário para continuar.",
      redirectToLogin: false),
  usernameTooLong(
      title: "Nome de usuário muito longo",
      content: "Insira um nome de usuário com até 63 caracteres.",
      redirectToLogin: false),
  passwordTooShort(
      title: "Senha muito curta",
      content: "Insira uma senha com no mínimo 8 caracteres.",
      redirectToLogin: false),
  passwordTooLong(
      title: "Senha muito longa",
      content: "Insira uma senha com no máximo 63 caracteres",
      redirectToLogin: false),
  internalServerError(
      title: "Erro interno no servidor",
      content: "Ocorreu um erro. Tente novamente mais tarde.",
      redirectToLogin: false),
  invalidEmailOrPassword(
      title: "Email ou senha inválidos",
      content: "Confira os dados e tente novamente.",
      redirectToLogin: false),
  unauthorized(
      title: "Sem autorização",
      content: "Você não tem autorização para prosseguir",
      redirectToLogin: false),
  noToken(
      title: "Erro ao recuperar informações da conta",
      content: "Faça login novamente por favor.",
      redirectToLogin: true), // Redirecionar para o login
  noUser(
      title: "Erro ao recuperar informações da conta",
      content: "Faça login novamente por favor.",
      redirectToLogin: true), // Redirecionar para o login
  noUserId(
      title: "Erro ao recuperar informações da conta",
      content: "Faça login novamente por favor.",
      redirectToLogin: true), // Redirecionar para o login
  serverUnreachable(
      title: "Não foi possível alcançar o servidor",
      content: "Verifique sua conexão ou tente novamente mais tarde.",
      redirectToLogin: false),
  communicationError(
      title: "Erro ao se comunicar com o servidor",
      content: "Verifique sua conexão ou tente novamente mais tarde",
      redirectToLogin: false),
  noTokenReceived(
      title: "Erro ao efetuar login",
      content: "Tente novamente mais tarde.",
      redirectToLogin: false),
  createdButLoginError(
      title: "Erro ao completar a autenticação",
      content:
          "Sua conta foi criada, mas não foi possível completar a autenticação. Tente realizar login novamente por favor.",
      redirectToLogin: true), // Ir para o login
  error(title: "Erro", content: "Um erro desconhecido ocorreu.", redirectToLogin: false); 

  const EResult({this.title, this.content, required this.redirectToLogin});

  final String? title, content;
  final bool redirectToLogin;

  Future<void> createAlert(
    BuildContext context,
    bool isDarkTheme, {
    String? title,
    String? content,
    List<Widget>? actions,
    MainAxisAlignment? actionsAlignment,
    bool? barrierDismissible,
  }) async {
    if (this.title == null && title == null) {
      return;
    }
    if (this.content == null && content == null) {
      return;
    }
    if (actions == null) {
      late void Function() buttonFunction;
      if (redirectToLogin) {
        buttonFunction = () {
          Navigator.pop(context);
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LoginPage(false)));
        };
      } else {
        buttonFunction = () {
          Navigator.pop(context);
        };
      }
      actions = [
        TextButton(
          onPressed: buttonFunction,
          child: Text(
            "Ok",
            style: TextStyle(
              color: isDarkTheme ? MyColors.brightPrimary : MyColors.primary,
              fontSize: 22.0,
            ),
          ),
        )
      ];
    }
    barrierDismissible ??= true;
    await alert(
      context,
      title ?? this.title!,
      content ?? this.content!,
      actions,
      isDarkTheme,
      actionsAlignment: actionsAlignment,
      dismissible: barrierDismissible,
    );
  }

  static EResult fromResponseString(String response) {
    if (response.contains("User with id ") &&
        response.contains(" does not exist!")) {
      return EResult.noUserOnServer;
    }
    if (response.contains("The e-mail provided is already registered!")) {
      return EResult.userAlreadyRegistered;
    }
    if (response.contains("Invalid e-mail format!")) {
      return EResult.invalidEmailFormat;
    }
    if (response.contains("E-mail can't have more than 63 characters!")) {
      return EResult.emailTooLong;
    }
    if (response.contains("E-mail field can't be empty!")) {
      return EResult.emptyEmail;
    }
    if (response.contains("Username field can't be empty!")) {
      return EResult.emptyUsername;
    }
    if (response.contains("Password must have at least 8 characters!")) {
      return EResult.passwordTooShort;
    }
    if (response.contains("Password can't have more than 63 characters!")) {
      return EResult.passwordTooLong;
    }
    if (response.contains("Username can't have more than 63 characters!")) {
      return EResult.usernameTooLong;
    }
    if (response.contains("Internal server error")) {
      return EResult.internalServerError;
    }
    if (response.contains("Invalid email or password")) {
      return EResult.invalidEmailOrPassword;
    }
    if (response.contains("Unauthorized")) {
      return EResult.unauthorized;
    }
    return EResult.error;
  }
}
