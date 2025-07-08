import 'package:tcc/music_theory_components/interval.dart';
import 'package:tcc/music_theory_components/music_theory_components.dart';
import 'package:tcc/music_theory_components/note.dart';
import 'package:tcc/music_theory_components/shape.dart';

class Chord {
  Chord(this.id, this.name, this.suffix, this.intervals, this.accumulatedIntervals);

  final int id;
  final String name;
  final String suffix;
  final List<Interval> intervals;
  final List<Interval> accumulatedIntervals;

  List<Note> calculateNotes(Note baseNote, {Shape? shape}) {
    List<Note> notes = [baseNote];
    int shapeInternalIndex = -1;
    if(shape != null){
      shapeInternalIndex = shape.possibleChords.indexOf(id);
    }

    if (shape == null || shapeInternalIndex == -1) {
      for (Interval interval in intervals) {
        Note newNote = interval.calculateNote(notes.last);
        notes.add(newNote);
      }
    } else {
      List<int> shapeIndexes = shape.intervalsUsed[shapeInternalIndex];
      List<Interval> shapeIntervals = List.generate(shapeIndexes.length, (i) => MusicTheoryComponents.intervals[i]);
      for(Interval interval in shapeIntervals){
        Note newNote = interval.calculateNote(notes.last);
        notes.add(newNote);
      }
    }

    final List<String> names = [];
    for(Note n in notes){
      names.add(n.names[0]);
    }

    // print("Notas do acorde de ${baseNote.names[0]}$suffix: $names");

    return notes;
  }
}
