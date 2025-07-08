import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tcc/global/alerts.dart';
import 'package:tcc/global/e_result.dart';
import 'package:tcc/global/my_colors.dart';
import 'package:tcc/helper/token_helper.dart';
import 'package:tcc/helper/user_helper.dart';
import 'package:tcc/model/lesson.dart';
import 'package:tcc/model/user.dart';
import 'package:tcc/service/user_service.dart';
import 'package:tcc/view/change_password_page.dart';
import 'package:tcc/view/components/my_horizontal_button.dart';
import 'package:tcc/view/components/my_text_field.dart';
import 'package:tcc/view/splash_screen_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late final User? user;
  String name = "";
  String email = "";

  int lessonsCompleted = 0;
  final int totalLessons = 10 + 12 + 7 + 8;
  int totalPrecision = 0;

  TextEditingController nameController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  String? nameErrorText;

  late bool isDarkMode;
  late double screenHeight;
  late double screenWidth;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    // getInfo();
  }

  @override
  Widget build(BuildContext context) {
    theme = AdaptiveTheme.of(context).theme;
    isDarkMode = theme.brightness == Brightness.dark;

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    final double buttonHeight = 0.11 * screenHeight;

    return GestureDetector(
      onTap: () async {
        if (nameFocusNode.hasFocus) {
          FocusScope.of(context).unfocus();
          await changeName(nameController.text);
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.2 * screenHeight),
          // preferredSize: Size.fromHeight(0.266 * screenHeight),
          child: _generateAppBar(),
        ),
        backgroundColor: theme.colorScheme.surface,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 0.03 * screenHeight),
                Container(
                  width: 0.9395 * screenWidth,
                  height: 0.2607 * screenHeight,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: isDarkMode
                          ? MyColors.brightPrimary
                          : MyColors.primary),
                  child: FutureBuilder(
                    future: getInfo(),
                    builder: (context, snapshot) {
                      if (!(snapshot.connectionState == ConnectionState.done)) {
                        return SizedBox(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: MyColors.light,
                            ),
                          ),
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 0.427 * screenWidth,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Lições completas",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    fontSize: 30.0,
                                    color: MyColors.light,
                                  ),
                                ),
                                CircularPercentIndicator(
                                  radius: 60.0,
                                  lineWidth: 10.0,
                                  percent: lessonsCompleted / totalLessons,
                                  animation: true,
                                  progressColor: MyColors.light,
                                  arcType: ArcType.FULL,
                                  arcBackgroundColor: isDarkMode
                                      ? MyColors.darkPrimary
                                      : MyColors.darkestPrimary,
                                  center: AutoSizeText(
                                    "$lessonsCompleted/$totalLessons",
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      color: MyColors.light,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          VerticalDivider(
                            thickness: 7.0,
                            color: MyColors.light,
                            indent: 10.0,
                            endIndent: 10.0,
                          ),
                          SizedBox(
                            width: 0.427 * screenWidth,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Precisão média",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    fontSize: 30.0,
                                    color: MyColors.light,
                                  ),
                                ),
                                CircularPercentIndicator(
                                  radius: 60.0,
                                  lineWidth: 10.0,
                                  percent: totalPrecision / 100,
                                  animation: true,
                                  progressColor: MyColors.light,
                                  arcType: ArcType.FULL,
                                  arcBackgroundColor: isDarkMode
                                      ? MyColors.darkPrimary
                                      : MyColors.darkestPrimary,
                                  center: AutoSizeText(
                                    "$totalPrecision%",
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      color: MyColors.light,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                SizedBox(
                  height: 0.05 * screenHeight,
                ),

                MyHorizontalButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangePasswordPage()));
                  },
                  text: "Alterar senha",
                  height: buttonHeight,
                  width: 0.9395 * screenWidth,
                  useGradient: true,
                  mainColor: MyColors.darkPrimary,
                  fontFamily: "Archivo Narrow",
                  fontSize: 50.0,
                  secondaryColor: MyColors.brightPrimary,
                  textColor: MyColors.light,
                ),
                SizedBox(
                  height: 0.025 * screenHeight,
                ),

                MyHorizontalButton(
                  onPressed: () async {
                    await alert(
                      context,
                      "Sair?",
                      "Você tem certeza que deseja sair? Você precisará fazer login novamente para continuar usando o app.",
                      [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancelar",
                            style: TextStyle(
                              color:
                                  isDarkMode ? MyColors.gray5 : MyColors.gray1,
                              fontSize: 22.0,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: logout,
                          child: Text(
                            "Sair",
                            style: TextStyle(
                              color: isDarkMode
                                  ? MyColors.light
                                  : MyColors.primary,
                              fontSize: 22.0,
                            ),
                          ),
                        ),
                      ],
                      isDarkMode,
                      actionsAlignment: MainAxisAlignment.end,
                    );
                  },
                  text: "Sair",
                  height: buttonHeight,
                  width: 0.9395 * screenWidth,
                  useGradient: true,
                  mainColor: MyColors.darkPrimary,
                  fontFamily: "Archivo Narrow",
                  fontSize: 50.0,
                  secondaryColor: MyColors.brightPrimary,
                  textColor: MyColors.light,
                ),
                SizedBox(
                  height: 0.025 * screenHeight,
                ),

                MyHorizontalButton(
                  onPressed: () async {
                    await alert(
                      context,
                      "Você tem certeza?",
                      "Esta opção irá deletar a sua conta e todos os dados associados a ela. Não é possível recuperá-la. Você deseja mesmo continuar?",
                      [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancelar",
                            style: TextStyle(
                              color:
                                  isDarkMode ? MyColors.gray5 : MyColors.gray1,
                              fontSize: 22.0,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: deleteAccount,
                          child: Text(
                            "Excluir",
                            style: TextStyle(
                              color: theme.colorScheme.error,
                              fontSize: 22.0,
                            ),
                          ),
                        ),
                      ],
                      isDarkMode,
                      actionsAlignment: MainAxisAlignment.end,
                      dismissible: true,
                    );
                  },
                  text: "Excluir conta",
                  height: buttonHeight,
                  width: 0.9395 * screenWidth,
                  useGradient: false,
                  mainColor: isDarkMode ? MyColors.gray3 : MyColors.light,
                  borderColor: isDarkMode ? null : MyColors.primary,
                  borderWidth: isDarkMode ? 0.0 : 5.0,
                  fontFamily: "Archivo Narrow",
                  fontSize: 50.0,
                  textColor: isDarkMode ? MyColors.light : MyColors.primary,
                ),
                SizedBox(height: 0.03 * screenHeight),
              ],
            ),
          ),
        ),
      ),
    );
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
        child: FutureBuilder(
          future: getInfo(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container();
            }
            return Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Stack(
                children: [
                  Positioned(
                    left: 0.1,
                    bottom: 0.1,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 0.8 * screenWidth,
                              child: MyTextField(
                                textColor: isDarkMode? MyColors.light : MyColors.dark,
                                controller: nameController,
                                border: InputBorder.none,
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
                            Text(
                              email,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: isDarkMode
                                      ? MyColors.gray5
                                      : MyColors.gray1,
                                  fontFamily: "Inter",
                                  fontStyle: FontStyle.italic,
                                  fontSize: 22.0),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            nameFocusNode.requestFocus();
                          },
                          // icon: Icon(Icons.edit),
                          icon: Icon(
                            Icons.edit_square,
                            color: isDarkMode ? MyColors.gray5 : MyColors.dark,
                          ),
                          iconSize: MediaQuery.of(context).size.width * 0.15,
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> logout() async {
    showDialog(
        context: context,
        builder: (context) => Center(
            child: Center(
                child: CircularProgressIndicator(color: MyColors.primary))),
        barrierDismissible: false);
    await UserHelper.deleteUser();
    await TokenHelper.internal().deleteToken();
    if (mounted) {
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SplashScreenPage()));
    }
  }

  Future<void> deleteAccount() async {
    showDialog(
        context: context,
        builder: (context) =>
            Center(child: CircularProgressIndicator(color: MyColors.primary)),
        barrierDismissible: false);
    final EResult result = await delete();
    if (result == EResult.ok) {
      await logout();
      // } else if (result == "Servidor inalcançável") {
      //   if (mounted) {
      //     showDialog(
      //       context: context,
      //       builder: (context) => AlertDialog(
      //         title: Text("NÃO FOI POSSÍVEL ALCANÇAR O SERVIDOR"),
      //         content: Text(
      //             "Verifique a conexão com a internet ou tente novamente mais tarde."),
      //         actions: [
      //           TextButton(
      //             onPressed: () {
      //               Navigator.pop(context);
      //             },
      //             child: Text("OK"),
      //           )
      //         ],
      //       ),
      //     );
      //   }
      // } else {
      //   if (mounted) {
      //     showDialog(
      //       context: context,
      //       builder: (context) => AlertDialog(
      //         title: Text("OCORREU UM ERRO AO EXCLUIR A CONTA"),
      //         content: Text("Tente novamente mais tarde."),
      //         actions: [
      //           TextButton(
      //             onPressed: () {
      //               Navigator.pop(context);
      //             },
      //             child: Text("OK"),
      //           )
      //         ],
      //       ),
      //     );
      //   }
    } else {
      if (mounted) {
        await result.createAlert(context, isDarkMode);
      }
    }
  }

  Future<void> changeName(String name) async {
    if (name.isNotEmpty && name.length < 64) {
      setState(() {
        nameErrorText = null;
      });
      user!.name = name;

      final EResult result = await update(user!);
      if (result == EResult.ok) {
        await UserHelper.saveUser(user!);
      } else {
        if (mounted) {
          await result.createAlert(context, isDarkMode);
        }
      }
    } else if (name.isEmpty) {
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
        for (Lesson l in user!.lessons) {
          if (l.proficiency >= 80) {
            lessonsCompleted++;
          }
          totalPrecision += l.averagePrecision;
        }
        totalPrecision ~/= user!.lessons.length;
      });
    } else {
      if (mounted) {
        await EResult.noUser.createAlert(context, isDarkMode);
      }
    }
  }
}
