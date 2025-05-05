import 'package:tcc/helper/lesson_helper.dart';
import 'package:tcc/model/Enum/e_lesson_type.dart';
import 'package:tcc/model/Enum/e_subject.dart';

class Lesson {
  Lesson(this.subject, this.id, this.type, this.numberOfTries,
      this.averagePrecision, this.proficiency);
  ESubject subject;
  String id;
  ELessonType type;
  int numberOfTries;
  int averagePrecision;
  int proficiency;

  Map<String, dynamic> toMap() {
    int? subjectInt = subject.index;
    int? typeInt = type.index;
    Map<String, dynamic> map = {
      LessonHelper.averagePrecision : averagePrecision,
      LessonHelper.id : id,
      LessonHelper.numberOfTries : numberOfTries,
      LessonHelper.proficiency : proficiency,
      LessonHelper.subject : subjectInt,
      LessonHelper.type : typeInt,
    };
    return map;
  }
}
