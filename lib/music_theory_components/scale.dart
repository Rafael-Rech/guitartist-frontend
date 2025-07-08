import 'package:tcc/music_theory_components/interval.dart';
import 'package:tcc/music_theory_components/music_theory_components.dart';
import 'package:tcc/music_theory_components/note.dart';
import 'package:tcc/music_theory_components/note_location.dart';

class Scale {
  Scale(this.id, this.name, this.formationRule) {
    _generateIntervals();
  }

  final int id;
  final String name;
  final String formationRule;
  late final List<Interval> intervals;

  void _generateIntervals() {
    intervals = <Interval>[];
    bool aggregate = false;
    int distance = 0;
    for (int i = 0; i < formationRule.length; i++) {
      switch (formationRule[i]) {
        case 'w':
        case 'W':
        case 't':
        case 'T':
          (aggregate)? distance += 2 : intervals.add(MusicTheoryComponents.intervals[2]);
          break;
        case 'h':
        case 'H':
        case 's':
        case 'S':
          (aggregate)? distance += 1 : intervals.add(MusicTheoryComponents.intervals[1]);
          break;
        case '(':
          if (aggregate == true) {
            throw Exception("Invalid formation rule");
          }
          aggregate = true;
          distance = 0;
          break;
        case ')':
          if (aggregate == false || distance > 4) {
            throw Exception("Invalid formation rule");
          }
          aggregate = false;
          intervals.add(MusicTheoryComponents.intervals[distance]);
          break;
        case '+':
          break;
        default:
          throw Exception("Invalid formation rule");
      }
    }
  }

  List<Note> calculateNotes(Note baseNote) {
    List<Note> notes = [baseNote];

    for (Interval interval in intervals) {
      Note newNote = interval.calculateNote(notes.last);
      notes.add(newNote);
    }

    return notes;
  }

  List<NoteLocation>? calculateLocations(NoteLocation baseLocation) {
    List<NoteLocation> locations = [baseLocation];

    for (Interval interval in intervals) {
      NoteLocation? newLocation = interval.calculateLocation(locations.last);
      if (newLocation == null) {
        return null;
      }
      locations.add(newLocation);
    }

    return locations;
  }
}
