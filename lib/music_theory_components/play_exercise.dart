import 'package:tcc/music_theory_components/exercise.dart';

class PlayExercise implements Exercise {
  PlayExercise(this.question, this.frequenciesSequency);
  @override
  String question;
  List<List<int>> frequenciesSequency;

  @override
  String toString() {
    return "PlayExercise: $question - $frequenciesSequency";
  }
}
