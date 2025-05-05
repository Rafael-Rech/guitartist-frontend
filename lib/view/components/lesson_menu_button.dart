import 'package:flutter/material.dart';
import 'package:tcc/global/my_colors.dart';
import 'package:tcc/helper/user_helper.dart';
import 'package:tcc/model/Enum/e_subject.dart';
import 'package:tcc/model/user.dart';
import 'package:tcc/music_theory_components/exercise.dart';
import 'package:tcc/music_theory_components/exercise_builders/chord_exercise_builder.dart';
import 'package:tcc/music_theory_components/exercise_builders/exercise_builder.dart';
import 'package:tcc/music_theory_components/exercise_builders/interval_exercise_builder.dart';
import 'package:tcc/music_theory_components/exercise_builders/note_exercise_builder.dart';
import 'package:tcc/music_theory_components/exercise_builders/scale_exercise_builder.dart';
import 'package:tcc/view/login_page.dart';
import 'package:tcc/view/quiz_exercise_page.dart';

import '../../model/Enum/e_lesson_type.dart';

class LessonMenuButton extends StatefulWidget {
  const LessonMenuButton({
    super.key,
    required this.lessonName,
    required this.lessonId,
    required this.width,
    required this.locked,
    required this.subject,
    required this.components,
    required this.highlightedComponents,
    required this.precision,
    required this.tries,
    required this.proficiency,
  });

  final String lessonName;
  final String lessonId;
  final double width;
  final bool locked;
  final ESubject subject;
  final List<int> components;
  final List<int> highlightedComponents;
  final int precision;
  final int tries;
  final int proficiency;

  @override
  State<LessonMenuButton> createState() => _LessonMenuButtonState();
}

class _LessonMenuButtonState extends State<LessonMenuButton> {
  Icon? helpIcon;
  bool expanded = false;
  IconData? sideIcon;

  final int numberOfExercisesPerLesson = 15;

  @override
  Widget build(BuildContext context) {
    if (widget.locked) {
      sideIcon = Icons.lock;
    } else if (expanded) {
      sideIcon = Icons.arrow_drop_down;
    } else {
      sideIcon = Icons.arrow_right;
    }
    return Container(
      color: Colors.pink,
      width: widget.width,
      child: Column(
        children: [
          GestureDetector(
            child: Container(
              color: widget.locked ? MyColors.neutral3 : MyColors.secondary5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: widget.width * 0.2,
                    child: IconButton(
                      onPressed: () {
                        print("help I need somebody help");
                      },
                      icon: Icon(expanded ? Icons.help : null),
                    ),
                  ),
                  Text(widget.lessonName),
                  SizedBox(
                    width: widget.width * 0.2,
                    child: Icon(sideIcon),
                  ),
                ],
              ),
            ),
            onTap: () {
              if (!widget.locked) {
                setState(() {
                  expanded = !expanded;
                });
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("LIÇÃO BLOQUEADA"),
                    content: Text(
                        "Esta lição será desbloqueada quando você atingir uma proficiência de 70% na lição anterior."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Ok"),
                      )
                    ],
                  ),
                );
              }
            },
          ),
          _expandedContent(),
        ],
      ),
    );
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
        showErrorAlert();
      } else {
        return -1;
      }
    }

    final int noteRepresentation = user!.noteRepresentation;
    return noteRepresentation;
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

  Widget _expandedContent() {
    if (!expanded) {
      return SizedBox(
        height: 0,
      );
    }
    return Container(
      height: widget.width * 0.7,
      // height: widget.width * 0.5,
      color: MyColors.secondary6,
      child: Column(
        children: [
          Text("Precisão: ${widget.precision}"),
          Text("Proficiência: ${widget.proficiency}"),
          Text("Tentativas: ${widget.tries}"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () async {
                  // Mostrar o indicador circular
                  final List<Exercise> lesson =
                      await _generateLesson(ELessonType.quiz);
                  if (lesson.isEmpty) {
                    throw Exception("Empty lesson");
                  }
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizExercisePage(
                          widget.lessonId,
                          lesson,
                          0,
                          answersProvided: 0,
                          correctAnswersProvided: 0,
                          timeSpent: Duration(),
                          subject: widget.subject,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  color: MyColors.main3,
                  width: widget.width * 0.4,
                  height: widget.width * 0.4,
                  child: Icon(Icons.quiz),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  _generateLesson(ELessonType.listening);
                },
                child: Container(
                  color: MyColors.main3,
                  width: widget.width * 0.4,
                  height: widget.width * 0.4,
                  child: Icon(Icons.headphones),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
