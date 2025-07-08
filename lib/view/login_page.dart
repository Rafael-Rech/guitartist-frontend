import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcc/global/e_result.dart';
import 'package:tcc/global/my_colors.dart';
import 'package:tcc/service/user_service.dart';
import 'package:tcc/view/components/my_horizontal_button.dart';
import 'package:tcc/view/components/my_text_form_field.dart';
import 'package:tcc/view/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage(this.isRegistering, {super.key});

  final bool isRegistering;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final Text title;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late MyTextFormField usernameTextField;
  late MyTextFormField emailTextField;
  late MyTextFormField passwordTextField;

  final FocusNode usernameFocusnode = FocusNode();
  final FocusNode emailFocusnode = FocusNode();
  final FocusNode passwordFocusnode = FocusNode();

  late List<Widget> textFields;

  late Widget bottomSheet;

  late void Function()? mainButtonFunction;
  bool waitingForResponse = false;
  late List<Widget> columnChildren;

  bool passwordVisible = false;

  late double screenHeight;
  late double screenWidth;
  late bool isDarkMode;
  late ThemeData theme;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    theme = AdaptiveTheme.of(context).theme;
    isDarkMode = theme.brightness == Brightness.dark;

    _createInputs();

    columnChildren = [];

    for (Widget w in textFields) {
      columnChildren.add(w);
      // columnChildren.add(const SizedBox(height: 10));
    }

    columnChildren.addAll([
      SizedBox(height: 0.06 * screenHeight),
      MyHorizontalButton(
        height: 0.09 * screenHeight,
        // height: 0.08 * screenHeight,
        mainColor: MyColors.darkPrimary,
        secondaryColor: MyColors.brightPrimary,
        onPressed: mainButtonFunction,
        text: widget.isRegistering ? "Registrar" : "Login",
        useGradient: true,
        width: 0.79 * screenWidth,
        fontFamily: "Archivo Narrow",
        fontSize: 45.0,
        textColor: MyColors.light,
      ),
      SizedBox(height: 0.04 * screenHeight),
    ]);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [MyColors.darkPrimary, MyColors.brightestPrimary],
            ),
          ),
          child: Center(
            child: Container(
              width: 0.87 * screenWidth,
              height: (widget.isRegistering ? 0.77 : 0.72) * screenHeight,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                        SizedBox(height: 0.017 * screenHeight),
                        Container(
                          width: 0.29 * screenWidth,
                          height: 0.29 * screenWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(360),
                            color: MyColors.primary,
                          ),
                          child: Center(
                            child: Image(
                              image:
                                  AssetImage("assets/imgs/IconGuitartist.png"),
                              width: 0.13 * screenWidth,
                            ),
                          ),
                        ),
                        SizedBox(height: 0.017 * screenHeight),
                        _formTitle(),
                      ] +
                      columnChildren +
                      [_bottomText()],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _createInputs() {
    usernameTextField = _createFormField(
        "Nome", false, usernameController, usernameFocusnode, (value) {
      if (value == null || value.isEmpty) {
        return "Nome é um campo obrigatório!";
      }
      return null;
    }, TextInputType.name);

    emailTextField = _createFormField(
        "E-mail", false, emailController, emailFocusnode, (value) {
      if (value == null || value.isEmpty) {
        return "E-mail é um campo obrigatório!";
      }

      final RegExp regex = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

      if (!regex.hasMatch(value)) {
        return "Este e-mail não está no formato correto!";
      }

      return null;
    }, TextInputType.emailAddress);

    passwordTextField = _createFormField(
        "Senha", true, passwordController, passwordFocusnode, (value) {
      if (value == null || value.isEmpty) {
        return "Senha é um campo obrigatório!";
      }

      if (value.length < 8) {
        return "Sua senha deve ter no mínimo 8 caracteres!";
      }

      return null;
    }, TextInputType.visiblePassword);

    if (widget.isRegistering) {
      //Register
      textFields = [
        usernameTextField,
        SizedBox(height: screenHeight * 0.018),
        emailTextField,
        SizedBox(height: screenHeight * 0.018),
        passwordTextField,
      ];
      mainButtonFunction = registerFunction;
    } else {
      //Login
      textFields = [
        emailTextField,
        SizedBox(height: screenHeight * 0.018),
        passwordTextField,
      ];
      mainButtonFunction = loginFunction;
    }
  }

  Text _formTitle() {
    return Text(
      widget.isRegistering ? "Registro" : "Login",
      style: TextStyle(
        fontFamily: "Inter",
        fontWeight: FontWeight.normal,
        color: isDarkMode ? MyColors.light : MyColors.dark,
        fontSize: 40.0,
      ),
    );
  }

  MyTextFormField _createFormField(
      String labelText,
      bool useObscureText,
      TextEditingController controller,
      FocusNode focusNode,
      String? Function(String?)? validator,
      TextInputType keyboardType) {
    return MyTextFormField(
      labelText: labelText,
      fill: true,
      labelColor: isDarkMode ? MyColors.light : MyColors.gray1,
      obscureText: useObscureText ? !passwordVisible : null,
      isDarkMode: isDarkMode,
      textColor: isDarkMode? MyColors.light : MyColors.dark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: isDarkMode
              ? Color(0x00000000)
              // : MyColors.brightestPrimary,
              : MyColors.gray4,
          width: isDarkMode ? 0.0 : 3.0,
        ),
      ),
      controller: controller,
      focusNode: focusNode,
      fillColor: isDarkMode
          ? Color(0xFF666666)
          // : MyColors.gray4,
          : MyColors.light,
      validator: validator,
      sidePadding: 17.0,
      formatters: [LengthLimitingTextInputFormatter(63)],
      fontFamily: "Inter",
      keyboardType: keyboardType,
    );
  }

  Widget _bottomText() {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          (widget.isRegistering)
              ? "Já possui uma conta?"
              : "Não possui uma conta?",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
            fontFamily: "Roboto",
            color: isDarkMode? MyColors.light : MyColors.dark
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(!widget.isRegistering),
                ));
          },
          child: Text(
            widget.isRegistering ? "Entrar" : "Registre-se",
            style: TextStyle(
              color: isDarkMode ? Color(0xFF3B8EED) : Color(0xFF0E4C94),
              fontSize: 18.0,
              fontFamily: "Roboto",
            ),
          ),
        ),
      ],
    ));
  }

  Future<void> createAlert(
      String title, String content, List<Widget>? actions) async {
    if (actions != null && actions.isEmpty) {
      actions.add(TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("Ok"),
      ));
    }
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: actions,
        );
      },
    );
  }

  Future<void> loginFunction() async {
    if (waitingForResponse || !_formKey.currentState!.validate()) {
      return;
    }
    final String email = emailController.text;
    final String password = passwordController.text;
    waitingForResponse = true;
    showDialog(
        context: context,
        builder: (context) => Center(
                child: CircularProgressIndicator(
              color: MyColors.brightPrimary,
            )),
        barrierDismissible: false);

    final EResult loginResult = await login(email, password);
    if (loginResult == EResult.ok) {
      if (mounted) {
        waitingForResponse = false;
        Navigator.of(context).pop();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (Route<dynamic> route) => false);
      }
    } else {
      if (mounted) {
        waitingForResponse = false;
        Navigator.pop(context);
        await loginResult.createAlert(context, isDarkMode);
      }
    }
  }

  Future<void> registerFunction() async {
    if (waitingForResponse || !_formKey.currentState!.validate()) {
      return;
    }
    final String username = usernameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    waitingForResponse = true;
    showDialog(
        context: context,
        builder: (context) => Center(
            child: CircularProgressIndicator(color: MyColors.brightPrimary)),
        barrierDismissible: false);

    final EResult registerResult = await register(username, email, password);
    if (registerResult == EResult.ok) {
      if (mounted) {
        waitingForResponse = false;
        Navigator.of(context).pop();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (Route<dynamic> route) => false);
      }
    } else {
      if (mounted) {
        waitingForResponse = false;
        // Navigator.of(context).pop();
        // return createAlert(
        //   "ERRO AO REGISTRAR USUÁRIO",
        //   /*"Tente novamente mais tarde"*/ registerResult,
        //   [
        //     TextButton(
        //         onPressed: () {
        //           Navigator.of(context).pop();
        //         },
        //         child: Text("Ok"))
        //   ],
        // );
        Navigator.pop(context);
        await registerResult.createAlert(context, isDarkMode);
      }
    }
  }
}
