import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:tcc/global/e_result.dart';
import 'package:tcc/global/my_colors.dart';
import 'package:tcc/helper/token_helper.dart';
import 'package:tcc/service/user_service.dart';
import 'package:tcc/view/components/my_horizontal_button.dart';
import 'package:tcc/view/home_page.dart';
import 'package:tcc/view/login_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  List<Widget>? bottomSheetContent;
  Container? bottomSheet;
  late double screenHeight;
  late double screenWidth;
  late ThemeData theme;
  late bool darkMode;

  @override
  void initState() {
    super.initState();

    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    theme = AdaptiveTheme.of(context).theme;
    darkMode = theme.brightness == Brightness.dark;

    final Image appNameImage = Image(
      image: AssetImage("assets/imgs/Guitartist.png"),
      width: 0.94 * screenWidth,
    );

    final imageHeight = 0.94 * screenWidth * 146 / 386;
    final remainingSpace = screenHeight -
        (0.28 * screenHeight) -
        imageHeight; // Total heigth - bottom sheet height - image height

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(children: [
        Positioned(
          top: remainingSpace / 2.0,
          left: (screenWidth - (0.94 * screenWidth)) / 2.0,
          child: appNameImage,
        )
      ]),
      bottomSheet: bottomSheet,
    );
  }

  List<Widget> generateBottomSheetContent() {
    final double buttonHeight = 0.115 * screenHeight;
    // final double buttonHeight = 0.1 * screenHeight;
    final double buttonWidth = 0.94 * screenWidth;
    final double buttonTextFontSize = 50.0;

    return [
      MyHorizontalButton(
        onPressed: () {
          // Navigator.of(context).push(_createAnimatedRoute(LoginPage(false)));
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LoginPage(false),
          ));
        },
        text: "Login",
        height: buttonHeight,
        width: buttonWidth,
        useGradient: true,
        mainColor: MyColors.darkPrimary,
        secondaryColor: MyColors.brightPrimary,
        borderWidth: 0,
        fontSize: buttonTextFontSize,
        textColor: MyColors.light,
      ),
      SizedBox(
        height: screenHeight * 0.02,
      ),
      MyHorizontalButton(
        onPressed: () {
          // Navigator.of(context).push(_createAnimatedRoute(LoginPage(true)));
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LoginPage(true),
          ));
        },
        text: "Registro",
        height: buttonHeight,
        width: buttonWidth,
        useGradient: false,
        mainColor: darkMode ? MyColors.gray3 : MyColors.light,
        borderWidth: darkMode ? 0 : 5,
        borderColor: darkMode ? null : MyColors.primary,
        fontSize: buttonTextFontSize,
        textColor: darkMode ? MyColors.light : MyColors.primary,
      ),
      SizedBox(
        height: screenHeight * 0.06,
      ),
    ];
  }

  void generateBottomSheet() {
    setState(() {
      bottomSheetContent = generateBottomSheetContent();

      if (context.mounted) {
        bottomSheet = Container(
          color: theme.colorScheme.surface,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: bottomSheetContent!,
          ),
        );
      }
    });
  }

  void checkLogin() async {
    for (int i = 0; i < 2; i++) {
      try {
        final EResult result = await getUserFromServer();
        if (result == EResult.ok) {
          if (mounted) {
            Navigator.of(context).push(_createAnimatedRoute(HomePage()));
          }
          setState(() {
            bottomSheet = null;
            bottomSheetContent = null;
          });
          i = 2;
        } else if (result == EResult.noUser ||
            result == EResult.noUserId ||
            result == EResult.noToken) {
          generateBottomSheet();
          i = 2;
        } else {
          if (mounted) {
            await result.createAlert(context, darkMode,
                actions: [
                  TextButton(
                    onPressed: () {
                      i--;
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Tentar novamente",
                      style: TextStyle(
                          color: darkMode
                              ? MyColors.light
                              : MyColors.primary,
                          fontSize: 22.0),
                    ),
                  )
                ],
                actionsAlignment: MainAxisAlignment.center,
                barrierDismissible: false);
          }
        }
      } on DatabaseException {
        TokenHelper().deleteDb();
        TokenHelper().initdb();
      } on Exception {
        TokenHelper().deleteDb();
        TokenHelper().initdb();
      }
    }
  }

  Route _createAnimatedRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;

        var curve = Curves.ease;
        var curveTween = CurveTween(curve: curve);

        final tween = Tween(begin: begin, end: end).chain(curveTween);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 1000),
    );
  }
}
