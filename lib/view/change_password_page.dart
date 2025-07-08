import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:tcc/global/alerts.dart';
import 'package:tcc/global/e_result.dart';
import 'package:tcc/global/my_colors.dart';
import 'package:tcc/helper/user_helper.dart';
import 'package:tcc/model/user.dart';
import 'package:tcc/service/user_service.dart';
import 'package:tcc/view/account_page.dart';
import 'package:tcc/view/components/my_horizontal_button.dart';
import 'package:tcc/view/components/my_text_field.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  bool changedPassword = false;
  String? passwordErrorText;

  late double screenHeight;
  late double screenWidth;

  late ThemeData theme;
  late bool isDarkMode;

  bool oldPasswordVisible = false, passwordVisible = false;

  double _inputsToButtonDistance = 0.0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    theme = AdaptiveTheme.of(context).theme;
    isDarkMode = theme.brightness == Brightness.dark;

    if (passwordErrorText == null) {
      _inputsToButtonDistance = 0.04 * screenHeight;
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.2 * screenHeight),
        child: _generateAppBar(),
      ),
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            height: 0.5 * screenHeight,
            width: 0.8744 * screenWidth,
            decoration: BoxDecoration(
              color: MyColors.primary,
              // color: isDarkMode ? MyColors.brightPrimary : MyColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 0.015 * screenHeight,
                ),
                SizedBox(
                  width: 0.7944 * screenWidth,
                  // width: 0.8744 * screenWidth,
                  child: Text(
                    "Insira sua senha atual",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 26.0,
                        fontFamily: "Inter",
                        color: MyColors.light),
                  ),
                ),
                MyTextField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !oldPasswordVisible,
                  controller: oldPasswordController,
                  sidePadding: 0.04 * screenWidth,
                  textColor: isDarkMode? MyColors.light : MyColors.dark,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: isDarkMode ? MyColors.gray2 : MyColors.gray4,
                        width: 3.0,
                      )),
                  fillColor: isDarkMode ? MyColors.gray4 : MyColors.light,
                  useFillColor: true,
                  isDarkMode: isDarkMode,
                ),
                SizedBox(
                  height: 0.025 * screenHeight,
                ),
                SizedBox(
                  width: 0.7944 * screenWidth,
                  // width: 0.8744 * screenWidth,
                  child: Text(
                    "Insira sua nova senha",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 26.0,
                        fontFamily: "Inter",
                        color: MyColors.light),
                  ),
                ),
                MyTextField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !passwordVisible,
                  controller: passwordController,
                  errorText: passwordErrorText,
                  textColor: isDarkMode? MyColors.light : MyColors.dark,
                  errorStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: MyColors.light,
                    fontSize: 20.0,
                    overflow: TextOverflow.clip,
                  ),
                  errorMaxLines: 2,
                  sidePadding: 0.04 * screenWidth,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: isDarkMode ? MyColors.gray2 : MyColors.gray4,
                        width: 3.0,
                      )),
                  fillColor: isDarkMode ? MyColors.gray4 : MyColors.light,
                  useFillColor: true,
                  isDarkMode: isDarkMode,
                ),
                SizedBox(
                  height: _inputsToButtonDistance,
                ),
                MyHorizontalButton(
                  onPressed: buttonFunction,
                  text: "Alterar senha",
                  height: 0.09 * screenHeight,
                  width: 0.7535 * screenWidth,
                  useGradient: isDarkMode,
                  mainColor: isDarkMode ? MyColors.darkPrimary : MyColors.light,
                  secondaryColor: isDarkMode ? MyColors.primary : null,
                  borderWidth: 5.0,
                  borderColor:
                      isDarkMode ? MyColors.darkestPrimary : MyColors.gray4,
                  fontFamily: "Archivo Narrow",
                  fontSize: 30.0,
                  textColor: isDarkMode ? MyColors.light : MyColors.primary,
                ),
                SizedBox(
                  height: 0.04 * screenHeight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<EResult> _verifyOldPassword() async {
    User? user = await UserHelper.getUser();
    if (user == null) {
      // if (mounted) {
      //   await EResult.noUser.createAlert(context, isDarkMode);
      // }
      // return false;
      return EResult.noUser;
    }
    String email = user.email;
    final EResult result = await login(email, oldPasswordController.text);
    // if (result != EResult.ok) {
    //   if (mounted) {
    //     await result.createAlert(
    //       context,
    //       isDarkMode,
    //     );
    //   }
    //   return false;
    // }
    // return true;
    return result;
  }

  Future<void> buttonFunction() async {
    if (!validate(passwordController.text)) {
      setState(() {
        passwordErrorText = "A senha deve conter entre 8 e 63 caracteres.";
        _inputsToButtonDistance = 0.0;
      });
      return;
    }

    setState(() {
      passwordErrorText = null;
    });
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(
                color: MyColors.brightPrimary,
              ),
            ),
        barrierDismissible: false);
    final EResult passwordVerification = await _verifyOldPassword();
    if (passwordVerification == EResult.invalidEmailOrPassword) {
      if (mounted) {
        await passwordVerification.createAlert(
            context,
            title: "Senha incorreta",
            content: "Confira sua senha atual e tente novamente.",
            isDarkMode);
      }
      if (mounted) {
        Navigator.pop(context);
      }
      return;
    } else if (passwordVerification != EResult.ok) {
      if (mounted) {
        await passwordVerification.createAlert(context, isDarkMode);
      }
      if (mounted) {
        Navigator.pop(context);
      }
      return;
    }

    // if (!(await _verifyOldPassword())) {
    //   if (mounted) {
    //     Navigator.pop(context);
    //     showDialog(
    //         context: context,
    //         builder: (context) =>
    //             AlertDialog(title: Text("Senha incorreta"), actions: [
    //               TextButton(
    //                   child: Text("Ok"),
    //                   onPressed: () {
    //                     Navigator.pop(context);
    //                   })
    //             ]));
    //   }

    //   return;
    // }
    if (mounted) {
      bool confirm = true;
      await alert(
          context,
          "Confirmação",
          "Você tem certeza de que deseja alterar sua senha?",
          [
            TextButton(
              onPressed: () {
                confirm = false;
                Navigator.pop(context);
              },
              child: Text(
                "Cancelar",
                style:
                    TextStyle(color: theme.colorScheme.error, fontSize: 22.0),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Alterar",
                style: TextStyle(color: MyColors.primary, fontSize: 22.0),
              ),
            ),
          ],
          isDarkMode,
          actionsAlignment: MainAxisAlignment.end,
          dismissible: false);
      if (!confirm) {
        if(mounted){
          Navigator.pop(context);
        }
        return;
      }
    }

    final EResult result = await changePassword(passwordController.text);
    if (mounted) {
      Navigator.pop(context);
    }
    if (result == EResult.ok) {
      // setState(() {
      //   changedPassword = true;
      // });
      if (mounted) {
        // showDialog(
        // context: context,
        // builder: (context) =>
        //     AlertDialog(title: Text("Senha alterada!"), actions: [
        //       TextButton(
        //           child: Text("Ok"),
        //           onPressed: () {
        //             Navigator.pop(context);
        //           })
        //     ]));
        await alert(
            context,
            "Senha alterada",
            "Sua senha foi alterada com sucesso",
            [
              TextButton(
                child: Text(
                  "Ok",
                  style: TextStyle(
                    color:
                        isDarkMode ? MyColors.light : MyColors.primary,
                    fontSize: 22.0,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AccountPage()));
                },
              )
            ],
            isDarkMode);
      }
    } else {
      if (mounted) {
        // showDialog(
        //     context: context,
        //     builder: (context) => AlertDialog(
        //           title: Text("ERRO AO ALTERAR SENHA"),
        //           content: Text(result),
        //           actions: [
        //             TextButton(
        //               onPressed: () {
        //                 Navigator.pop(context);
        //               },
        //               child: Text("OK"),
        //             )
        //           ],
        //         ));
        await result.createAlert(context, isDarkMode);
      }
    }
  }

  AppBar _generateAppBar() {
    List<Color> colors = [MyColors.primary, MyColors.brightestPrimary];
    if (isDarkMode) {
      colors = List.from(colors.reversed);
    }

    return AppBar(
      iconTheme:
          IconThemeData(color: isDarkMode ? MyColors.light : MyColors.dark),
      elevation: 5.0,
      flexibleSpace: Container(
        // height: screenHeight * 0.266,
        height: 300.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0.1,
              bottom: 0.1,
              child: Text(
                "Alterar senha",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 60.0,
                  fontFamily: "Inter",
                  color: isDarkMode ? MyColors.light : MyColors.dark,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool validate(String password) {
    return (password.length < 64 && password.length > 7);
  }
}
