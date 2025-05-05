import 'package:flutter/material.dart';
import 'package:tcc/global/my_colors.dart';
import 'package:tcc/helper/token_helper.dart';
import 'package:tcc/helper/user_helper.dart';
import 'package:tcc/model/user.dart';
import 'package:tcc/service/user_service.dart';
import 'package:tcc/view/change_password_page.dart';
import 'package:tcc/view/components/my_text_button.dart';
import 'package:tcc/view/components/my_text_field.dart';
import 'package:tcc/view/initial_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late final User? user;
  String name = "";
  String email = "";

  TextEditingController nameController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  String? nameErrorText;

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.main5,
      ),
      backgroundColor: MyColors.main5,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                color: MyColors.main5,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.account_circle,
                        size: MediaQuery.of(context).size.width * 0.7),
                    const SizedBox(height: 5.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: MyTextField(
                              controller: nameController,
                              errorText: nameErrorText,
                              errorStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                              fontSize: 30.0,
                              focusNode: nameFocusNode,
                              onSubmitted: (value) async {
                                await changeName(value);
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              nameFocusNode.requestFocus();
                            },
                            icon: Icon(Icons.edit),
                            iconSize: MediaQuery.of(context).size.width * 0.1,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      email,
                      style: TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 24.0),
                    ),
                    const SizedBox(height: 5.0),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Column(
                  children: [
                    const SizedBox(height: 25.0),
                    MyTextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ChangePasswordPage()));
                      },
                      text: "Mudar senha",
                      textColor: MyColors.neutral6,
                      fontSize: 26.0,
                      borderColor: MyColors.main5,
                      borderWidth: 2.0,
                      icon: Icon(
                        Icons.lock_reset,
                        color: Colors.black,
                        size: 30.0,
                      ),
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                    const SizedBox(height: 25.0),
                    MyTextButton(
                      onPressed: () async => await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title:
                              const Text("Você tem certeza que deseja sair?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "Cancelar",
                                style: TextStyle(color: MyColors.neutral7),
                              ),
                            ),
                            TextButton(
                              onPressed: logout,
                              child: Text(
                                "Sim",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                      text: "Sair",
                      textColor: MyColors.neutral6,
                      borderColor: MyColors.main5,
                      fontSize: 26.0,
                      borderWidth: 2.0,
                      icon: Icon(
                        Icons.logout,
                        color: Colors.black,
                        size: 30.0,
                      ),
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                    const SizedBox(height: 25.0),
                    MyTextButton(
                      onPressed: () async => await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Você tem certeza?"),
                          content: Text(
                              "Esta opção irá deletar a sua conta e todos os dados associados a ela. Não é possível recuperá-la. Você deseja continuar?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "Cancelar",
                                style: TextStyle(color: MyColors.secondary7),
                              ),
                            ),
                            TextButton(
                              onPressed: deleteAccount,
                              child: Text(
                                "Sim",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                      text: "Excluir conta",
                      textColor: MyColors.neutral2,
                      fontSize: 26.0,
                      backgroundColor: MyColors.main6,
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.black,
                        size: 30.0,
                      ),
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout() async {
    showDialog(
        context: context,
        builder: (context) => Center(
            child: Center(
                child: CircularProgressIndicator(color: MyColors.main7))),
        barrierDismissible: false);
    await UserHelper.deleteUser();
    await TokenHelper.internal().deleteToken();
    if (mounted) {
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const InitialPage()));
    }
  }

  Future<void> deleteAccount() async {
    showDialog(
        context: context,
        builder: (context) =>
            Center(child: CircularProgressIndicator(color: MyColors.main7)),
        barrierDismissible: false);
    final result = await delete();
    if (result == "DELETED") {
      await logout();
    } else if (result == "Servidor inalcançável") {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("NÃO FOI POSSÍVEL ALCANÇAR O SERVIDOR"),
            content: Text(
                "Verifique a conexão com a internet ou tente novamente mais tarde."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              )
            ],
          ),
        );
      }
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("OCORREU UM ERRO AO EXCLUIR A CONTA"),
            content: Text("Tente novamente mais tarde."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              )
            ],
          ),
        );
      }
    }
  }

  Future<void> changeName(String name) async {
    if (name.isNotEmpty && name.length < 64) {
      setState(() {
        nameErrorText = null;
      });
      user!.name = name;

      final result = await update(user!);
      if (result == "OK") {
        await UserHelper.saveUser(user!);
      }
    } else if (name.isEmpty){
      setState(() {
        nameErrorText = "O nome de usuário\nnão pode ser vazio!";
      });
    } else {
      setState(() {
        nameErrorText = "Insira um nome com\nmenos de 64 caracteres!";
      });
    }
  }

  Future<void> getInfo() async {
    user = await UserHelper.getUser();
    if (user != null) {
      setState(() {
        name = user!.name;
        email = user!.email;
        nameController = TextEditingController(text: name);
      });
    } else {
      //Tela de erro?
    }
  }
}
