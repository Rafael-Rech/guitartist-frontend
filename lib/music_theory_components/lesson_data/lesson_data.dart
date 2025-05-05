import 'package:tcc/model/Enum/e_subject.dart';

class LessonData {
  LessonData(this.id, this.name, this.subject, this.components, this.highlightedComponents);

  String id;
  String name;
  ESubject subject;
  List<int> components;
  List<int> highlightedComponents;
}