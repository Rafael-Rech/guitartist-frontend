import 'package:tcc/model/Enum/e_subject.dart';
import 'package:tcc/music_theory_components/lesson_data/lesson_data.dart';

class ScaleLessons {
  ScaleLessons() {
    _generateLessons();
  }

  final List<LessonData> _lessons = <LessonData>[];

  void _generateLessons() {
    final ESubject subject = ESubject.scale;
  }

  List<LessonData> get lessons {
    return _lessons;
  }
}
