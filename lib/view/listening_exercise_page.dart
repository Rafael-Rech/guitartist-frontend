import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:tcc/global/my_colors.dart';
import 'package:tcc/helper/lesson_helper.dart';
import 'package:tcc/helper/user_helper.dart';
import 'package:tcc/model/Enum/e_lesson_type.dart';
import 'package:tcc/model/lesson.dart';
import 'package:tcc/model/user.dart';
import 'package:tcc/music_theory_components/exercise.dart';
import 'package:tcc/music_theory_components/listen_exercise.dart';
import 'package:tcc/music_theory_components/quiz_exercise.dart';
import 'package:tcc/service/user_service.dart';
import 'package:tcc/view/components/my_text_button.dart';
import 'package:tcc/view/exercise_page.dart';
import 'package:tcc/view/home_page.dart';
import 'package:tcc/view/settings_page.dart';

import 'package:just_audio/just_audio.dart';

class ListeningExercisePage extends ExercisePage {
  const ListeningExercisePage(super.id, super.exercises, super.index,
      {super.key,
      required super.answersProvided,
      required super.correctAnswersProvided,
      required super.timeSpent,
      required super.subject});

  @override
  State<ListeningExercisePage> createState() => _ListeningExercisePageState();
}

class _ListeningExercisePageState extends State<ListeningExercisePage> {
  late final ListenExercise exercise;
  double screenWidth = 0;
  double screenHeight = 0;
  final List<bool> answersTried = [false, false, false, false];
  bool blocked = false;
  late final DateTime startTime;
  final justAudioPlayer = AudioPlayer();
  // final flutterSoundPlayer = FlutterSoundPlayer();

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
      exercise = widget.exercises[widget.index] as ListenExercise;
    } on Exception {
      throw Exception("Erro ao identificar exercício");
    }
    startTime = DateTime.now();
  }

  @override
  void dispose() {
    justAudioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    _loadAnswers();
    final appBar = AppBar(
      backgroundColor: const Color.fromARGB(255, 217, 68, 99),
      automaticallyImplyLeading: false,
      foregroundColor: MyColors.main1,
    );

    double answersHeight = 60 + (screenWidth * 0.4);

    return Scaffold(
      appBar: appBar,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: screenHeight -
                AppBar().preferredSize.height -
                2 * answersHeight,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Column(children: [
                  Container(
                    width: screenWidth * 0.4,
                    height: screenWidth * 0.4,
                    decoration: BoxDecoration(
                        color: MyColors.main4,
                        borderRadius: BorderRadius.circular(360)),
                    child: IconButton(
                      icon: Icon(
                        Icons.music_note,
                        color: MyColors.neutral2,
                      ),
                      iconSize: 100.0,
                      onPressed: () async {
                        for (String path in exercise.audioPaths) {
                          // if (justAudioPlayer.duration != null) {
                          //   Timer(justAudioPlayer.duration!, () async {
                          //     await playAudio(path);
                          //   });
                          // } else {
                          //   await playAudio(path);
                          // }
                          await playAudio(path);
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    exercise.question,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
                  ),
                ]),
              ),
            ),
          ),
          SizedBox(
            height: answersHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 25.0,
                    ),
                    _answers[0],
                    const SizedBox(
                      height: 10.0,
                    ),
                    _answers[1],
                    const SizedBox(
                      height: 25.0,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 25.0,
                    ),
                    _answers[2],
                    const SizedBox(
                      height: 10.0,
                    ),
                    _answers[3],
                    const SizedBox(
                      height: 25.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> playAudio(String path) async {
    await justAudioPlayer.setAsset(path);
    await justAudioPlayer.play();
    await justAudioPlayer.processingStateStream
        .firstWhere((state) => state == ProcessingState.completed);
  }

  void _loadAnswers() {
    _answers.clear();
    for (int i = 0; i < 4; i++) {
      late Color backgroundColor;
      late Color borderColor;

      if (answersTried[i]) {
        if (exercise.options[i].isCorrect) {
          backgroundColor = Colors.lightGreen;
          borderColor = Colors.green;
        } else {
          backgroundColor = MyColors.main4;
          borderColor = MyColors.main8;
        }
      } else {
        backgroundColor = MyColors.secondary5;
        borderColor = MyColors.secondary7;
      }

      _answers.add(
        MyTextButton(
            onPressed: () async {
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
                  // showDialog(
                  //   context: context,
                  //   builder: (context) => AlertDialog(
                  //     title: Text("Boa :D"),
                  //     actions: [
                  //       TextButton(
                  //         onPressed: () {
                  //           _updateProgress(
                  //               widget.answersProvided + numberOfAnswers,
                  //               widget.correctAnswersProvided + 1,
                  //               widget.timeSpent +
                  //                   DateTime.now().difference(startTime));
                  //           Navigator.of(context).pushAndRemoveUntil(
                  //               MaterialPageRoute(
                  //                   builder: (context) => HomePage()),
                  //               (route) => false);
                  //         },
                  //         child: Text("Voltar ao início"),
                  //       )
                  //     ],
                  //   ),
                  //   barrierDismissible: false,
                  // );
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
                            widget.updateProgress(precision, totalTimeSpent, ELessonType.listening);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
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
                        ListeningExercisePage(
                          widget.id,
                          widget.exercises,
                          widget.index + 1,
                          answersProvided:
                              widget.answersProvided + numberOfAnswers,
                          correctAnswersProvided:
                              widget.correctAnswersProvided + 1,
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
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            borderWidth: 2.0,
            textColor: Colors.black,
            width: screenWidth * 0.4,
            height: screenWidth * 0.2,
            fontSize: 26.0,
            text: exercise.options[i].text),
      );
    }

    setState(() {});
  }
}
