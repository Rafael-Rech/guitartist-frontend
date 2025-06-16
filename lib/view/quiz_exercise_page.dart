import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tcc/global/my_colors.dart';
import 'package:tcc/model/Enum/e_lesson_type.dart';
import 'package:tcc/music_theory_components/quiz_exercise.dart';
import 'package:tcc/view/components/answer_option.dart';
import 'package:tcc/view/components/my_text_button.dart';
import 'package:tcc/view/exercise_page.dart';
import 'package:tcc/view/home_page.dart';

class QuizExercisePage extends ExercisePage {
  const QuizExercisePage(super.id, super.exercises, super.index,
      {super.key,
      required super.answersProvided,
      required super.correctAnswersProvided,
      required super.timeSpent,
      required super.subject});

  @override
  State<QuizExercisePage> createState() => _QuizExercisePageState();
}

class _QuizExercisePageState extends State<QuizExercisePage> {
  late final QuizExercise exercise;
  double screenWidth = 0;
  double screenHeight = 0;
  final List<bool> answersTried = [false, false, false, false];
  bool blocked = false;
  late final DateTime startTime;

  final List<Widget> _answers = [
    Container(),
    Container(),
    Container(),
    Container(),
  ];

  @override
  void initState() {
    super.initState();
    try {
      exercise = widget.exercises[widget.index] as QuizExercise;
    } on Exception {
      throw Exception("Erro ao identificar exercício");
    }
    startTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    ThemeData theme = Theme.of(context);
    bool isDarkTheme = theme.brightness == Brightness.dark;

    _loadAnswers();

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MyColors.primary,
              MyColors.darkPrimary,
            ],
          ),
        ),
        child: Center(
          child: Container(
            height: 0.8 * screenHeight,
            // height: 0.766 * screenHeight,
            width: 0.874 * screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.034 * screenWidth),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                      Container(
                        height: 0.262 * screenHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: isDarkTheme
                                ? [MyColors.primary, MyColors.brightPrimary]
                                : [MyColors.darkPrimary, MyColors.primary],
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Center(
                            child: AutoSizeText(
                              exercise.question,
                              style: TextStyle(
                                color: MyColors.light,
                                fontSize: 35.0,
                              ),
                              // maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 1),
                    ] +
                    _answers,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _loadAnswers() {
    _answers.clear();

    for (int i = 0; i < 4; i++) {
      _answers.add(GestureDetector(
        onTap: () async {
          if (answersTried[i] || blocked) {
            return;
          }
          setState(() {
            answersTried[i] = true;
          });
          if (exercise.options[i].isCorrect) {
            blocked = true;
            int numberOfAnswers = 0;
            for (bool tried in answersTried) {
              if (tried) {
                numberOfAnswers++;
              }
            }
            if (widget.index == widget.exercises.length - 1) {
              final totalTimeSpent =
                  widget.timeSpent + DateTime.now().difference(startTime);
              final precision = (((widget.correctAnswersProvided + 1) /
                          (widget.answersProvided + numberOfAnswers)) *
                      100)
                  .ceil();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    "Parabéns",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Você concluiu a lição!",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        Text("Tempo: ${totalTimeSpent.inSeconds}s",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0)),
                        Text("Precisão: $precision%",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        widget.updateProgress(
                            precision, totalTimeSpent, ELessonType.quiz);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false);
                      },
                      child: Text(
                        "Voltar ao início",
                        style: TextStyle(color: MyColors.main6),
                      ),
                    )
                  ],
                ),
                barrierDismissible: false,
              );
            } else {
              Timer(const Duration(seconds: 2), () {
                Navigator.pushReplacement(
                  context,
                  ExercisePage.createAnimatedRoute(
                    QuizExercisePage(
                      widget.id,
                      widget.exercises,
                      widget.index + 1,
                      answersProvided: widget.answersProvided + numberOfAnswers,
                      correctAnswersProvided: widget.correctAnswersProvided + 1,
                      timeSpent: widget.timeSpent +
                          DateTime.now().difference(startTime),
                      subject: widget.subject,
                    ),
                  ),
                );
              });
            }
          }
        },
        child: AnswerOption(
          text: exercise.options[i].text,
          height: 0.1 * screenHeight,
          correct: exercise.options[i].isCorrect,
          answered: answersTried[i],
        ),
      ));
    }

    setState(() {});
  }
}
