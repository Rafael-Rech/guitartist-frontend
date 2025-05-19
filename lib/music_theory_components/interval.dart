import 'package:tcc/music_theory_components/music_theory_components.dart';
import 'package:tcc/music_theory_components/note.dart';
import 'package:tcc/music_theory_components/note_location.dart';

class Interval {
  Interval(this.id, this.name, this.distanceInHalfSteps);

  final int id;
  final String name;
  final int distanceInHalfSteps;

  Note calculateNote(Note baseNote) {
    List<Note> notes = MusicTheoryComponents.notes;
    int basePosition = -1;
    int targetPosition;
    for (int i = 0; i < notes.length; i++) {
      if (notes[i].id == baseNote.id) {
        basePosition = i;
      }
    }
    targetPosition = basePosition + distanceInHalfSteps % 12;
    return notes[targetPosition];
  }

  NoteLocation? calculateLocation(NoteLocation baseLocation) {
    int string = baseLocation.string;
    int fret = distanceInHalfSteps + baseLocation.fret;
    if (baseLocation.string == 1) {
      if (distanceInHalfSteps > 3) {
        string--;
        fret -= 5;
      }
    } else if (baseLocation.string == 2) {
      if (distanceInHalfSteps > 7) {
        string -= 2;
        fret -= 9;
      } else if (distanceInHalfSteps > 3) {
        string--;
        fret -= 4;
      }
    } else if (baseLocation.string == 3) {
      if (distanceInHalfSteps > 8) {
        string -= 2;
        fret -= 9;
      } else if (distanceInHalfSteps > 3) {
        string--;
        fret -= 5;
      }
    } else if(baseLocation.string >= 4){
      if(distanceInHalfSteps > 8){
        string-=2;
        fret-=10;
      } else if(distanceInHalfSteps > 3){
        string--;
        fret -= 5;
      }
    }
    if (fret > 22) {
      return null;
    }
    List<Note> notes = MusicTheoryComponents.notes;
    for (Note n in notes) {
      for (NoteLocation nl in n.locations) {
        if (fret == nl.fret && string == nl.string) {
          return nl;
        }
      }
    }
    return null;
  }

  @override
  String toString() {
    return "id = $id - name = $name, $distanceInHalfSteps half steps";
  }
}
