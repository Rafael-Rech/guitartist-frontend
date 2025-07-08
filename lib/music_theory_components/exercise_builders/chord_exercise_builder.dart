import 'dart:math';

import 'package:tcc/model/Enum/e_lesson_type.dart';
import 'package:tcc/music_theory_components/chord.dart';
import 'package:tcc/music_theory_components/exercise.dart';
import 'package:tcc/music_theory_components/exercise_builders/exercise_builder.dart';
import 'package:tcc/music_theory_components/interval.dart';
import 'package:tcc/music_theory_components/listen_exercise.dart';
import 'package:tcc/music_theory_components/music_theory_components.dart';
import 'package:tcc/music_theory_components/note.dart';
import 'package:tcc/music_theory_components/note_location.dart';
import 'package:tcc/music_theory_components/option.dart';
import 'package:tcc/music_theory_components/play_exercise.dart';
import 'package:tcc/music_theory_components/quiz_exercise.dart';
import 'package:tcc/music_theory_components/shape.dart';

class ChordExerciseBuilder implements ExerciseBuilder {
  ChordExerciseBuilder(this._type, this._nameOption) {
    _nameOption =
        (_nameOption != 0 && _nameOption != 1) ? _rng.nextInt(2) : _nameOption;
  }

  final Random _rng = Random();
  final ELessonType _type;
  int _nameOption;
  List<int> chordIndexes = [],
      highlightedChordIndexes = [],
      allChordIndexes = [];

  Chord _getValidChord() {
    return MusicTheoryComponents
        .chords[allChordIndexes[_rng.nextInt(allChordIndexes.length)]];
  }

  List<Option> _generateOptions(Option correctOption, String property, {Note? firstNote}) {
    List<Option> options = [correctOption];

    while (options.length < 4) {
      Chord newChord = _getValidChord();
      // List<Interval>? accumulatedIntervals = accumulateIntervals(newChord);
      List<Interval> accumulatedIntervals = newChord.accumulatedIntervals;
      String intervalsText = "";
      String newChordNotes = "";
      if(firstNote != null){
        newChordNotes = ExerciseBuilder.generateNoteOptionText(newChord.calculateNotes(firstNote), _nameOption);
      } else if (property == "notes"){
        throw Exception("Base note was not provided!");
      }
      bool insert = true;
      if(property == "intervals"){
        insert = false;
      } else if(property == "intervals"){
        intervalsText = ExerciseBuilder.generateIntervalOptionText(accumulatedIntervals);
      }
      for (Option option in options) {
        if (property == "name" && option.text == newChord.name) {
          insert = false;
        } else if(property == "notes" && option.text == newChordNotes){
          insert = false;
        } else if(property == "intervals" && option.text == intervalsText){
          insert = false;
        }
      }
      if (insert) {
        if(property == "name"){
          options.add(Option(false, newChord.name));
        } else if (property == "notes"){
          options.add(Option(false, newChordNotes));
        } else if(property == "intervals"){
          options.add(Option(false, intervalsText));
        }
      }
    }

    options.shuffle();

    return options;
  }

  Shape chooseShape(int chordId) {
    List<Shape> shapes = [];

    for (Shape s in Shape.values) {
      if (s.possibleChords.contains(chordId)) {
        shapes.add(s);
      }
    }

    if (shapes.isEmpty) {
      throw Exception("There's no shape for this chord!");
    }

    Shape shape = shapes[_rng.nextInt(shapes.length)];
    return shape;
  }

  NoteLocation getLocation(Note note, int stringIndex, int minimalFret) {
    NoteLocation? location;
    int fret = 50;
    for (NoteLocation l in note.locations) {
      if (l.string == stringIndex && l.fret >= minimalFret && l.fret < fret) {
        location = l;
        fret = l.fret;
      }
    }
    if (location == null) {
      throw Exception("Couldn't get location!");
    }
    return location;
  }

