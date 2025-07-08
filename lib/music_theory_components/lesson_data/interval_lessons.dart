import 'package:tcc/model/Enum/e_subject.dart';
import 'package:tcc/music_theory_components/lesson_data/lesson_data.dart';

class IntervalLessons {
  IntervalLessons() {
    _generateLessons();
  }

  final List<LessonData> _lessons = <LessonData>[];

  void _generateLessons() {
    final ESubject subject = ESubject.interval;

    List<String> names = [
      "Intervalos de Segunda e Terça",
      "Intervalos de Quarta",
      "Intervalos de Quinta",
      "Intervalos de Sexta",
      "Intervalos de Sétima",
      "Intervalos de Uníssono e Oitava",
      "Intervalos compostos: Nona",
      "Intervalos compostos: Décima",
      "Intervalos compostos: Décima Primeira",
      "Intervalos compostos: Décima Segunda",
      "Intervalos compostos: Décima Terceira",
      "Revisão Geral"
    ];

    final List<List<int>> intervals = [
      List.generate(4, (i) => i + 1),
      List.generate(4, (i) => i + 1),
      List.generate(6, (i) => i + 1),
      List.generate(8, (i) => i + 1),
      List.generate(10, (i) => i + 1),
      List.generate(12, (i) => i + 1),
      List.generate(14, (i) => i),
      List.generate(16, (i) => i),
      List.generate(18, (i) => i),
      List.generate(20, (i) => i),
      List.generate(22, (i) => i),
      List.generate(24, (i) => i),
    ];
    final List<List<int>> highlightedIntervals = [
      [],
      [5,6],
      [7,8],
      [9,10],
      [11,12],
      [0,13],
      [14,15],
      [16,17],
      [18,19],
      [20,21],
      [22,23],
      []
    ];

    for(int id = 0; id < names.length; id++){
      _lessons.add(LessonData("${1000 + id}", names[id], subject, intervals[id], highlightedIntervals[id]));
    }
  }

  List<LessonData> get lessons {
    return _lessons;
  }
}
