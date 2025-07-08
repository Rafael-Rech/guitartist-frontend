import 'package:tcc/music_theory_components/exercise.dart';
import 'package:tcc/music_theory_components/interval.dart';
import 'package:tcc/music_theory_components/note.dart';

abstract class ExerciseBuilder {
  Exercise buildExercise(List<int> components, List<int> highlightedComponents);


  static String generateNoteOptionText(List<Note> notes, int nameOption) {
    String optionText = "";
    for (int i = 0; i < notes.length; i++) {
      optionText += notes[i].names[ nameOption];
      if (i < notes.length - 2) {
        optionText += ", ";
      } else if(i < notes.length - 1){
        optionText += " e ";
      }
    }
    return optionText;
  }

    static String generateIntervalOptionText(List<Interval> intervals) {
    String optionText = "";
    for (int i = 0; i < intervals.length; i++) {
      optionText += intervals[i].name;
      if (i < intervals.length - 2) {
        optionText += ", ";
      } else if(i < intervals.length - 1){
        optionText += " e ";
      }
    }
    return optionText;
  }
}
