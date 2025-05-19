import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcc/global/my_colors.dart';
import 'package:tcc/service/user_service.dart';
import 'package:tcc/view/components/my_text_button.dart';
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

  String mainButtonText = "";

  late Widget bottomSheet;

  late void Function()? mainButtonFunction;
  bool waitingForResponse = false;
  late List<Widget> columnChildren;

  bool passwordVisible = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    title = Text(
      (widget.isRegistering) ? "REGISTRO" : "LOGIN",
      style: TextStyle(
        color: MyColors.neutral2,
        fontSize: 26,
      ),
    );

    usernameTextField = MyTextFormField(
      labelText: "Nome de Usuário",
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: MyColors.secondary5, width: 2.0)),
      fillColor: MyColors.secondary2,
      controller: usernameController,
      focusNode: usernameFocusnode,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Nome é um campo obrigatório!";
        }
        return null;
      },
      sidePadding: 10.0,
      formatters: [LengthLimitingTextInputFormatter(63)],
      fontFamily: "Roboto",
      keyboardType: TextInputType.name,
    );

    emailTextField = MyTextFormField(
      labelText: "E-mail",
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: MyColors.secondary5, width: 2.0)),
      controller: emailController,
      fillColor: MyColors.secondary2,
      focusNode: emailFocusnode,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "E-mail é um campo obrigatório!";
        }

        final RegExp regex = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

        if (!regex.hasMatch(value)) {
          return "Este e-mail não está no formato correto!";
        }

        return null;
      },
      sidePadding: 10.0,
      formatters: [LengthLimitingTextInputFormatter(63)],
      fontFamily: "Roboto",
      keyboardType: TextInputType.emailAddress,
    );

    passwordTextField = MyTextFormField(
      labelText: "Senha",
      obscureText: !passwordVisible,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: MyColors.secondary5, width: 2.0)),
      controller: passwordController,
      focusNode: passwordFocusnode,
      fillColor: MyColors.secondary2,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Senha é um campo obrigatório!";
        }

        if (value.length < 8) {
          return "Sua senha deve ter no mínimo 8 caracteres!";
        }

        return null;
      },
      sidePadding: 10.0,
      formatters: [LengthLimitingTextInputFormatter(63)],
      fontFamily: "Roboto",
      keyboardType: TextInputType.visiblePassword,
    );

    bottomSheet = Container(
      color: MyColors.neutral1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20.0),
              Text(
                (widget.isRegistering)
                    ? "Já possui uma conta?"
                    : "Não possui uma conta?",
                style: TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 3.0),
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
                  style: TextStyle(color: Colors.blue, fontSize: 20.0),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ],
      ),
    );

    if (widget.isRegistering) {
      //Register
      textFields = [usernameTextField, emailTextField, passwordTextField];
      mainButtonText = "CRIAR CONTA";
      mainButtonFunction = registerFunction;
    } else {
      //Login
      textFields = [emailTextField, passwordTextField];
      mainButtonText = "ENTRAR";
      mainButtonFunction = loginFunction;
    }
  }

  @override
  Widget build(BuildContext context) {
    columnChildren = [
      Container(
        height: 80,
        color: MyColors.main5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage("assets/imgs/mainIconCropped.png"),
              fit: BoxFit.fitHeight,
            ),
            title,
          ],
        ),
      ),
      const SizedBox(height: 100),
    ];

    for (Widget w in textFields) {
      columnChildren.add(w);
      columnChildren.add(const SizedBox(height: 10));
    }

    columnChildren.add(
      MyTextButton(
        onPressed: mainButtonFunction,
        text: mainButtonText,
        textColor: MyColors.neutral5,
        borderColor: MyColors.main6,
        fontSize: 30,
        width: MediaQuery.of(context).size.width * 0.8,
        borderWidth: 4,
      ),
    );

    return Scaffold(
      backgroundColor: MyColors.neutral1,
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          children: columnChildren,
        ),
      )),

      bottomSheet: bottomSheet,
    );
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
              color: MyColors.main7,
            )),
        barrierDismissible: false);

    final String loginResult = await login(email, password);
    if (loginResult == "OK") {
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
        Navigator.of(context).pop();
        return showDialog<void>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Erro ao efetuar login"),
              content: Text(loginResult),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Ok"))
              ],
            );
          },
        );
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
        builder: (context) =>
            Center(child: CircularProgressIndicator(color: MyColors.main7)),
        barrierDismissible: false);

    final String registerResult = await register(username, email, password);
    if (registerResult == "CREATED") {
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
        Navigator.of(context).pop();
        return createAlert(
          "ERRO AO REGISTRAR USUÁRIO",
          /*"Tente novamente mais tarde"*/ registerResult,
          [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Ok"))
          ],
        );
      }
    }
  }
}
