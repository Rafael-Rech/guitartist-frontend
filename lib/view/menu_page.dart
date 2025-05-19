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
import 'package:tcc/view/components/lesson_menu_button.dart';
import 'package:tcc/view/login_page.dart';
import 'package:tcc/view/settings_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key, required this.subject});

  final ESubject subject;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<LessonData> lessonData = [];
  List<Lesson> lessons = [];
  bool loaded = false;
  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
            icon: Icon(Icons.settings),
          )
        ],
        backgroundColor: MyColors.main5,
        centerTitle: true,
        title: Text(
          widget.subject.description.toUpperCase(),
          style: TextStyle(color: MyColors.neutral2),
        ),
        actionsIconTheme: IconThemeData(color: MyColors.neutral2),
        iconTheme: IconThemeData(color: MyColors.neutral2),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment:
                (loaded ? MainAxisAlignment.start : MainAxisAlignment.center),
            crossAxisAlignment: CrossAxisAlignment.center,
            children: buildExerciseButtons(),
          ),
        ),
      ),
    );
  }

  void _loadLessonData() {
    switch (widget.subject) {
      case ESubject.note:
        lessonData = NoteLessons().lessons;
        break;
      case ESubject.chord:
        lessonData = ChordLessons().lessons;
        break;
      case ESubject.scale:
        lessonData = ScaleLessons().lessons;
        break;
      case ESubject.interval:
        lessonData = IntervalLessons().lessons;
        break;
    }
  }

  void _loadProgress() async {
    _loadLessonData();
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
      return;
    }
    lessons = user.lessons;
    loaded = true;
    setState(() {});
  }

  List<Widget> buildExerciseButtons() {
    if (!loaded) {
      return [
        SizedBox(
            child: Center(
                child: CircularProgressIndicator(
          color: MyColors.main7,
        )))
      ];
    }

    List<Widget> buttons = [];

    String lastId = "";

    for (int i = 0; i < lessonData.length; i++) {
      final data = lessonData[i];
      Lesson? lastLessonProgress;
      Lesson? currentLessonProgress;
      for (Lesson progress in lessons) {
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
        lessonName: data.name,
        lessonId: data.id,
        width: MediaQuery.of(context).size.width * 0.8,
        locked: ((i != 0) &&
            (lastLessonProgress == null ||
                lastLessonProgress.proficiency < 70)),
        subject: widget.subject,
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
