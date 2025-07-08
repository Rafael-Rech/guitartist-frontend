import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:tcc/global/my_colors.dart';
import 'package:tcc/view/components/my_text_field.dart';

class MetronomePage extends StatefulWidget {
  const MetronomePage({super.key});

  @override
  State<MetronomePage> createState() => _MetronomePageState();
}

class _MetronomePageState extends State<MetronomePage> {
  TextEditingController controller = TextEditingController(text: "80");
  bool playing = false;
  Icon buttonIcon = const Icon(Icons.play_arrow);
  Random rng = Random();
  Timer? metronomeTimer, _bpmButtonsTimer;
  FocusNode focusNode = FocusNode();
  final justAudioPlayer = AudioPlayer();

  late ThemeData theme;
  late bool isDarkMode;
  late double screenHeight;
  late double screenWidth;

  int beatsPerMeasure = 4;
  int beatsPerMinute = 80;
  int beatCounter = 0;

  final String errorMessage = "Insira um valor entre 40 e 220.";
  String? error;

  @override
  void initState() {
    super.initState();
    // controller.addListener(() {
    //   // if (controller.text == "") {
    //   //   error = errorMessage;
    //   //   return;
    //   // }

    //   // int? bpm = int.tryParse(controller.text);
    //   // if (bpm == null) {
    //   //   setState(() {
    //   //     controller.text = "$beatsPerMinute";
    //   //   });
    //   //   bpm = beatsPerMinute;
    //   // } else if (bpm < 40) {
    //   //   setState(() {
    //   //     controller.text = "40";
    //   //   });
    //   //   bpm = 40;
    //   // } else if (bpm > 220) {
    //   //   setState(() {
    //   //     controller.text = "220";
    //   //   });
    //   //   bpm = 220;
    //   // }

    //   // setState(() {
    //   //   error = null;
    //   //   beatsPerMinute = bpm!;
    //   //   if (metronomeTimer != null && metronomeTimer!.isActive) {
    //   //     updateTimer();
    //   //   }
    //   // });
    // });
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
    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
        _handleTextFieldInput();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.2 * screenHeight),
          // preferredSize: Size.fromHeight(0.266 * screenHeight),
          child: _generateAppBar(),
        ),
        backgroundColor: theme.colorScheme.surface,
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
                _generateBpmController(),
                Divider(
                  color: isDarkMode ? MyColors.gray5 : MyColors.light,
                  thickness: 4.0,
                  indent: 15.0,
                  endIndent: 15.0,
                ),
                _generateBeatsPerMeasureController(),
                _generatePlayButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _generateAppBar() {
    List<Color> colors = [MyColors.primary, MyColors.brightestPrimary];
    if (isDarkMode) {
      colors = List.from(colors.reversed);
    }

    return AppBar(
      elevation: 5.0,
      iconTheme:
          IconThemeData(color: isDarkMode ? MyColors.light : MyColors.dark),
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

  Widget _generateBpmController() {
    return SizedBox(
      width: 0.8744 * screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 0.75 * screenWidth,
            decoration: BoxDecoration(
              color: isDarkMode ? MyColors.gray4 : MyColors.light,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 0.35 * screenWidth,
                  child: MyTextField(
                    onSubmitted: (p0) {
                      _handleTextFieldInput();
                    },
                    // textColor: isDarkMode ? MyColors.light : MyColors.dark,
                    textColor: MyColors.dark,
                    border: InputBorder.none,
                    errorText: error,
                    keyboardType: TextInputType.number,
                    controller: controller,
                    fontSize: 34,
                    focusNode: focusNode,
                    suffixText: " bpm",
                    suffixStyle: TextStyle(
                      fontSize: 26.0,
                      fontFamily: "Archivo Narrow",
                      color: MyColors.gray1,
                      // color: isDarkMode ? MyColors.gray5 : MyColors.gray1,
                    ),
                    // contentPadding: EdgeInsets.zero,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 5),
                // IconButton(
                //   onPressed: () {
                //     final int bpm = int.parse(controller.text);
                //     if (bpm < 220 && beatsPerMinute < 220) {
                //       setState(() {
                //         controller.text = (bpm + 1).toString();
                //         beatsPerMinute = bpm + 1;
                //       });
                //       updateTimer();
                //     }
                //   },
                //   icon: Icon(
                //     Icons.arrow_drop_up,
                //     color: MyColors.gray1,
                //     size: 50.0,
                //   ),
                // ),
                // IconButton(
                //   onPressed: () {
                //     final int bpm = int.parse(controller.text);
                //     if (bpm > 40) {
                //       setState(() {
                //         controller.text = (bpm - 1).toString();
                //         beatsPerMinute = bpm - 1;
                //       });
                //       updateTimer();
                //     }
                //   },
                //   icon: Icon(
                //     Icons.arrow_drop_down,
                //     color: MyColors.gray1,
                //     size: 50.0,
                //   ),
                // ),
                GestureDetector(
                  onTap: _buttonIncrementFunction,
                  onLongPressStart: (details) {
                    if (_bpmButtonsTimer != null) {
                      return;
                    }
                    _bpmButtonsTimer = Timer.periodic(
                      Duration(milliseconds: 100),
                      (timer) {
                        _buttonIncrementFunction();
                      },
                    );
                  },
                  onLongPressEnd: _stopIncrementingOrDecrementing,
                  child: Icon(
                    Icons.arrow_drop_up,
                    color: MyColors.gray1,
                    size: 50.0,
                  ),
                ),
                GestureDetector(
                  onTap: _buttonDecrementFunction,
                  onLongPressStart: (details) {
                    if (_bpmButtonsTimer != null) {
                      return;
                    }
                    _bpmButtonsTimer = Timer.periodic(
                      Duration(milliseconds: 100),
                      (timer) {
                        _buttonDecrementFunction();
                      },
                    );
                  },
                  onLongPressEnd: _stopIncrementingOrDecrementing,
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: MyColors.gray1,
                    size: 50.0,
                  ),
                ),
              ],
            ),
          ),
          Slider(
            value: beatsPerMinute.toDouble(),
            onChanged: (double value) {
              setState(() {
                beatsPerMinute = value.toInt();
                controller.text = "$beatsPerMinute";
                updateTimer();
              });
            },
            // activeColor: Color.fromARGB(255, 0, 255, 0),
            activeColor: MyColors.brightPrimary,
            thumbColor: MyColors.light,
            // inactiveColor: Color.fromARGB(255, 0, 0, 255),
            inactiveColor: MyColors.gray5,
            min: 40.0,
            max: 220.0,
          ),
        ],
      ),
    );
  }

  void _buttonIncrementFunction() {
    final int bpm = int.parse(controller.text);
    if (bpm < 220 && beatsPerMinute < 220) {
      setState(() {
        controller.text = (bpm + 1).toString();
        beatsPerMinute = bpm + 1;
      });
      updateTimer();
    }
  }

  void _buttonDecrementFunction() {
    final int bpm = int.parse(controller.text);
    if (bpm > 40 && beatsPerMinute > 40) {
      setState(() {
        controller.text = (bpm - 1).toString();
        beatsPerMinute = bpm - 1;
      });
      updateTimer();
    }
  }

  void _stopIncrementingOrDecrementing(LongPressEndDetails details) {
    if (_bpmButtonsTimer == null || !_bpmButtonsTimer!.isActive) {
      return;
    }
    _bpmButtonsTimer?.cancel();
    _bpmButtonsTimer = null;
  }

  Widget _generateBeatsPerMeasureController() {
    return SizedBox(
      width: 0.8744 * screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AutoSizeText(
            "Batidas por compasso",
            maxLines: 1,
            style: TextStyle(
              fontFamily: "Roboto",
              color: MyColors.light,
              fontSize: 22.0,
            ),
          ),
          Container(
            width: 0.2 * screenWidth,
            decoration: BoxDecoration(
              color: isDarkMode ? MyColors.gray5 : MyColors.light,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton(
              style: TextStyle(
                fontSize: 26.0,
                color: MyColors.dark,
                fontWeight: FontWeight.w500,
                fontFamily: "Roboto",
              ),
              // padding: EdgeInsets.all(5),
              underline: Container(),
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(10),
              menuMaxHeight: screenHeight / 3,
              alignment: Alignment.center,
              isExpanded: true,
              dropdownColor: isDarkMode ? MyColors.gray5 : MyColors.light,
              icon: Icon(Icons.arrow_drop_down, color: MyColors.gray1),
              value: beatsPerMeasure,
              items: List.generate(
                12,
                (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Center(child: Text('${index + 1}')),
                ),
              ),
              onChanged: (int? value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  beatsPerMeasure = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _generatePlayButton() {
    return Container(
      decoration: ShapeDecoration(
        color: isDarkMode ? MyColors.gray5 : MyColors.light,
        shape:
            CircleBorder(side: BorderSide(color: MyColors.gray2, width: 10.0)),
      ),
      child: IconButton(
        onPressed: () async {
          // int bpm = int.parse(controller.text);
          if (beatsPerMinute <= 220 && beatsPerMinute >= 40) {
            playing = !playing;
            setState(() {
              buttonIcon = ((playing)
                  ? const Icon(Icons.pause)
                  : const Icon(Icons.play_arrow));
            });
          }
          if (playing && beatsPerMinute <= 220 && beatsPerMinute >= 40) {
            beatCounter = 0;
            metronomeTimer = Timer.periodic(
              Duration(
                milliseconds: ((60000 ~/ beatsPerMinute)),
              ),
              _metronomeFunction,
            );
          } else if (int.parse(controller.text) == 0) {
            focusNode.requestFocus();
            // Needs to give more emphasis on the textfield
          } else if (metronomeTimer != null && metronomeTimer!.isActive) {
            metronomeTimer!.cancel();
          }
        },
        icon: buttonIcon,
        iconSize: 0.25 * screenWidth,
        color: isDarkMode ? MyColors.brightPrimary : MyColors.primary,
      ),
    );
  }

  void updateTimer() {
    if (metronomeTimer == null || !metronomeTimer!.isActive) {
      return;
    }
    beatCounter = 0;
    metronomeTimer!.cancel();
    metronomeTimer = Timer.periodic(
      // Duration(
      //   milliseconds: ((60000 ~/ int.parse(controller.text))),
      // ),
      Duration(
        milliseconds: ((60000 ~/ beatsPerMinute)),
      ),
      _metronomeFunction,
    );
  }

  void _handleTextFieldInput() {
    if (controller.text == "") {
      // error = errorMessage;
      // return;
    }

    int? bpm = int.tryParse(controller.text);
    if (bpm == null) {
      setState(() {
        controller.text = "$beatsPerMinute";
      });
      bpm = beatsPerMinute;
    } else if (bpm < 40) {
      setState(() {
        controller.text = "40";
      });
      bpm = 40;
    } else if (bpm > 220) {
      setState(() {
        controller.text = "220";
      });
      bpm = 220;
    }

    setState(() {
      error = null;
      beatsPerMinute = bpm!;
      if (metronomeTimer != null && metronomeTimer!.isActive) {
        updateTimer();
      }
    });
  }

  void _metronomeFunction(Timer timer) {
    // justAudioPlayer.setAsset("assets/audio/beep.wav");
    justAudioPlayer.setAsset(beatCounter == 0
        ? "assets/audio/metronome/metronome2.wav"
        : "assets/audio/metronome/metronome1.wav");

    justAudioPlayer.play();
    // Color color = Color.fromARGB(
    //     255, rng.nextInt(255), rng.nextInt(255), rng.nextInt(255));
    setState(() {
      buttonIcon = Icon(
        buttonIcon.icon,
        // color: color,
      );
    });
    beatCounter = (beatCounter + 1) % beatsPerMeasure;
  }

  // List<int>? _getMeasureFromString(String measure) {
  //   if (!measure.contains('/') ||
  //       measure.indexOf('/') == measure.length - 1 ||
  //       measure.indexOf('/') == 0) {
  //     return null;
  //   }
  //   int? firstPart = int.tryParse(measure.substring(0, measure.indexOf("/")));
  //   int? secondPart = int.tryParse(measure.substring(measure.indexOf("/") + 1));

  //   if(firstPart == null || secondPart == null){
  //     return null;
  //   }

  //   return <int>[firstPart, secondPart];
  // }
}
