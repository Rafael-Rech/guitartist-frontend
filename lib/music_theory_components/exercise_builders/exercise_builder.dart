import 'package:tcc/music_theory_components/exercise.dart';
import 'package:tcc/music_theory_components/option.dart';

abstract class ExerciseBuilder {
  Exercise buildExercise(List<int> components, List<int> highlightedComponents);

  List<Option> _generateOptions(Option correctOption, String property);
}
