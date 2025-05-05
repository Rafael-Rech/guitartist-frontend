import 'dart:math';

import 'package:tcc/model/Enum/e_lesson_type.dart';
import 'package:tcc/music_theory_components/chord.dart';
import 'package:tcc/music_theory_components/exercise.dart';
import 'package:tcc/music_theory_components/exercise_builders/exercise_builder.dart';
import 'package:tcc/music_theory_components/option.dart';

class ChordExerciseBuilder implements ExerciseBuilder {
  ChordExerciseBuilder(this._type, this._lessonId, this._nameOption) {
    _generateValidChords();
    _nameOption =
        (_nameOption != 0 && _nameOption != 1) ? _rng.nextInt(2) : _nameOption;
  }

  final Random _rng = Random();
  final ELessonType _type;
  String _lessonId;
  int _nameOption;
  List<Chord> _validNotes = <Chord>[];

  void _generateValidChords(){

  }

  @override
  Exercise buildExercise(List<int> chords, List<int> highlightedChords) {
    // TODO: implement buildExercise
    throw UnimplementedError();
  }

  @override
  List<Option> _generateOptions(Option correctOption, String property) {
    // TODO: implement generateOptions
    throw UnimplementedError();
  }
}
