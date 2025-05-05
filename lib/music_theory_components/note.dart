import 'package:tcc/music_theory_components/note_location.dart';

// Keeps information of a single note
class Note {
  Note(
    this.id,
    this.names,
    this.alternativeNames,
    this.frequencies,
    this.audioPaths,
    this.locations,
  );

  int id; // Variando de 0 (C) a 11 (B)
  List<String> names;
  List<String>? alternativeNames;
  List<int> frequencies;
  List<String> audioPaths;
  List<NoteLocation> locations;

  @override
  String toString() {
    return "$id - ${names[0]}, frequencies - $frequencies, locations - $locations";
  }
}