  List<String> getAudioPaths(Chord chord, Note firstNote) {
    List<String> paths = [];
    Shape shape = chooseShape(chord.id);
    List<int> intervalIndexes =
        shape.intervalsUsed[shape.possibleChords.indexOf(chord.id)];

    NoteLocation lastLocation =
        getLocation(firstNote, shape.startingString, shape.minimalStartingFret);
    paths.add(lastLocation.audioPath);

    for (int intervalIndex in intervalIndexes) {
      Interval interval = MusicTheoryComponents.intervals[intervalIndex];
      NoteLocation? newLocation = interval.calculateLocation(lastLocation);
      if (newLocation == null) {
        throw Exception(
            "Couldn't calculate location for chord ${chord.name} and note ${firstNote.names[_nameOption]}");
      }
      lastLocation = newLocation;
      paths.add(lastLocation.audioPath);
    }

    return paths;
  }

  @override
  Exercise buildExercise(List<int> chords, List<int> highlightedChords) {
    chordIndexes = chords;
    highlightedChordIndexes = highlightedChords;
    allChordIndexes = [];
    for (int chordIndex in chordIndexes) {
      allChordIndexes.add(chordIndex);
    }
    for (int highlightedChordIndex in highlightedChordIndexes) {
      allChordIndexes.add(highlightedChordIndex);
      allChordIndexes.add(highlightedChordIndex);
    }

    Chord chord = _getValidChord();
    switch (_type) {
      case ELessonType.listening:
        Note firstNote = MusicTheoryComponents.note;
        String question =
            "Qual é o acorde de ${firstNote.names[_nameOption]} que está sendo tocado?";
        List<Option> options =
            _generateOptions(Option(true, chord.name), "name");
        List<String> audioPaths = getAudioPaths(chord, firstNote);
        return ListenExercise(question, options, audioPaths, true);
      case ELessonType.quiz:
        return _rng.nextBool()? _guessNotesExercise(chord) : _guessIntervalsExercise(chord) ;
      case ELessonType.playing:
        Note firstNote = MusicTheoryComponents.note;
        String question = "Toque o acorde de ${firstNote.names[0]}.";
        List<List<int>> frequenciesSequency = [];
        frequenciesSequency.add(firstNote.frequencies);
        Note lastNote = firstNote;
        for (Interval interval in chord.intervals) {
          lastNote = interval.calculateNote(lastNote);
          frequenciesSequency.add(lastNote.frequencies);
        }
        return PlayExercise(question, frequenciesSequency);
    }
  }

  QuizExercise _guessNotesExercise(Chord chord){
    Note note = MusicTheoryComponents.note;
    String question = "Quais são as notas que formam o acorde ${note.names[0]}${chord.suffix}?";
    List<Note> notes = chord.calculateNotes(note);
    Option correctOption = Option(true, ExerciseBuilder.generateNoteOptionText(notes, _nameOption));
    List<Option> options = _generateOptions(correctOption, "notes", firstNote: note);
    return QuizExercise(question, options);
  }

  List<Interval>? accumulateIntervals(Chord chord){
    List<Interval> intervalsFromRootNote = [chord.intervals.first];
    for(int i = 1; i < chord.intervals.length; i++){
      Interval? accumulatedInterval = chord.intervals[i].addInterval(intervalsFromRootNote.last);
      if(accumulatedInterval == null){
        return null;
      }
      intervalsFromRootNote.add(accumulatedInterval);
    }
    return intervalsFromRootNote;
  }

  QuizExercise _guessIntervalsExercise(Chord chord){
    String question = "Quais são os intervalos, a partir da nota fundamental, que formam um Acorde ${chord.name}?";
    // List<Interval>? intervalsFromRootNote = accumulateIntervals(chord);
    List<Interval> intervalsFromRootNote = chord.accumulatedIntervals;
    Option correctOption = Option(true, ExerciseBuilder.generateIntervalOptionText(intervalsFromRootNote));
    List<Option> options = _generateOptions(correctOption, "intervals");
    return QuizExercise(question, options);
  }
}
