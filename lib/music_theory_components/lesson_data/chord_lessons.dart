import 'package:tcc/model/Enum/e_subject.dart';
import 'package:tcc/music_theory_components/lesson_data/lesson_data.dart';

class ChordLessons {
  ChordLessons() {
    _generateLessons();
  }

  final List<LessonData> _lessons = <LessonData>[];

  void _generateLessons() {
    final ESubject subject = ESubject.chord;

    final List<String> names = [
      "Tríades",
      "Acordes de Sétima I",
      "Acordes de Sétima II",
      "Acordes de Sétima Maior I",
      "Acordes de Sétima Maior II",
      "Power Chords",
      "Acordes com Nona",
      "Revisão Geral"
    ];

    final List<List<int>> chords = [
      [0, 1, 2, 3],
      [0, 1, 2, 3],
      [0, 1, 2, 3, 5],
      [0, 1, 2, 3, 5, 7],
      [0, 1, 2, 3, 4, 5, 7],
      List.generate(8, (i) => i),
      List.generate(9, (i) => i),
      List.generate(10, (i) => i),
    ];
    final List<List<int>> highlightedChords = [
      [],
      [5],
      [7],
      [4],
      [6],
      [8],
      [9],
      [],
    ];

    int numberOfLessons =
        names.length < chords.length ? names.length : chords.length;
    if (highlightedChords.length < numberOfLessons) {
      numberOfLessons = highlightedChords.length;
    }

    for (int id = 0; id < numberOfLessons; id++) {
      _lessons.add(LessonData("${3000 + id}", names[id], subject, chords[id],
          highlightedChords[id]));
    }
  }

  List<LessonData> get lessons {
    return _lessons;
  }
}
