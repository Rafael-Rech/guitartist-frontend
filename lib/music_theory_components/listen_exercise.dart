import 'package:tcc/music_theory_components/exercise.dart';
import 'package:tcc/music_theory_components/option.dart';

class ListenExercise implements Exercise {
  ListenExercise(this.question, this.options, this.audioPath);
  @override
  String question;
  List<Option> options;
  String audioPath;

  @override
  String toString() => "ListenExercise: $question - $options";
}
