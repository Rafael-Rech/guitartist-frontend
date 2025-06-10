import 'dart:math' as math;

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
import 'package:tcc/music_theory_components/music_theory_components.dart';
import 'package:tcc/view/lesson_help_page.dart';
import 'package:tcc/view/listening_exercise_page.dart';
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

  final int numberOfExercisesPerLesson = 5;
  // final int numberOfExercisesPerLesson = 15;

  final Duration animationDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    if (widget.locked) {
      sideIcon = Icons.lock;
      expanded = false;
    } else {
      sideIcon = Icons.arrow_right;
    }
    return SizedBox(
      width: widget.width,
      child: Column(
        children: [
          GestureDetector(
            child: AnimatedContainer(
              duration: animationDuration ~/ 2,
              height: widget.width * 0.3,
              decoration: BoxDecoration(
                borderRadius: expanded
                    ? BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))
                    : BorderRadius.circular(10.0),
                color: widget.locked ? MyColors.neutral3 : MyColors.secondary5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedContainer(
                    duration: animationDuration,
                    width: widget.width * 0.2,
                    child: AnimatedSwitcher(
                      duration: animationDuration,
                      child: expanded
                          ? IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LessonHelpPage(
                                        lessonId: widget.lessonId),
                                  ),
                                );
                              },
                              icon: Icon(Icons.help),
                            )
                          : null,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      widget.lessonName,
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: widget.width * 0.2,
                    child: widget.locked
                        ? Icon(sideIcon)
                        : AnimatedSwitcher(
                            duration: animationDuration,
                            child: Transform.rotate(
                              key: expanded
                                  ? ValueKey("Expanded")
                                  : ValueKey("Collapsed"),
                              angle: expanded ? math.pi / 2 : 0.0,
                              child: Icon(sideIcon),
                            )),
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
                    title: Text(
                      "LIÇÃO BLOQUEADA",
                      textAlign: TextAlign.center,
                    ),
                    content: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.0),
                      child: Text(
                        "Esta lição será desbloqueada quando você atingir uma proficiência de 70% na lição anterior.",
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child:
                            Text("Ok", style: TextStyle(color: MyColors.main6)),
                      )
                    ],
                  ),
                );
              }
            },
          ),
          AnimatedSwitcher(
            duration: animationDuration,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ClipRect(
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0, -1),
                    end: Offset(0, 0),
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _expandedContent(),
          ),
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
      return Container(
        key: ValueKey("Collapsed"),
      );
    }
    return Container(
      key: ValueKey("Expanded"),
      height: widget.width * 0.8,
      decoration: BoxDecoration(
          color: MyColors.secondary7,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          )),
      child: Column(
        children: [
          Text(
            "Precisão: ${widget.precision}%",
            style: TextStyle(
                color: MyColors.neutral2,
                fontSize: 20.0,
                fontWeight: FontWeight.w600),
          ),
          Text(
            "Proficiência: ${widget.proficiency}%",
            style: TextStyle(
                color: MyColors.neutral2,
                fontSize: 20.0,
                fontWeight: FontWeight.w600),
          ),
          Text(
            "Tentativas: ${widget.tries}",
            style: TextStyle(
                color: MyColors.neutral2,
                fontSize: 20.0,
                fontWeight: FontWeight.w600),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 15.0),
              child: Container(
                height: 1.0,
                color: Color.fromARGB(255, 253, 253, 253),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () async {
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
                  width: widget.width * 0.4,
                  height: widget.width * 0.4,
                  decoration: BoxDecoration(
                    color: MyColors.secondary5,
                    image: DecorationImage(
                      image: AssetImage("assets/imgs/brainBlack.png"),
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final List<Exercise> lesson =
                      await _generateLesson(ELessonType.listening);
                  if (lesson.isEmpty) {
                    throw Exception("Empty lesson");
                  }
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListeningExercisePage(
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
                  width: widget.width * 0.4,
                  height: widget.width * 0.4,
                  decoration: BoxDecoration(
                    color: MyColors.secondary5,
                    image: DecorationImage(
                      image: AssetImage("assets/imgs/headPhoneBlack.png"),
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
