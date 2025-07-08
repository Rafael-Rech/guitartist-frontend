import 'dart:math';

import 'package:tcc/model/Enum/e_lesson_type.dart';
import 'package:tcc/music_theory_components/exercise.dart';
import 'package:tcc/music_theory_components/exercise_builders/exercise_builder.dart';
import 'package:tcc/music_theory_components/listen_exercise.dart';
import 'package:tcc/music_theory_components/music_theory_components.dart';
import 'package:tcc/music_theory_components/note.dart';
import 'package:tcc/music_theory_components/note_location.dart';
import 'package:tcc/music_theory_components/option.dart';
import 'package:tcc/music_theory_components/play_exercise.dart';
import 'package:tcc/music_theory_components/quiz_exercise.dart';
import 'package:tcc/music_theory_components/scale.dart';

class ScaleExerciseBuilder implements ExerciseBuilder {
  ScaleExerciseBuilder(this._type, this._nameOption) {
    _nameOption =
        (_nameOption != 0 && _nameOption != 1) ? _rng.nextInt(2) : _nameOption;
  }

  final Random _rng = Random();
  final ELessonType _type;
  int _nameOption;
  List<int> scalesIndexes = [],
      highlightedScalesIndexes = [],
      allScalesIndexes = [];

  Scale _getValidScale() {
    return MusicTheoryComponents
        .scales[allScalesIndexes[_rng.nextInt(allScalesIndexes.length)]];
  }

  Scale _getAnyScale() {
    if (allScalesIndexes.length >= 4) {
      return MusicTheoryComponents
          .scales[allScalesIndexes[_rng.nextInt(allScalesIndexes.length)]];
    }
    return MusicTheoryComponents
        .scales[_rng.nextInt(MusicTheoryComponents.scales.length)];
  }

  List<Option> _generateOptions(Option correctOption, String property) {
    List<Option> options = [correctOption];

    while (options.length < 4) {
      if (property == "scaleName") {
        Scale newScale = _getAnyScale();
        bool isAlreadyAnOption = false;
        for (Option o in options) {
          if (o.text == newScale.name) {
            isAlreadyAnOption = true;
          }
        }
        if (!isAlreadyAnOption) {
          options.add(Option(false, newScale.name));
        }
      }
    }
    options.shuffle();

    return options;
  }

  @override
  Exercise buildExercise(List<int> scales, List<int> highlightedScales) {
    scalesIndexes = scales;
    highlightedScalesIndexes = highlightedScales;
    for (int scaleIndex in scalesIndexes) {
      allScalesIndexes.add(scaleIndex);
    }
    for (int highlightedScaleIndex in highlightedScalesIndexes) {
      allScalesIndexes.add(highlightedScaleIndex);
      allScalesIndexes.add(highlightedScaleIndex);
    }

    String? question;
    Scale scale = _getValidScale();
    switch (_type) {
      case ELessonType.listening:
        Note baseNote = MusicTheoryComponents.note;
        question =
            "Qual escala de ${baseNote.names[_nameOption]} está sendo tocada?";
        List<Option> options =
            _generateOptions(Option(true, scale.name), "scaleName");
        List<String> audios = [];
        int fret = 50, string = -1, index = -1;
        for (int i = 0; i < baseNote.locations.length; i++) {
          NoteLocation location = baseNote.locations[i];
          if (location.string > string && location.fret < fret) {
            string = location.string;
            fret = location.fret;
            index = i;
          }
        }
        NoteLocation baseNoteLocation = baseNote.locations[index];
        List<NoteLocation>? locations =
            scale.calculateLocations(baseNoteLocation);
        if (locations == null) {
          throw Exception("locations is null");
        }
        for (NoteLocation location in locations) {
          audios.add(location.audioPath);
        }
        return ListenExercise(question, options, audios, false);
      case ELessonType.quiz:
        return ((scales.length + highlightedScales.length < 4 ||
                _rng.nextBool())
            ? _recognizeNotesExercise(scale)
            : _recognizeScaleExercise(scale));
      case ELessonType.playing:
        return PlayExercise("", []);
    }
  }

  QuizExercise _recognizeNotesExercise(Scale scale) {
    Note baseNote = MusicTheoryComponents
        .notes[_rng.nextInt(MusicTheoryComponents.notes.length)];
    List<Note> notes = scale.calculateNotes(baseNote);
    String correctOptionText =
        ExerciseBuilder.generateNoteOptionText(notes, _nameOption);
    List<Option> options = [Option(true, correctOptionText)];
    List<Scale> scales = [scale];
    while (options.length < 4 && scales.length < 4) {
      Scale newScale = MusicTheoryComponents
          .scales[_rng.nextInt(MusicTheoryComponents.scales.length)];
      if (!scales.contains(newScale)) {
        scales.add(newScale);
        options.add(Option(
            false,
            ExerciseBuilder.generateNoteOptionText(
                newScale.calculateNotes(baseNote), _nameOption)));
      }
    }
    options.shuffle();
    String question =
        "Quais notas formam a ${scale.name} de ${baseNote.names[_nameOption]}?";
    return QuizExercise(question, options);
  }

  QuizExercise _recognizeScaleExercise(Scale scale) {
    Note baseNote = MusicTheoryComponents
        .notes[_rng.nextInt(MusicTheoryComponents.notes.length)];
    List<Note> correctNotes = scale.calculateNotes(baseNote);
    String question = "Qual escala de ";
    question += baseNote.names[_nameOption];
    question += " é formada pelas notas ";
    question +=
        ExerciseBuilder.generateNoteOptionText(correctNotes, _nameOption);
    question += "?";

    List<Option> options = [Option(true, scale.name)];
    List<Scale> scales = [scale];

    while (options.length < 4) {
      Scale newScale = MusicTheoryComponents
          .scales[_rng.nextInt(MusicTheoryComponents.scales.length)];
      if (!scales.contains(newScale)) {
        scales.add(newScale);
        options.add(Option(false, newScale.name));
      }
    }

    options.shuffle();

    return QuizExercise(question, options);
  }
}
