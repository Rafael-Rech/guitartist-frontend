import 'package:tcc/music_theory_components/exercise.dart';
import 'package:tcc/music_theory_components/option.dart';

class QuizExercise implements Exercise {
  QuizExercise(this.question, this.options);
  @override
  String question;
  final List<Option> options;

  @override
  String toString() => "ListenExercise: $question - $options";
}
