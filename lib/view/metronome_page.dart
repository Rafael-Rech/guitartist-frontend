import 'dart:math';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 217, 68, 99),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            const SizedBox(
              height: 10.0,
            ),
            IconButton(
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
                } else if (metronomeTimer != null && metronomeTimer!.isActive) {
                  metronomeTimer!.cancel();
                }
              },
              iconSize: MediaQuery.of(context).size.width * 0.75,
              icon: buttonIcon,
            ),
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
