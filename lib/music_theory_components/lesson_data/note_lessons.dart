import 'package:tcc/model/Enum/e_subject.dart';
import 'package:tcc/music_theory_components/lesson_data/lesson_data.dart';

class NoteLessons {
  NoteLessons() {
    _generateLessons();
  }

  final List<LessonData> _lessons = <LessonData>[];

  void _generateLessons() {
    final ESubject subject = ESubject.note;

    final List<String> names = [
      "Notas iniciais",
      "A nota Sol",
      "A nota Lá",
      "A nota Si",
      "Acidentes I",
      "Acidentes II",
      "Acidentes III",
      "Acidentes IV",
      "Acidentes V",
      "Revisão geral",
    ];
    final List<List<int>> components = [
      [0, 2, 4, 5],
      [0, 2, 4, 5],
      [0, 2, 4, 5, 7],
      [0, 2, 4, 5, 7, 9],
      [0, 2, 4, 5],
      [0, 2, 4, 5],
      [0, 1, 2, 4, 5, 7],
      [0, 1, 2, 3, 4, 5, 7, 9],
      [0, 1, 2, 3, 4, 5, 6, 7, 9, 11],
      List.generate(12, (index) => index),
    ];
    final List<List<int>> highlightedComponents = [
      [],
      [7],
      [9],
      [11],
      [1],
      [1, 3],
      [3, 6],
      [6, 8],
      [8, 10],
      [],
    ];
    for (int i = 0; i < names.length; i++) {
      _lessons.add(LessonData(
        i.toString().padLeft(4, "0"),
        names[i],
        subject,
        components[i],
        highlightedComponents[i],
      ));
    }
  }

  List<LessonData> get lessons {
    return _lessons;
  }
}
