import 'package:tcc/model/Enum/e_subject.dart';
import 'package:tcc/music_theory_components/lesson_data/lesson_data.dart';

class ScaleLessons {
  ScaleLessons() {
    _generateLessons();
  }

  final List<LessonData> _lessons = <LessonData>[];

  void _generateLessons() {
    final ESubject subject = ESubject.scale;

    List<String> names = [
      "Escalas Maiores",
      "A Escala Menor Natural",
      "A Escala Menor Harmônica",
      "A Escala Menor Melódica",
      "Escalas Pentatônicas I",
      "Escalas Pentatônicas II",
      "Revisão Geral"
    ];
    List<List<int>> scales = [
      [0, 1],
      [0, 1],
      [0, 1, 2],
      [0, 1, 2, 3],
      [0, 1, 2, 3, 4],
      [0, 1, 2, 3, 4, 5],
      [0, 1, 2, 3, 4, 5, 6]
    ];
    List<List<int>> highlightedScales = [
      [],
      [2],
      [3],
      [4],
      [5],
      [6],
      []
    ];

    int numberOfLessons =
        (names.length < scales.length) ? names.length : scales.length;
    if (highlightedScales.length < numberOfLessons) {
      numberOfLessons = highlightedScales.length;
    }

    for (int id = 0; id < numberOfLessons; id++) {
      _lessons.add(LessonData(
        (2000 + id).toString(),
        names[id],
        subject,
        scales[id],
        highlightedScales[id],
      ));
    }
  }

  List<LessonData> get lessons {
    return _lessons;
  }
}
