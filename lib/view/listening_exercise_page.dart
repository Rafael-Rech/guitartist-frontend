import 'dart:async';
import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:tcc/global/alerts.dart';
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
import 'package:tcc/view/components/answer_option.dart';
import 'package:tcc/view/components/my_text_button.dart';
import 'package:tcc/view/exercise_page.dart';
import 'package:tcc/view/home_page.dart';
import 'package:tcc/view/quiz_exercise_page.dart';
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
  bool blocked = false, playingAudio = false;
  late final DateTime startTime;
  // final justAudioPlayer = AudioPlayer();
  // final flutterSoundPlayer = FlutterSoundPlayer();

  final List<AudioPlayer> players = [];

  late bool isDarkMode;

  bool pressingButton = false;
  late Color iconColor;
  late Color buttonColor;

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
    _initPlayers();
    startTime = DateTime.now();
  }

  @override
  void dispose() {
    // justAudioPlayer.stop();
    _closePlayers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    ThemeData theme = AdaptiveTheme.of(context).theme;
    isDarkMode = theme.brightness == Brightness.dark;

    if (!pressingButton) {
      buttonColor = isDarkMode ? MyColors.gray3 : MyColors.light;
      iconColor = isDarkMode ? MyColors.light : MyColors.brightPrimary;
    }

    _loadAnswers();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
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
                color: theme.colorScheme.surface,
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
                              colors: isDarkMode
                                  ? [MyColors.primary, MyColors.brightPrimary]
                                  : [MyColors.darkPrimary, MyColors.primary],
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  AutoSizeText(
                                    exercise.question,
                                    style: TextStyle(
                                      color: MyColors.light,
                                      fontSize: 35.0,
                                    ),
                                    // maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (!playingAudio) {
                                        await playAudio(
                                            exercise.playAudiosAtSameTime);
                                      }
                                    },
                                    onTapDown: (details) {
                                      setState(() {
                                        pressingButton = true;
                                        buttonColor = isDarkMode
                                            ? MyColors.gray2
                                            : MyColors.gray4;
                                        iconColor = isDarkMode
                                            ? MyColors.primary
                                            : MyColors.primary;
                                      });
                                    },
                                    onTapUp: (details) {
                                      setState(() {
                                        pressingButton = false;
                                      });
                                    },
                                    onTapCancel: () {
                                      setState(() {
                                        pressingButton = false;
                                      });
                                    },
                                    child: Container(
                                      height: 0.0656 * screenHeight,
                                      width: 0.6767 * screenWidth,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: isDarkMode
                                              ? MyColors.darkPrimary
                                              : MyColors.gray1,
                                          width: 3.0,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Color.fromARGB(120, 5, 5, 5),
                                              blurRadius: 5,
                                              offset: Offset(-1, 8))
                                        ],
                                        color: buttonColor,
                                      ),
                                      child: Icon(
                                        Icons.music_note,
                                        color: iconColor,
                                        size: 0.055 * screenHeight,
                                      ),
                                    ),
                                  ),
                                ],
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
      ),
    );
  }

  void _initPlayers() {
    players.addAll(
        List.generate(exercise.audioPaths.length, (path) => AudioPlayer()));
  }

  void _closePlayers() {
    for (AudioPlayer player in players) {
      player.stop();
    }
  }

  Future<void> playAudio(bool playAudiosAtSameTime) async {
    playingAudio = true;
    final Duration delay = (playAudiosAtSameTime)
        ? Duration(milliseconds: 750)
        : Duration(seconds: 2);
    for (int i = 0; i < exercise.audioPaths.length; i++) {
      Future.delayed(delay * i, () async {
        await players[i].setAsset(exercise.audioPaths[i]);
        await players[i].play();
      });
    }
    playingAudio = false;
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
              alert(
                context,
                "Lição concluída!",
                "Parabéns! Você concluiu sua lição em ${totalTimeSpent.inSeconds ~/ 60} minuto(s) e ${totalTimeSpent.inSeconds % 60} segundo(s)!",
                [
                  TextButton(
                    onPressed: () async {
                      final result = await widget.updateProgress(
                          precision, totalTimeSpent, ELessonType.listening);
                      if (result != null) {
                        if (mounted) {
                          await result.createAlert(context, isDarkMode);
                        }
                      }
                      if (mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false);
                      }
                    },
                    child: Text(
                      "Voltar ao menu",
                      style: TextStyle(
                        color: isDarkMode ? MyColors.light : MyColors.primary,
                        fontSize: 22.0,
                      ),
                    ),
                  )
                ],
                isDarkMode,
                dismissible: false,
              );
            } else {
              Timer(widget.answerToPushDuration, () {
                Navigator.pushReplacement(
                  context,
                  ExercisePage.createAnimatedRoute(
                    ListeningExercisePage(
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
