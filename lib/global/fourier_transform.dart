import 'dart:typed_data';

import 'package:fftea/impl.dart';

class FourierTransform{
  FourierTransform._(this._fft);

  static FourierTransform? _instance;
  Radix2FFT? _fft;

  static FourierTransform get instance{
    _instance ??= FourierTransform._(Radix2FFT(32768));
    // _instance ??= FourierTransform._(Radix2FFT(1024));
    return _instance!;
  }

  Float64x2List realFft(List<double> reals){
    if(_fft == null) {
      throw Exception("FFT Error");
    }
  
    return _fft!.realFft(reals);
  }

  double frequency(int index, double samplesPerSecond){
    if(_fft == null) {
      throw Exception("FFT Error");
    }
    return _fft!.frequency(index, samplesPerSecond);
  }

}