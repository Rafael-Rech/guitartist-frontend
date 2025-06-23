import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tcc/global/e_result.dart';
import 'package:tcc/global/my_colors.dart';
import 'package:tcc/helper/user_helper.dart';
import 'package:tcc/model/Enum/e_lesson_type.dart';
import 'package:tcc/model/Enum/e_subject.dart';
import 'package:tcc/model/user.dart';
import 'package:tcc/music_theory_components/exercise.dart';
import 'package:tcc/music_theory_components/exercise_builders/chord_exercise_builder.dart';
import 'package:tcc/music_theory_components/exercise_builders/exercise_builder.dart';
import 'package:tcc/music_theory_components/exercise_builders/interval_exercise_builder.dart';
import 'package:tcc/music_theory_components/exercise_builders/note_exercise_builder.dart';
import 'package:tcc/music_theory_components/exercise_builders/scale_exercise_builder.dart';
import 'package:tcc/view/components/my_horizontal_button.dart';
import 'package:tcc/view/exercise_page.dart';
import 'package:tcc/view/listening_exercise_page.dart';
import 'package:tcc/view/login_page.dart';
import 'package:tcc/view/quiz_exercise_page.dart';

class LessonInfoPage extends StatefulWidget {
  const LessonInfoPage({
    super.key,
    required this.lessonName,
    required this.lessonId,
    required this.subject,
    required this.components,
    required this.highlightedComponents,
    required this.precision,
    required this.tries,
    required this.proficiency,
  });

  final String lessonName;
  final String lessonId;
  final ESubject subject;
  final List<int> components;
  final List<int> highlightedComponents;
  final int precision;
  final int tries;
  final int proficiency;

  @override
  State<LessonInfoPage> createState() => _LessonInfoPageState();
}

class _LessonInfoPageState extends State<LessonInfoPage> {
  late double screenWidth;
  late double screenHeight;
  late ThemeData theme;
  late bool isDarkMode;

  final int numberOfExercisesPerLesson = 5;
  // final int numberOfExercisesPerLesson = 15;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    theme = AdaptiveTheme.of(context).theme;
    isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          widget.lessonName,
          style: TextStyle(fontFamily: "Inter", fontSize: 40.0, color: isDarkMode? MyColors.light : MyColors.dark),
          maxLines: 1,
        ),
        iconTheme: IconThemeData(color: isDarkMode? MyColors.light : MyColors.dark),
        centerTitle: true,
        actions: [],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: _generateAppBarColors(),
            ),
          ),
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Precisão",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 40.0,
                color: isDarkMode ? MyColors.light : MyColors.dark,
              ),
            ),
            _generatePercentIndicator(widget.precision),
            SizedBox(height: 0.025 * screenHeight),
            Text(
              "Proficiência",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Inter",
                color: isDarkMode ? MyColors.light : MyColors.dark,
                fontSize: 40.0,
              ),
            ),
            _generatePercentIndicator(widget.proficiency),
            SizedBox(height: 0.052 * screenHeight),
            _generateButton("Lição de Quiz", () {
              goToLesson(ELessonType.quiz);
            }),
            SizedBox(height: 0.019 * screenHeight),
            _generateButton("Lição de Áudio", () {
              goToLesson(ELessonType.listening);
            }),
            SizedBox(height: 0.0579 * screenHeight)
          ],
        ),
      ),
    );
  }

  void goToLesson(ELessonType lessonType) async {
    final List<Exercise> lesson = await _generateLesson(lessonType);
    if (lesson.isEmpty) {
      throw Exception("Empty lesson");
    }
    ExercisePage? page;
    switch (lessonType) {
      case ELessonType.listening:
        page = ListeningExercisePage(
          widget.lessonId,
          lesson,
          0,
          answersProvided: 0,
          correctAnswersProvided: 0,
          timeSpent: Duration(),
          subject: widget.subject,
        );
        break;
      case ELessonType.quiz:
        page = QuizExercisePage(
          widget.lessonId,
          lesson,
          0,
          answersProvided: 0,
          correctAnswersProvided: 0,
          timeSpent: Duration(),
          subject: widget.subject,
        );
        break;
      default:
        return;
    }

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page!),
      );
    }
  }

  void showErrorAlert({String? title, String? content}) {
    title ??= "ERRO AO GERAR LIÇÃO";
    content ??=
        "Ocorreu um erro ao gerar a lição. Você será redirecionado para a tela de login.";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title!),
        content: Text(content!),
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

  Future<int> getNoteRepresentation() async {
    User? user = await UserHelper.getUser();

    if (user == null) {
      if (mounted) {
        EResult.noUser.createAlert(context, isDarkMode);
        // showErrorAlert();
      }
      return -1;
    }

    final int noteRepresentation = user.noteRepresentation;
    return noteRepresentation;
  }

  Exercise _generateExercise(ELessonType lessonType, int noteRepresentation) {
    late final ExerciseBuilder exerciseBuilder;

    switch (widget.subject) {
      case ESubject.note:
        exerciseBuilder = NoteExerciseBuilder(
            lessonType, widget.lessonId, noteRepresentation);
        break;
      case ESubject.interval:
        exerciseBuilder = IntervalExerciseBuilder(
            lessonType, widget.lessonId, noteRepresentation);
        break;

      case ESubject.scale:
        exerciseBuilder = ScaleExerciseBuilder(
            lessonType, widget.lessonId, noteRepresentation);
        break;
      case ESubject.chord:
        exerciseBuilder = ChordExerciseBuilder(
            lessonType, widget.lessonId, noteRepresentation);
        break;
    }

    return exerciseBuilder.buildExercise(
        widget.components, widget.highlightedComponents);
  }

  Future<List<Exercise>> _generateLesson(ELessonType type) async {
    final int noteRepresentation = await getNoteRepresentation();
    if (noteRepresentation == -1) {
      return [];
    }

    List<Exercise> exercises = [];

    for (int i = 0; i < numberOfExercisesPerLesson; i++) {
      exercises.add(_generateExercise(type, noteRepresentation));
    }

    return exercises;
  }

  List<Color> _generateAppBarColors() {
    List<Color> colors = [MyColors.primary, MyColors.brightestPrimary];
    if (isDarkMode) {
      colors = List.from(colors.reversed);
    }
    return colors;
  }

  CircularPercentIndicator _generatePercentIndicator(int percentInt) {
    double percent = percentInt / 100.0;
    return CircularPercentIndicator(
      radius: 80,
      lineWidth: 20.0,
      percent: percent,
      animation: true,
      animationDuration: 10 * percentInt,
      backgroundColor: MyColors.gray4,
      // backgroundWidth: 20.0,
      // fillColor: MyColors.gray4,
      linearGradient:
          LinearGradient(colors: [MyColors.brightestPrimary, MyColors.primary]),
      // progressColor: MyColors.brightPrimary,
      center: Text(
        "$percentInt%",
        style: TextStyle(
          fontSize: 35.0,
          fontFamily: "Inter",
          color: isDarkMode ? MyColors.light : MyColors.darkestPrimary,
        ),
      ),
    );
  }

  MyHorizontalButton _generateButton(String text, void Function()? onPressed) {
    return MyHorizontalButton(
      onPressed: onPressed,
      text: text,
      height: 0.1 * screenHeight,
      width: 0.939 * screenWidth,
      useGradient: true,
      mainColor: MyColors.darkPrimary,
      borderColor: MyColors.dark,
      borderWidth: 5.0,
      fontFamily: "Archivo Narrow",
      fontSize: 45.0,
      secondaryColor: MyColors.brightPrimary,
      textColor: MyColors.light,
    );
  }
}
