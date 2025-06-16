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
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _loadProgress();
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment:
                (loaded ? MainAxisAlignment.start : MainAxisAlignment.center),
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _buildExerciseButtons(ESubject.values[pageIndex]),
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
    switch (pageIndex){
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
      // labelTextStyle: WidgetStateProperty.fromMap({
      //   WidgetStatesConstraint.: TextStyle(),
      // }),
      selectedIndex: pageIndex,
      destinations: [
        NavigationDestination(
          selectedIcon: Image(
            image: AssetImage("assets/imgs/icones-em-roxo/notaOutline.png"),
          ),
          icon: Image(
              image: AssetImage(isDarkMode
                  ? "assets/imgs/icones-em-cinza-claro/nota.png"
                  : "assets/imgs/icones-em-cinza/nota.png")),
          label: "Notas",
        ),
        NavigationDestination(
          selectedIcon: Image(
            image:
                AssetImage("assets/imgs/icones-em-roxo/intervalo.png"),
          ),
          icon: Image(
              image: AssetImage(
                  "assets/imgs/icones-em-cinza${isDarkMode ? '-claro' : ''}/intervalo.png")),
          label: "Intervalos",
        ),
        NavigationDestination(
          selectedIcon: Image(
            image: AssetImage("assets/imgs/icones-em-roxo/escala.png"),
          ),
          icon: Image(
              image: AssetImage(
                  "assets/imgs/icones-em-cinza${isDarkMode ? '-claro' : ''}/escala.png")),
          label: "Escalas",
        ),
        NavigationDestination(
          selectedIcon: Image(
            image: AssetImage("assets/imgs/icones-em-roxo/acorde.png"),
          ),
          icon: Image(
              image: AssetImage(
                  "assets/imgs/icones-em-cinza${isDarkMode ? '-claro' : ''}/acorde.png")),
          label: "Acordes",
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

  Future<void> _loadProgress() async {
    for (ESubject subject in ESubject.values) {
      _loadLessonData(subject);
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
                        MaterialPageRoute(
                            builder: (context) => LoginPage(false)),
                        (route) => false);
                  },
                  child: Text("Ok"),
                )
              ],
            ),
          );
        }
        return;
      }
      lessons[subject] = user.lessons;
      setState(() {});
    }
    loaded = true;
  }

  List<Widget> _buildExerciseButtons(ESubject subject) {
    if (!loaded) {
      return [
        SizedBox(
            child: Center(
                child: CircularProgressIndicator(
          color: MyColors.brightPrimary,
        )))
      ];
    }

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
