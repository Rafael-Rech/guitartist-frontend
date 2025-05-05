import 'package:flutter/material.dart';
import 'package:tcc/global/my_colors.dart';
import 'package:tcc/service/user_service.dart';
import 'package:tcc/view/components/my_text_button.dart';
import 'package:tcc/view/components/my_text_field.dart';
import 'package:tcc/view/home_page.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  bool changedPassword = false;
  String? passwordErrorText;

  @override
  Widget build(BuildContext context) {
    late Widget body;

    if (changedPassword) {
      body = Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Senha alterada com sucesso!",
              style: TextStyle(fontSize: 28.0),
            ),
            const SizedBox(height: 15.0),
            MyTextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (Route<dynamic> route) => false);
                },
                text: "Voltar ao início")
          ],
        ),
      );
    } else {
      body = Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyTextField(
                controller: passwordController,
                errorText: passwordErrorText,
                labelText: "Nova Senha",
                obscureText: true,
                sidePadding: 15.0,
              ),
              SizedBox(
                height: 15.0,
              ),
              MyTextButton(
                text: "Alterar",
                fontSize: 22.0,
                borderWidth: 2.0,
                borderColor: MyColors.main6,
                textColor: MyColors.neutral7,
                onPressed: () async {
                  if (validate(passwordController.text)) {
                    setState(() {
                      passwordErrorText = null;
                    });
                    showDialog(
                        context: context,
                        builder: (context) => Center(
                              child: CircularProgressIndicator(
                                color: MyColors.main7,
                              ),
                            ),
                        barrierDismissible: false);
                    final result =
                        await changePassword(passwordController.text);
                    if (mounted) {
                      Navigator.pop(context);
                    }
                    if (result == "OK") {
                      setState(() {
                        changedPassword = true;
                      });
                    } else {
                      if (mounted) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("ERRO AO ALTERAR SENHA"),
                                  content: Text(result),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("OK"),
                                    )
                                  ],
                                ));
                      }
                    }
                  } else {
                    setState(() {
                      passwordErrorText =
                          "A senha deve conter entre 8 e 63 caracteres.";
                    });
                  }
                },
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 217, 68, 99),
        title: Text("ALTERAR SENHA"),
        centerTitle: true,
        foregroundColor: MyColors.main1,
      ),
      body: body,
    );
  }

  bool validate(String password) {
    return (password.length < 64 && password.length > 7);
  }
}
