import 'package:tcc/model/Enum/e_subject.dart';
import 'package:tcc/music_theory_components/lesson_data/lesson_data.dart';

class ScaleLessons {
  ScaleLessons() {
    _generateLessons();
  }

  final List<LessonData> _lessons = <LessonData>[];

  void _generateLessons() {
    final ESubject subject = ESubject.scale;

    List<String> names = ["A Escala Maior Natural"];
    List<List<int>> scales = [
      [0],
    ];
    List<List<int>> highlightedScales = [
      [],
    ];

    int size = (names.length < scales.length) ? names.length : scales.length;
    if (highlightedScales.length < size) {
      size = highlightedScales.length;
    }

    for (int id = 0; id < size; id++) {
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
