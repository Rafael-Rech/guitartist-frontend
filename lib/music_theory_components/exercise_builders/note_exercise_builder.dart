// Generate exercises for notes
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

class NoteExerciseBuilder implements ExerciseBuilder {
  NoteExerciseBuilder(this._type, this._nameOption) {
    _nameOption =
        (_nameOption != 0 && _nameOption != 1) ? _rng.nextInt(2) : _nameOption;
  }

  final Random _rng = Random();
  final ELessonType _type;
  int _nameOption;
  List<int> notesIndexes = [],
      highlightedNotesIndexes = [],
      allNotesIndexes = [];

  Note _getValidNote() {
    return MusicTheoryComponents.notes[allNotesIndexes[_rng.nextInt(allNotesIndexes.length)]];
  }

  // Generate wrong options for an exercise
  List<Option> _generateOptions(Option correctOption, String property) {
    final List<Option> options = [];
    options.add(correctOption);

    // The exercises must have four different options
    while (options.length < 4) {
      Note wrongNote = _getValidNote();
      String? wrongNoteProperty;
      bool isAlreadyAnOption = false;

      if (property == "name") {
        // If the answer for the exercise is a name, set it
        wrongNoteProperty = wrongNote.names[_nameOption];
      } else if (property == "fret") {
        // If the answer is a fret,
        var fret = _rng.nextInt(22);
        var correctFret = int.tryParse(correctOption.text);
        if (correctFret != null) {
          // Verifies if the generated fret represents the same note as the correct one
          while (fret % 12 == correctFret % 12) {
            fret = _rng.nextInt(22);
          }
        }

        wrongNoteProperty = "$fret";
      } else {
        throw Exception("Invalid property");
      }

      // Check if the wrong option is already among the options
      for (Option option in options) {
        if (option.text == wrongNoteProperty) {
          isAlreadyAnOption = true;
        }
      }
      if (!isAlreadyAnOption) {
        options.add(Option(false, wrongNoteProperty));
      }
    }
    options.shuffle();

    return options;
  }

  @override
  Exercise buildExercise(List<int> notes, List<int> highlightedNotes) {
    notesIndexes = notes;
    highlightedNotesIndexes = highlightedNotes;
    allNotesIndexes = [];
    for (int noteIndex in notesIndexes) {
      allNotesIndexes.add(noteIndex);
    }
    for (int highlightedNoteIndex in highlightedNotesIndexes) {
      allNotesIndexes.add(highlightedNoteIndex);
      allNotesIndexes.add(highlightedNoteIndex);
    }

    String? question;
    Note? note = _getValidNote();
    String noteName = note.names[_nameOption];
    switch (_type) {
      case ELessonType.listening:
        List<Option> options = _generateOptions(Option(true, noteName), "name");
        question = "Qual é a nota que está sendo tocada?";

        final location = note.locations[_rng.nextInt(note.locations.length)];
        final path = location.audioPath;
        return ListenExercise(question, options, [path], false);
      case ELessonType.quiz:
        NoteLocation location =
            note.locations[_rng.nextInt(note.locations.length)];
        List<Option> options = [];
        if (_rng.nextBool()) {
          // Identify a note by its fret and string
          question =
              "Qual é a nota presente na casa ${location.fret} da corda ${location.stringName}?";
          options = _generateOptions(Option(true, noteName), "name");
        } else {
          // Given a note and a string, guess the fret
          question =
              "Em qual casa da corda ${location.stringName} a nota $noteName está localizada?";
          options = _generateOptions(Option(true, "${location.fret}"), "fret");
        }
        return QuizExercise(question, options);
      case ELessonType.playing:
        List<List<int>> frequenciesSequency = [];

        if (_rng.nextBool()) {
          // Play the note on any string and fret

          question = "Toque a nota ${note.names[_nameOption]}";
          List<int> frequencies = List.from(note.frequencies);
          frequenciesSequency.add(frequencies);
        } else {
          // Play the note on a specific string and fret
          int position = 0;
          if (note.locations.isEmpty) {
            throw Exception("Empty list of locations");
          }
          position = _rng.nextInt(note.locations.length);
          late NoteLocation location = note.locations[position];
          final int correctFrequency = location.frequency;
          frequenciesSequency.add(<int>[correctFrequency]);
          question =
              "Toque a nota ${note.names[_nameOption]} na corda ${location.stringName}";
        }
        return PlayExercise(question, frequenciesSequency);
    }
  }
}
