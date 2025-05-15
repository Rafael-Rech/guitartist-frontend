// Represents the location of a note in the guitar fretboard
class NoteLocation {
  NoteLocation(this.string, this.fret, this.frequency, this.audioPath, this.octave);

  int string; // Variando de 0 (e) a 5 (E)
  int fret;
  int frequency;
  String audioPath;
  int octave;

  String? get stringName {
    switch (string) {
      case 0:
        return "e";
      case 1:
        return "B";
      case 2:
        return "G";
      case 3:
        return "D";
      case 4:
        return "A";
      case 5:
        return "E";
    }
    return null;
  }

  int get stringNumber {
    return (string + 1);
  }

  @override
  String toString() {
    return "Location: $string - $fret";
  }
}
