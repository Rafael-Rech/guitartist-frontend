import 'dart:math';

import 'package:tcc/model/Enum/e_lesson_type.dart';
import 'package:tcc/music_theory_components/exercise.dart';
import 'package:tcc/music_theory_components/exercise_builders/exercise_builder.dart';
import 'package:tcc/music_theory_components/listen_exercise.dart';
import 'package:tcc/music_theory_components/music_theory_components.dart';
import 'package:tcc/music_theory_components/note.dart';
import 'package:tcc/music_theory_components/note_location.dart';
import 'package:tcc/music_theory_components/option.dart';
import 'package:tcc/music_theory_components/interval.dart' as interval;

class IntervalExerciseBuilder implements ExerciseBuilder{
  IntervalExerciseBuilder(this._type, this._lessonId, this._nameOption) {
    _nameOption =
        (_nameOption != 0 && _nameOption != 1) ? _rng.nextInt(2) : _nameOption;
  }

  final Random _rng = Random();
  final ELessonType _type;
  String _lessonId;
  int _nameOption;
  List<int> intervalsIndexes = [], highlightedIntervalsIndexes = [], allIntervalsIndexes = [];

  interval.Interval _getValidInterval(){
    return MusicTheoryComponents.intervals[allIntervalsIndexes[_rng.nextInt(allIntervalsIndexes.length)]];
  }

  @override
  List<Option> _generateOptions(Option correctOption, String property) {
    // TODO: implement generateOptions
    throw UnimplementedError();
  }

  @override
  Exercise buildExercise(List<int> intervals, List<int> highlightedIntervals) {
    //TODO: Implement the other exercise types
    intervalsIndexes = intervals;
    highlightedIntervalsIndexes = highlightedIntervals;
    allIntervalsIndexes = [];
    for(int intervalIndex in intervalsIndexes){
      allIntervalsIndexes.add(intervalIndex);
    }
    for(int highlightedIntervalIndex in highlightedIntervalsIndexes){
      allIntervalsIndexes.add(highlightedIntervalIndex);
      allIntervalsIndexes.add(highlightedIntervalIndex);
    }

    String? question;
    interval.Interval i = _getValidInterval();
    String intervalName = i.name;
    Note firstNote = MusicTheoryComponents.notes[_rng.nextInt(MusicTheoryComponents.notes.length)];
    Note secondNote = i.calculateNote(firstNote); 
    switch(_type){
      case ELessonType.listening:
      List<Option> options = _generateOptions(Option(true, intervalName), "name");
      question = "Qual é o intervalo que está sendo tocado?";
      NoteLocation firstLocation = firstNote.locations[_rng.nextInt(firstNote.locations.length)];
      NoteLocation? secondLocation = i.calculateLocation(firstLocation);
      while(secondLocation == null){
        firstNote = MusicTheoryComponents.notes[_rng.nextInt(MusicTheoryComponents.notes.length)];
        secondNote = i.calculateNote(firstNote); 
        firstLocation = firstNote.locations[_rng.nextInt(firstNote.locations.length)];
        secondLocation = i.calculateLocation(firstLocation);
      }

      return ListenExercise(question, options, [firstLocation.audioPath, secondLocation.audioPath], false);
    }
  }
}