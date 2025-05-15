// Organizes the components related to Music Theory
import 'package:tcc/music_theory_components/chord.dart';
import 'package:tcc/music_theory_components/interval.dart';
import 'package:tcc/music_theory_components/note.dart';
import 'package:tcc/music_theory_components/note_location.dart';
import 'package:tcc/music_theory_components/scale.dart';

abstract class MusicTheoryComponents {
  static final List<Note> _notes = [];
  static final List<Interval> _intervals = [];
  static final List<Scale> _scales = [];
  static final List<Chord> _chords = [];

  static List<Note> get notes {
    if (_notes.isEmpty) {
      generateNotes();
    }
    return _notes;
  }

  static List<Interval> get intervals {
    if (_intervals.isEmpty) {
      generateIntervals();
    }
    return _intervals;
  }

  static List<Scale> get scales {
    if (_scales.isEmpty) {
      generateScales();
    }
    return _scales;
  }

  static List<Chord> get chords {
    if (_chords.isEmpty) {
      generateChords();
    }
    return _chords;
  }

  // Build the Note objects
  static void generateNotes() {
    const List<List<String>> listOfNames = [
      ["C", "Dó"],
      ["C#", "Dó Sustenido"],
      ["D", "Ré"],
      ["D#", "Ré Sustenido"],
      ["E", "Mi"],
      ["F", "Fá"],
      ["F#", "Fá Sustenido"],
      ["G", "Sol"],
      ["G#", "Sol Sustenido"],
      ["A", "Lá"],
      ["A#", "Lá Sustenido"],
      ["B", "Si"],
    ];

    const List<List<String>?> listOfAlternativeNames = [
      null,
      ["Db", "Ré Bemol"],
      null,
      ["Eb", "Mi Bemol"],
      null,
      null,
      ["Gb", "Sol Bemol"],
      null,
      ["Ab", "Lá Bemol"],
      null,
      ["Bb", "Si Bemol"],
      null,
    ];

    const List<List<int>> listOfFrequencies = [
      [32, 65, 130, 261, 523, 1046],  // C
      [34, 69, 138, 277, 554, 1109],  // C#
      [36, 73, 146, 293, 587, 1175],  // D
      [38, 77, 155, 311, 622, 1245],  // D#
      [41, 82, 164, 329, 659, 1319],  // E
      [43, 87, 174, 349, 698, 1397],  // F
      [46, 92, 185, 369, 739, 1480],  // F#
      [49, 98, 196, 392, 784, 1568],  // G
      [52, 104, 208, 415, 830, 1661], // G#
      [55, 110, 220, 440, 880, 1760], // A
      [58, 116, 233, 466, 932, 1865], // A#
      [61, 123, 246, 493, 987, 1976], // B
    ];

    List<List<NoteLocation>> listOfLocations = [];
    for (int i = 0; i < 12; i++) { // Attributes an empty list to each note
      listOfLocations.add(<NoteLocation>[]);
    }
    // print("Antes do loop principal");
    for (int string = 0; string < 6; string++) {
      // Index of the note that sounds when the string is played without pressing it
      int startingNoteIndex = -1;
      int startingFrequency = -1;
      switch (string) {
        case 0: // e
          startingNoteIndex = 4;
          startingFrequency = 329;
          break;
        case 1: // B
          startingNoteIndex = 11;
          startingFrequency = 246;
          break;
        case 2: // G
          startingNoteIndex = 7;
          startingFrequency = 196;
          break;
        case 3: // D
          startingNoteIndex = 2;
          startingFrequency = 146;
          break;
        case 4: // A
          startingNoteIndex = 9;
          startingFrequency = 110;
          break;
        case 5: // E
          startingNoteIndex = 4;
          startingFrequency = 82;
      }

      int currentNoteIndex = startingNoteIndex;
      int currentFrequency = startingFrequency;
      int currentOctave = -1;

      for(int octave = 0; octave < listOfFrequencies[currentNoteIndex].length; octave++){
        if(listOfFrequencies[currentNoteIndex][octave] == startingFrequency){
          currentOctave = octave;
        }
      }

      // print("Achou a oitava atual");

      if(currentOctave == -1){
        throw Exception("Error finding octave");
      }

      // Calculate the locations of the notes
      for (int fret = 0; fret < 22; fret++) {
        // print("string = $string, fret = $fret, frequency = $currentFrequency");
        currentFrequency = listOfFrequencies[currentNoteIndex][currentOctave];
        // String audioPath = "assets/audio/notes/$string$fret.wav";
        String fretString = fret.toString().padLeft(2, '0');
        String audioPath = "assets/audio/notes/$string$fretString.mp3";

        // String audioPath = "assets/audio/notes/415.wav";
        // String audioPath = "assets/audio/beep.wav";
        listOfLocations[currentNoteIndex].add(NoteLocation(string, fret, currentFrequency, audioPath, currentOctave));
        currentNoteIndex = (currentNoteIndex + 1) % 12;
        if(currentNoteIndex == 0){
          currentOctave++;
        }
      }
    }

    // Generate the notes
    // print("Generating notes");
    for (int id = 0; id < 12; id++) {
      // print("note $id");
      final note = Note(
        id,
        listOfNames[id],
        listOfAlternativeNames[id],
        listOfFrequencies[id],
        listOfLocations[id],
      );
      //           print(note);
      _notes.add(note);
    }
    // print("Finished generating notes");
  }

  static void generateChords() {}
  static void generateIntervals() {}
  static void generateScales() {}
}
