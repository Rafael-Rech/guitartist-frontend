import 'package:flutter/material.dart';
import 'package:tcc/global/my_colors.dart';
import 'package:tcc/helper/user_helper.dart';
import 'package:tcc/model/user.dart';
import 'package:tcc/service/user_service.dart';
import 'package:tcc/view/components/my_text_button.dart';
import 'package:tcc/view/login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<MyTextButton> _representationButtons = [];

  @override
  void initState() {
    super.initState();
    generateRepresentationButtons();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttonsWithSizedBoxes = [];

    for (MyTextButton button in _representationButtons) {
      buttonsWithSizedBoxes.add(button);
      buttonsWithSizedBoxes.add(SizedBox(
        height: 10.0,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.main5,
        title: Text(
          "CONFIGURAÇÕES",
          style: TextStyle(color: MyColors.neutral2),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: MyColors.neutral2),
      ),
      backgroundColor: MyColors.neutral1,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
                  // Volume sliders
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text("Volume dos áudios dos exercícios"),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text("Volume do metrônomo"),
                  Divider(
                    height: 50.0,
                  ),
                  Text(
                    "Representação das notas",
                    style: TextStyle(fontSize: 26.0),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ] +
                // (_representationButtons),
                (buttonsWithSizedBoxes),
          ),
        ),
      ),
    );
  }

  Future<void> generateRepresentationButtons({int? highlightedButton}) async {
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
        return;
      }
    }

    setState(() {
      for (int i = 0; i < representations.length; i++) {
        _representationButtons.add(MyTextButton(
          onPressed: () {
            _changeRepresentation(i);
          },
          text: representations[i],
          width: MediaQuery.of(context).size.width * 0.75,
          textColor: Colors.black,
          fontSize: 26.0,
          borderColor:
              (i == highlightedButton) ? MyColors.main5 : MyColors.neutral6,
          borderWidth: 2.0,
          backgroundColor: MyColors.neutral1,
          icon: (i == highlightedButton) ? Icon(Icons.check) : null,
        ));
      }
    });
  }

  Future<void> _changeRepresentation(int representation) async {
    showDialog(
        context: context,
        builder: (context) =>
            Center(child: CircularProgressIndicator(color: MyColors.main7)),
        barrierDismissible: false);
    User? user = await UserHelper.getUser();

    if (user == null) {
      if (mounted) {
        Navigator.pop(context);
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
    if (mounted) {
      Navigator.pop(context);
    }

    await generateRepresentationButtons(highlightedButton: representation);
  }
}
