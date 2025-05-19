import 'package:tcc/music_theory_components/exercise.dart';
import 'package:tcc/music_theory_components/option.dart';

class ListenExercise implements Exercise {
  ListenExercise(this.question, this.options, this.audioPaths, this.playAudiosAtSameTime);
  @override
  String question;
  List<Option> options;
  List<String> audioPaths;
  bool playAudiosAtSameTime;

  @override
  String toString() => "ListenExercise: $question - $options";
}
