import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tcc/model/Enum/e_lesson_type.dart';
import 'package:tcc/music_theory_components/exercise.dart';
import 'package:tcc/music_theory_components/exercise_builders/exercise_builder.dart';
import 'package:tcc/music_theory_components/option.dart';

class IntervalExerciseBuilder implements ExerciseBuilder{
  IntervalExerciseBuilder(this._type, this._lessonId, this._nameOption) {
    _generateValidIntervals();
    _nameOption =
        (_nameOption != 0 && _nameOption != 1) ? _rng.nextInt(2) : _nameOption;
  }

  final Random _rng = Random();
  final ELessonType _type;
  String _lessonId;
  int _nameOption;
  List<Interval> _validNotes = <Interval>[];

  void _generateValidIntervals(){

  }

  @override
  Exercise buildExercise(List<int> intervals, List<int> highlightedIntervals) {
    // TODO: implement buildExercise
    throw UnimplementedError();
  }

  @override
  List<Option> _generateOptions(Option correctOption, String property) {
    // TODO: implement generateOptions
    throw UnimplementedError();
  }
}