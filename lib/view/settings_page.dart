import 'package:flutter/material.dart';
import 'package:tcc/global/my_colors.dart';
import 'package:tcc/global/theme.dart';
import 'package:tcc/helper/user_helper.dart';
import 'package:tcc/model/user.dart';
import 'package:tcc/service/user_service.dart';
import 'package:tcc/view/components/my_horizontal_button.dart';
import 'package:tcc/view/components/my_text_button.dart';
import 'package:tcc/view/login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // final List<MyTextButton> _representationButtons = [];
  final List<MyHorizontalButton> _representationButtons = [];

  late ThemeData theme;
  late bool isDarkMode;

  late double screenWidth;
  late double screenHeight;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    theme = Theme.of(context);
    isDarkMode = theme.brightness == Brightness.dark;

    List<Widget> buttonsWithSizedBoxes = [];

    for (MyHorizontalButton button in _representationButtons) {
      buttonsWithSizedBoxes.add(button);
      buttonsWithSizedBoxes.add(SizedBox(
        height: 10.0,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: _generateAppBarColors(),
            ),
          ),
        ),
        title: Text(
          "Configurações",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 40.0,
            color: isDarkMode ? MyColors.light : MyColors.dark,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: FutureBuilder(
          future: _generateRepresentationButtons(),
          builder: (context, snapshot) {
            if (!(snapshot.hasData)) { 
            // if (!(snapshot.connectionState == ConnectionState.done)) { 
              return Center(
                child: CircularProgressIndicator(color: MyColors.brightPrimary),
              );
            }
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                        Text(
                          "Tema",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 50.0,
                            fontFamily: "Inter",
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _generateThemeButton(true, !isDarkMode),
                            _generateThemeButton(false, isDarkMode),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(
                            height: 50.0,
                            color: isDarkMode
                                ? MyColors.brightPrimary
                                : MyColors.primary,
                            thickness: 5.0,
                          ),
                        ),
                        Text(
                          "Representação das notas",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 50.0,
                            fontFamily: "Inter",
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                      ] +
                      (buttonsWithSizedBoxes),
                ),
              ),
            );
          }),
    );
  }

  List<Color> _generateAppBarColors() {
    List<Color> colors = [MyColors.brightPrimary, MyColors.brightestPrimary];
    if (isDarkMode) {
      colors = List.from(colors.reversed);
    }
    return colors;
  }

  void changeTheme() {}

  Widget _generateThemeButton(bool sunIcon, bool active) {
    return GestureDetector(
      onTap: () {
        if (active) {
          changeTheme();
        }
      },
      child: Container(
        width: screenWidth * 0.4,
        height: screenWidth * 0.4,
        decoration: BoxDecoration(
          color: null,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(
            color: active
                ? MyColors.brightPrimary
                : (sunIcon ? MyColors.gray4 : MyColors.gray3),
            width: 10.0,
          ),
        ),
        child: Icon(
          sunIcon ? Icons.light_mode : Icons.dark_mode,
          size: screenWidth * 0.25,
          color: active
              ? MyColors.brightPrimary
              : (sunIcon ? MyColors.gray4 : MyColors.gray3),
        ),
      ),
    );
  }

  Future<bool> _generateRepresentationButtons({int? highlightedButton}) async {
    final representations = <String>["C D E F G A B", "Dó Ré Mi Fá Sol Lá Si"];

    _representationButtons.clear();

    if (highlightedButton == null) {
      User? user = await UserHelper.getUser();
      if (user != null) {
        highlightedButton = user.noteRepresentation;
      } else if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Ocorreu um erro ao obter informações"),
            content: Text("Você será redirecionado para a tela de login"),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage(false)),
                      (Route<dynamic> route) => false);
                },
                child: Text("Ok"),
              )
            ],
          ),
        );
      } else {
        return false;
      }
    }

    setState(() {
      for (int i = 0; i < representations.length; i++) {
        _representationButtons.add(
          // MyTextButton(
          //   onPressed: () {
          //     _changeRepresentation(i);
          //   },
          //   text: representations[i],
          //   width: MediaQuery.of(context).size.width * 0.75,
          //   textColor: Colors.black,
          //   fontSize: 26.0,
          //   borderColor:
          //       (i == highlightedButton) ? MyColors.main5 : MyColors.neutral6,
          //   borderWidth: 2.0,
          //   backgroundColor: MyColors.neutral1,
          //   icon: (i == highlightedButton) ? Icon(Icons.check) : null,
          // ),
          MyHorizontalButton(
            onPressed: () {
              _changeRepresentation(i);
            },
            text: representations[i],
            height: 0.1 * screenHeight,
            width: 0.939 * screenWidth,
            useGradient: i == highlightedButton,
            mainColor: i == highlightedButton
                ? MyColors.darkPrimary
                : (isDarkMode ? MyColors.gray3 : MyColors.light),
            secondaryColor:
                i == highlightedButton ? MyColors.brightPrimary : null,
            borderColor: MyColors.dark,
            borderWidth: 5.0,
            fontFamily: "Archivo Narrow",
            fontSize: 35.0,
            textColor: i != highlightedButton && !isDarkMode
                ? MyColors.primary
                : MyColors.light,
          ),
        );
      }
    });
    return true;
  }

  Future<void> _changeRepresentation(int representation) async {
    // showDialog(
    //     context: context,
    //     builder: (context) => Center(
    //         child: CircularProgressIndicator(color: MyColors.brightPrimary)),
    //     barrierDismissible: false);
    User? user = await UserHelper.getUser();

    if (user == null) {
      if (mounted) {
        // Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Ocorreu um erro ao atualizar as informações"),
            content: Text("Você será redirecionado para a tela de login"),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage(false)),
                      (Route<dynamic> route) => false);
                },
                child: Text("Ok"),
              )
            ],
          ),
        );
      } else {
        return;
      }
    }

    user!.noteRepresentation = representation;
    final String response = await update(user);
    if (response == "OK") {
      await UserHelper.saveUser(user);
    }
    // if (mounted) {
    //   Navigator.pop(context);
    // }

    await _generateRepresentationButtons(highlightedButton: representation);
  }
}
