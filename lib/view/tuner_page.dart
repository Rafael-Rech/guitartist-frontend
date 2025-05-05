import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:fftea/impl.dart';
import 'package:fftea/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:tcc/global/audio_recorder.dart';
import 'package:record/record.dart';
import 'package:tcc/global/fourier_transform.dart';

class TunerPage extends StatefulWidget {
  const TunerPage({super.key});

  @override
  State<TunerPage> createState() => _TunerPageState();
}

class _TunerPageState extends State<TunerPage> {
  int frequency = 0;
  // FlutterSoundRecorder recorder = AudioRecorder.recorder;
  bool recording = false;
  Isolate? micIsolate;
  Color micIconColor = Colors.black;
  ReceivePort receivePort = ReceivePort();
  late SendPort sendPort;
  final Completer _isolateReady = Completer();
  AudioRecorder audioRecorder = AudioRecorder();
  Random rng = Random();
  final samplesPerSecond = 44100;

  @override
  void initState() {
    super.initState();

    // receivePort.listen((dynamic message) {
    //   // Lidar com o recebimento de mensagens
    //   print("Mensagem recebida na isolate padrão: $message");
    //   if (message is SendPort) {
    //     sendPort = message;
    //     _isolateReady.complete();
    //   } else if (message is int) {
    //     setState(() {
    //       frequency = message;
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    // sendPort.send("ShutDown");
    // micIsolate?.kill();
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

  static void isolateCode(Map data) {
    final SendPort sendPort = data["sendPort"];
    final token = data["token"];
    BackgroundIsolateBinaryMessenger.ensureInitialized(token);
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    // FlutterSoundRecorder recorder = AudioRecorder.recorder;

    // print("Antes de criar o gravador");
    // late AudioRecorder recordRecorder;
    // try {
    //   final aux = AudioRecorder();
    //   recordRecorder = aux;
    // } catch (e) {
    //   print("Excecao: $e");
    // }
    // print("Depois de criar o gravador");

    receivePort.listen((dynamic message) async {
      print("Mensagem recebida na outra Isolate: $message");
      if (message is bool) {
        if (message) {
          // print("Antes do await da abertura do gravador");
          // var aux = await recorder.openRecorder();
          // print("aux: ${aux.toString()}");
          // aux == null? throw Exception("Couldn't open recorder") : recorder = aux;
          // var recordingDataController = StreamController<Food>();
          // StreamSubscription _mRecordingDataSubscription =
          //     recordingDataController.stream.listen((event) {
          //   if (event is FoodData) {
          //     // Acho que tá jogando pro arquivo no exemplo
          //     print("Comida fds: $event");
          //   }
          // });
          // recorder.startRecorder(toStream: recordingDataController.sink);

          // print("Comecando codigo");
          // // if (await recordRecorder.hasPermission()) {
          // try {
          //   print("Antes da stream");
          //   final stream = await recordRecorder.startStream(
          //       const RecordConfig(encoder: AudioEncoder.pcm16bits));
          //   print("depois da stream");
          // } catch (e) {
          //   print("Excecao: $e");
          // }
          // // }

          sendPort.send(Random().nextInt(200));
        } else {
          // await recorder.closeRecorder();

          // await recordRecorder.cancel();
          sendPort.send(-1);
        }
      } else if (message is String && message == "ShutDown") {
        // recordRecorder.dispose();
      }
    });
  }

  void captureAudio() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone permission not granted");
    }

    // https://stackoverflow.com/questions/75950122/flutter-isolates-the-backgroundisolatebinarymessenger-instance-value-is-invalid
    // var rootToken = RootIsolateToken.instance!;

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
            // print(integer8);
            values.add(integer8);
            /*
            Talvez tenha que trocar esse int8 por int16, já que o PCM é 16 bits?
             */
            counter++;
            if (counter == 32768) {
              // if (counter == 1024) {
              // Faz o fft
              final fft = FourierTransform.instance;
              for (int i = 0; i < values.length; i++) {
                if (values[i].runtimeType == int) {
                  values[i] = values[i].toDouble();
                } else {
                  print("Não é inteiro");
                }
              }
              // print(values);
              final fftFrequency = fft.realFft(values.cast<double>());
              // print(fftFrequency);
              
              final fftFrequencyList =
                  fftFrequency.discardConjugates().magnitudes().toList();
              // print(fftFrequencyList);
              int greaterMagnitudeIndex = 1;
              // print("Tamanho da listona: ${fftFrequencyList.length}");
              // for (int i = 0; i < 25; i++) {
              //   print(fftFrequencyList[i]);
              // }
              for (int i = 1; i < fftFrequencyList.length; i++) {
                if (fftFrequencyList[i] >
                    fftFrequencyList[greaterMagnitudeIndex]) {
                  greaterMagnitudeIndex = i;
                  // print("a");
                }
                // print("Frequência: ${fft.frequency(i, samplesPerSecond.toDouble())}Hz");
              }
              setState(() {
                // print("Index=$greaterMagnitudeIndex");
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

      // Timer(const Duration(seconds: 5), () async {
      //   await audioRecorder.cancel();
      //   audioRecorder.dispose();
      // });
    } else {
      await audioRecorder.cancel();
    }

    // micIsolate ??= await Isolate.spawn<Map>(
    //   isolateCode,
    //   {
    //     "token": rootToken,
    //     "sendPort": receivePort.sendPort,
    //   },
    // );

    // print("Criou a isolate lá");
    // await _isolateReady
    //     .future; // Espera a outra Isolate enviar a porta de comunicação
    // print("Esperou dar certo");

    // sendPort.send(recording);
  }
}
