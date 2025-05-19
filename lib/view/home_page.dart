import 'package:flutter/material.dart';
import 'package:tcc/global/my_colors.dart';
import 'package:tcc/model/Enum/e_subject.dart';
import 'package:tcc/view/account_page.dart';
import 'package:tcc/view/components/main_menu_option.dart';
import 'package:tcc/view/menu_page.dart';
import 'package:tcc/view/metronome_page.dart';
import 'package:tcc/view/settings_page.dart';
import 'package:tcc/view/tuner_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 217, 68, 99),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountPage()),
              );
            },
            icon: Icon(Icons.person)),
        actions: [IconButton(icon: Icon(Icons.settings), onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
        },)],
        foregroundColor: MyColors.main1,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const MainMenuOption(
                      3,
                      optionImage: AssetImage("assets/imgs/nota.png"),
                      optionText: "Notas",
                      reverse: true,
                      route: MenuPage(
                        subject: ESubject.note,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const MainMenuOption(
                      3,
                      optionImage: AssetImage("assets/imgs/intervalo.png"),
                      optionText: "Intervalos",
                      reverse: false,
                      route: MenuPage(
                        subject: ESubject.interval,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const MainMenuOption(
                      3,
                      optionImage: AssetImage("assets/imgs/acorde.png"),
                      optionText: "Acordes",
                      reverse: true,
                      route: MenuPage(
                        subject: ESubject.chord,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const MainMenuOption(
                      3,
                      optionImage: AssetImage("assets/imgs/escala.png"),
                      optionText: "Escalas",
                      reverse: false,
                      route: MenuPage(
                        subject: ESubject.scale,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: MyColors.neutral6,
                      height: 2,
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.025,
                    ),
                    Text(
                      "Ferramentas",
                      style: TextStyle(color: MyColors.neutral6, fontSize: 30),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.025,
                    ),
                    Container(
                      color: MyColors.neutral6,
                      height: 2,
                      width: MediaQuery.of(context).size.width * 0.25,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const MainMenuOption(
                2,
                optionImage:
                    AssetImage("assets/imgs/metronomeIconOnlyBorder.png"),
                optionText: "Metrônomo",
                reverse: true,
                route: MetronomePage(),
              ),
              const SizedBox(
                height: 20,
              ),
              const MainMenuOption(
                2,
                optionImage: AssetImage("assets/imgs/tuningForkIcon.png"),
                optionText: "Afinador",
                reverse: false,
                route: TunerPage(),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
