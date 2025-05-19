import 'package:flutter/material.dart';
import 'package:tcc/global/my_colors.dart';
import 'package:tcc/service/user_service.dart';
import 'package:tcc/view/home_page.dart';
import 'package:tcc/view/login_page.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  List<SizedBox>? bottomSheetContent;
  Container? bottomSheet;

  @override
  void initState() {
    super.initState();

    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Image(
                  image: AssetImage("assets/imgs/mainIcon.png"),
                  width: 150,
                  height: 150,
                ),
                Text(
                  "Guitartist",
                  style: TextStyle(
                    color: Color.fromARGB(255, 217, 68, 99),
                    fontSize: 30.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Memorize a teoria. Vá além na guitarra.",
              style: TextStyle(color: MyColors.neutral7, fontSize: 22.0),
            ),
          ],
        ),
      ),
      bottomSheet: bottomSheet,
    );
  }

  void checkLogin() async {
    if (await getUserFromServer()) {
      if (mounted) {
        Navigator.of(context).push(_createAnimatedRoute(HomePage()));
      }
      setState(() {
        bottomSheet = null;
        bottomSheetContent = null;
      });
    } else {
      setState(() {
        bottomSheetContent = [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(_createAnimatedRoute(LoginPage(false)));
              },
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Color.fromARGB(255, 217, 68, 99),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              child: const Text(
                "LOGIN",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(_createAnimatedRoute(LoginPage(true)));
              },
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Color.fromARGB(255, 217, 68, 99),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              child: const Text(
                "REGISTRO",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20)
        ];

        if (context.mounted) {
          bottomSheet = Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: bottomSheetContent!,
            ),
          );
        }
      });
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
