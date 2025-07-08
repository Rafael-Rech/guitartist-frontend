import 'dart:isolate';
import 'dart:math';
import 'package:fftea/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:tcc/global/fourier_transform.dart';

class TunerPage extends StatefulWidget {
  const TunerPage({super.key});

  @override
  State<TunerPage> createState() => _TunerPageState();
}

class _TunerPageState extends State<TunerPage> {
  int frequency = 0;
  bool recording = false;
  Isolate? micIsolate;
  Color micIconColor = Colors.black;
  ReceivePort receivePort = ReceivePort();
  late SendPort sendPort;
  AudioRecorder audioRecorder = AudioRecorder();
  Random rng = Random();
  final samplesPerSecond = 44100;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            IconButton(
              onPressed: () {
                recording = !recording;
                setState(() {
                  micIconColor = (micIconColor == Colors.black)
                      ? Colors.red
                      : Colors.black;
                });
                captureAudio();
              },
              iconSize: MediaQuery.of(context).size.width * 0.75,
              icon: Icon(
                Icons.mic,
                color: micIconColor,
              ),
            ),
            Text("${frequency}Hz", style: const TextStyle(fontSize: 40)),
          ],
        ),
      ),
    );
  }


  void captureAudio() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone permission not granted");
    }

    if (recording) {
      if (await audioRecorder.hasPermission()) {
        final stream = await audioRecorder.startStream(RecordConfig(
            encoder: AudioEncoder.pcm16bits, sampleRate: samplesPerSecond));
        /*
          Segundo a biblioteca, o FFT fica insanamente mais rápido
          se o vetor de entrada tiver um tamanho que seja uma
          potência de 2, usando o Radix2FFT
         */
        List values = [];
        int counter = 0;
        await for (final Uint8List value in stream) {
          List streamList = value.toList();
          for (final integer8 in streamList) {
            values.add(integer8);
            /*
            Talvez tenha que trocar esse int8 por int16, já que o PCM é 16 bits?
             */
            counter++;
            if (counter == 32768) {

              final fft = FourierTransform.instance;
              for (int i = 0; i < values.length; i++) {
                if (values[i].runtimeType == int) {
                  values[i] = values[i].toDouble();
                }
              }
              final fftFrequency = fft.realFft(values.cast<double>());
              
              final fftFrequencyList =
                  fftFrequency.discardConjugates().magnitudes().toList();
              int greaterMagnitudeIndex = 1;
              for (int i = 1; i < fftFrequencyList.length; i++) {
                if (fftFrequencyList[i] >
                    fftFrequencyList[greaterMagnitudeIndex]) {
                  greaterMagnitudeIndex = i;
                }
              }
              setState(() {
                frequency = fft
                    .frequency(
                        greaterMagnitudeIndex, samplesPerSecond.toDouble())
                    .round();
              });
              values = [];
              counter = 0;
            }
          }
        }
      }
    } else {
      await audioRecorder.cancel();
    }
  }
}
