import 'package:flutter/material.dart';
import 'package:tcc/global/my_colors.dart';
import 'package:tcc/helper/user_helper.dart';
import 'package:tcc/model/Enum/e_subject.dart';
import 'package:tcc/model/lesson.dart';
import 'package:tcc/model/user.dart';
import 'package:tcc/music_theory_components/lesson_data/chord_lessons.dart';
import 'package:tcc/music_theory_components/lesson_data/interval_lessons.dart';
import 'package:tcc/music_theory_components/lesson_data/lesson_data.dart';
import 'package:tcc/music_theory_components/lesson_data/note_lessons.dart';
import 'package:tcc/music_theory_components/lesson_data/scale_lessons.dart';
import 'package:tcc/service/user_service.dart';
import 'package:tcc/view/account_page.dart';
import 'package:tcc/view/components/lesson_menu_button.dart';
import 'package:tcc/view/components/main_menu_option.dart';
import 'package:tcc/view/login_page.dart';
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
  int pageIndex = 0;
  late ThemeData theme;
  late bool isDarkMode;
  late double screenHeight;
  late double screenWidth;

  Map<ESubject, List<LessonData>> lessonData = {};
  Map<ESubject, List<Lesson>> lessons = {};

  Offset? movementStart;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    theme = Theme.of(context);
    isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.2 * screenHeight),
        // preferredSize: Size.fromHeight(0.266 * screenHeight),
        child: _generateAppBar(),
      ),
      backgroundColor: theme.colorScheme.surface,
      body: GestureDetector(
        onHorizontalDragStart: (details) {
          // print(details.localPosition);
          movementStart = details.localPosition;
        },
        onHorizontalDragEnd: (details) {
          // print(details.localPosition);
          if (movementStart != null) {
            if (movementStart!.dx < details.localPosition.dx && pageIndex > 0) {
              setState(() {
                pageIndex--;
              });
            } else if (movementStart!.dx > details.localPosition.dx &&
                pageIndex < 3) {
              setState(() {
                pageIndex++;
              });
            }
            movementStart = null;
          }
        },
        child: SingleChildScrollView(
          child: Center(
            child: FutureBuilder(
              future: _loadProgress(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  // if (!(snapshot.connectionState == ConnectionState.done)) {
                  print("No data");
                  return SizedBox(
                      child: Center(
                          child: CircularProgressIndicator(
                    color: MyColors.brightPrimary,
                  )));
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _buildExerciseButtons(ESubject.values[pageIndex]),
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: _generateBottomNavigationBar(),
    );
  }

  AppBar _generateAppBar() {
    List<Color> colors = [MyColors.primary, MyColors.brightestPrimary];
    if (isDarkMode) {
      colors = List.from(colors.reversed);
    }
    String title = "Notas";
    switch (pageIndex) {
      case 1:
        title = "Intervalos";
        break;
      case 2:
        title = "Escalas";
        break;
      case 3:
        title = "Acordes";
        break;
    }

    return AppBar(
      leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AccountPage()),
            );
          },
          icon: Icon(Icons.person)),
      actions: [
        IconButton(
          // iconSize: 100.0,
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingsPage()));
          },
        )
      ],
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
                title,
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

  NavigationBar _generateBottomNavigationBar() {
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          pageIndex = index;
        });
      },
      backgroundColor: isDarkMode ? MyColors.gray3 : MyColors.gray5,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          // return TextStyle(fontSize: 20.0, color: MyColors.brightestPrimary);
          return TextStyle(
              fontSize: 20.0,
              color: isDarkMode ? MyColors.light : MyColors.darkestPrimary);
        }
        return TextStyle(
            fontSize: 20.0,
            color: isDarkMode ? MyColors.gray5 : MyColors.gray2);
      }),
      height: 150.0,
      selectedIndex: pageIndex,
      indicatorColor: Color(0x00000000),
      labelPadding: EdgeInsets.only(top: 1.0),
      destinations: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: NavigationDestination(
            selectedIcon: Image(
              image: AssetImage("assets/imgs/icones-em-roxo/notaOutline.png"),
            ),
            icon: Image(
                image: AssetImage(isDarkMode
                    ? "assets/imgs/icones-em-cinza-claro/nota.png"
                    : "assets/imgs/icones-em-cinza/nota.png")),
            label: "Notas",
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: NavigationDestination(
            selectedIcon: Image(
              image:
                  AssetImage("assets/imgs/icones-em-roxo/intervaloOutline.png"),
            ),
            icon: Image(
                image: AssetImage(
                    "assets/imgs/icones-em-cinza${isDarkMode ? '-claro' : ''}/intervalo.png")),
            label: "Intervalos",
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: NavigationDestination(
            selectedIcon: Image(
              image: AssetImage("assets/imgs/icones-em-roxo/escalaOutline.png"),
            ),
            icon: Image(
                image: AssetImage(
                    "assets/imgs/icones-em-cinza${isDarkMode ? '-claro' : ''}/escala.png")),
            label: "Escalas",
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: NavigationDestination(
            selectedIcon: Image(
              image: AssetImage("assets/imgs/icones-em-roxo/acordeOutline.png"),
            ),
            icon: Image(
                image: AssetImage(
                    "assets/imgs/icones-em-cinza${isDarkMode ? '-claro' : ''}/acorde.png")),
            label: "Acordes",
          ),
        ),
      ],
    );
  }

  void _loadLessonData(ESubject subject) {
    switch (subject) {
      case ESubject.note:
        // lessonData = NoteLessons().lessons;
        lessonData[ESubject.note] = NoteLessons().lessons;
        break;
      case ESubject.chord:
        // lessonData = ChordLessons().lessons;
        lessonData[ESubject.chord] = ChordLessons().lessons;
        break;
      case ESubject.scale:
        // lessonData = ScaleLessons().lessons;
        lessonData[ESubject.scale] = ScaleLessons().lessons;
        break;
      case ESubject.interval:
        // lessonData = IntervalLessons().lessons;
        lessonData[ESubject.interval] = IntervalLessons().lessons;
        break;
    }
  }

  Future<bool> _loadProgress() async {
    print("Loading progress");
    await getUserFromServer();
    User? user = await UserHelper.getUser();
    if (user == null) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("ERRO AO CARREGAR LIÇÕES"),
            content: Text(
                "Ocorreu um erro ao carregar as lições. Você será redirecionado para a tela de login."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage(false)),
                      (route) => false);
                },
                child: Text("Ok"),
              )
            ],
          ),
        );
      }
      return false;
    }
    for (ESubject subject in ESubject.values) {
      _loadLessonData(subject);
      lessons[subject] = user.lessons;
      // setState(() {});
    }
    return true;
  }

  List<Widget> _buildExerciseButtons(ESubject subject) {
    List<Widget> buttons = [];

    String lastId = "";

    if (!lessonData.containsKey(subject) ||
        lessonData[subject] == null ||
        !lessons.containsKey(subject) ||
        lessons[subject] == null) {
      return [
        SizedBox(
            child: Center(
                child: CircularProgressIndicator(
          color: MyColors.brightPrimary,
        )))
      ];
    }

    for (int i = 0; i < lessonData[subject]!.length; i++) {
      final data = lessonData[subject]![i];
      Lesson? lastLessonProgress;
      Lesson? currentLessonProgress;
      for (Lesson progress in lessons[subject]!) {
        if (progress.id == lastId) {
          lastLessonProgress = progress;
        } else if (progress.id == data.id) {
          currentLessonProgress = progress;
        }
      }

      buttons.add(SizedBox(
        height: 20.0,
      ));

      buttons.add(LessonMenuButton(
        darkMode: isDarkMode,
        lessonName: data.name,
        lessonId: data.id,
        width: screenWidth * 0.9395,
        height: screenHeight * 0.105,
        locked: ((i != 0) &&
            (lastLessonProgress == null ||
                lastLessonProgress.proficiency < 70)),
        subject: subject,
        components: data.components,
        highlightedComponents: data.highlightedComponents,
        precision: (currentLessonProgress == null)
            ? 0
            : currentLessonProgress.averagePrecision,
        proficiency: (currentLessonProgress == null)
            ? 0
            : currentLessonProgress.proficiency,
        tries: (currentLessonProgress == null)
            ? 0
            : currentLessonProgress.numberOfTries,
      ));

      lastId = data.id;
    }

    buttons.add(SizedBox(
      height: 50.0,
    ));

    return buttons;
  }
}
