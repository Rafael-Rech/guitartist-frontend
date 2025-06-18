import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:tcc/global/my_colors.dart';

class MetronomePage extends StatefulWidget {
  const MetronomePage({super.key});

  @override
  State<MetronomePage> createState() => _MetronomePageState();
}

class _MetronomePageState extends State<MetronomePage> {
  TextEditingController controller = TextEditingController(text: "40");
  bool playing = false;
  Icon buttonIcon = const Icon(Icons.play_arrow);
  Random rng = Random();
  Timer? metronomeTimer;
  FocusNode focusNode = FocusNode();
  final justAudioPlayer = AudioPlayer();

  late ThemeData theme;
  late bool isDarkMode;
  late double screenHeight;
  late double screenWidth;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      // Changes metronome's bpm when the textfield is altered, by creating a new timer
      if (metronomeTimer != null &&
          metronomeTimer!.isActive &&
          controller.text != "" &&
          int.parse(controller.text) <= 220 &&
          int.parse(controller.text) >= 40) {
        updateTimer();
      }
    });
  }

  @override
  void dispose() {
    justAudioPlayer.stop();

    if (metronomeTimer != null && metronomeTimer!.isActive) {
      metronomeTimer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    theme = AdaptiveTheme.of(context).theme;
    isDarkMode = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.2 * screenHeight),
        // preferredSize: Size.fromHeight(0.266 * screenHeight),
        child: _generateAppBar(),
      ),

      body: Center(
        child: Container(
          height: 0.5623 * screenHeight,
          width: 0.8744 * screenWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: isDarkMode
                    ? [MyColors.darkPrimary, MyColors.brightPrimary]
                    : [MyColors.darkPrimary, MyColors.primary]),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.33,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: controller,
                      style: TextStyle(fontSize: 34),
                      decoration: InputDecoration(suffixText: " bpm"),
                      focusNode: focusNode,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: MyColors.main7),
                          color: MyColors.main5,
                        ),
                        child: IconButton(
                          onPressed: () {
                            final int bpm = int.parse(controller.text);
                            if (bpm != 220) {
                              setState(() {
                                controller.text = (bpm + 1).toString();
                              });
                              updateTimer();
                            }
                          },
                          icon: Icon(
                            Icons.arrow_drop_up,
                            color: MyColors.secondary5,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: MyColors.main7),
                          color: MyColors.main5,
                        ),
                        child: IconButton(
                          onPressed: () {
                            final int bpm = int.parse(controller.text);
                            if (bpm != 40) {
                              setState(() {
                                controller.text = (bpm - 1).toString();
                              });
                              updateTimer();
                            }
                          },
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: MyColors.secondary5,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                decoration: ShapeDecoration(
                  color: isDarkMode ? MyColors.gray5 : MyColors.light,
                  shape: CircleBorder(
                      side: BorderSide(color: MyColors.gray2, width: 10.0)),
                ),
                child: IconButton(
                  onPressed: () async {
                    int bpm = int.parse(controller.text);
                    if (bpm <= 220 && bpm >= 40) {
                      playing = !playing;
                      setState(() {
                        buttonIcon = ((playing)
                            ? const Icon(Icons.pause)
                            : const Icon(Icons.play_arrow));
                      });
                    }
                    if (playing && bpm != 0 && bpm <= 220 && bpm >= 40) {
                      metronomeTimer = Timer.periodic(
                        Duration(
                          milliseconds: ((60000 ~/ bpm)),
                        ),
                        (timer) {
                          justAudioPlayer.setAsset("assets/audio/beep.wav");

                          justAudioPlayer.play();
                          Color color = Color.fromARGB(255, rng.nextInt(255),
                              rng.nextInt(255), rng.nextInt(255));
                          setState(() {
                            buttonIcon = Icon(
                              buttonIcon.icon,
                              color: color,
                            );
                          });
                        },
                      );
                    } else if (int.parse(controller.text) == 0) {
                      focusNode.requestFocus();
                      // Needs to give more emphasis on the textfield
                    } else if (metronomeTimer != null &&
                        metronomeTimer!.isActive) {
                      metronomeTimer!.cancel();
                    }
                  },
                  icon: buttonIcon,
                  iconSize: 0.25 * screenWidth,
                  color: isDarkMode? MyColors.brightPrimary : MyColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),

      //   body: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         Row(
      //           mainAxisSize: MainAxisSize.min,
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             SizedBox(
      //               width: MediaQuery.of(context).size.width * 0.33,
      //               child: TextField(
      //                 keyboardType: TextInputType.number,
      //                 controller: controller,
      //                 style: TextStyle(fontSize: 34),
      //                 decoration: InputDecoration(suffixText: " bpm"),
      //                 focusNode: focusNode,
      //               ),
      //             ),
      //             const SizedBox(width: 5),
      //             Column(
      //               children: [
      //                 Container(
      //                   decoration: BoxDecoration(
      //                     border: Border.all(color: MyColors.main7),
      //                     color: MyColors.main5,
      //                   ),
      //                   child: IconButton(
      //                     onPressed: () {
      //                       final int bpm = int.parse(controller.text);
      //                       if (bpm != 220) {
      //                         setState(() {
      //                           controller.text = (bpm + 1).toString();
      //                         });
      //                         updateTimer();
      //                       }
      //                     },
      //                     icon: Icon(
      //                       Icons.arrow_drop_up,
      //                       color: MyColors.secondary5,
      //                     ),
      //                   ),
      //                 ),
      //                 Container(
      //                   decoration: BoxDecoration(
      //                     border: Border.all(color: MyColors.main7),
      //                     color: MyColors.main5,
      //                   ),
      //                   child: IconButton(
      //                     onPressed: () {
      //                       final int bpm = int.parse(controller.text);
      //                       if (bpm != 40) {
      //                         setState(() {
      //                           controller.text = (bpm - 1).toString();
      //                         });
      //                         updateTimer();
      //                       }
      //                     },
      //                     icon: Icon(
      //                       Icons.arrow_drop_down,
      //                       color: MyColors.secondary5,
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             )
      //           ],
      //         ),
      //         const SizedBox(
      //           height: 10.0,
      //         ),
      //         IconButton(
      //           onPressed: () async {
      //             int bpm = int.parse(controller.text);
      //             if (bpm <= 220 && bpm >= 40) {
      //               playing = !playing;
      //               setState(() {
      //                 buttonIcon = ((playing)
      //                     ? const Icon(Icons.pause)
      //                     : const Icon(Icons.play_arrow));
      //               });
      //             }
      //             if (playing && bpm != 0 && bpm <= 220 && bpm >= 40) {
      //               metronomeTimer = Timer.periodic(
      //                 Duration(
      //                   milliseconds: ((60000 ~/ bpm)),
      //                 ),
      //                 (timer) {
      //                   justAudioPlayer.setAsset("assets/audio/beep.wav");

      //                   justAudioPlayer.play();
      //                   Color color = Color.fromARGB(255, rng.nextInt(255),
      //                       rng.nextInt(255), rng.nextInt(255));
      //                   setState(() {
      //                     buttonIcon = Icon(
      //                       buttonIcon.icon,
      //                       color: color,
      //                     );
      //                   });
      //                 },
      //               );
      //             } else if (int.parse(controller.text) == 0) {
      //               focusNode.requestFocus();
      //               // Needs to give more emphasis on the textfield
      //             } else if (metronomeTimer != null && metronomeTimer!.isActive) {
      //               metronomeTimer!.cancel();
      //             }
      //           },
      //           iconSize: MediaQuery.of(context).size.width * 0.75,
      //           icon: buttonIcon,
      //         ),
      //       ],
      //     ),
      //   ),
    );
  }

  AppBar _generateAppBar() {
    List<Color> colors = [MyColors.primary, MyColors.brightestPrimary];
    if (isDarkMode) {
      colors = List.from(colors.reversed);
    }

    return AppBar(
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
                "Metrônomo",
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

  void updateTimer() {
    metronomeTimer!.cancel();
    metronomeTimer = Timer.periodic(
      Duration(
        milliseconds: ((60000 ~/ int.parse(controller.text))),
      ),
      (timer) {
        justAudioPlayer.setAsset("assets/audio/beep.wav");

        justAudioPlayer.play();
        Color color = Color.fromARGB(
            255, rng.nextInt(255), rng.nextInt(255), rng.nextInt(255));
        setState(() {
          buttonIcon = Icon(
            buttonIcon.icon,
            color: color,
          );
        });
      },
    );
  }
}
