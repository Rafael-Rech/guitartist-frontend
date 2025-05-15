import 'package:tcc/model/lesson.dart';

class User {
  User(this.name, this.password, this.email, this.id, this.appVersion,
      this.lessons, this.time, this.profilePicture, this.noteRepresentation);

  String name;
  String? password;
  String email;
  String? id;
  int appVersion;
  List<Lesson> lessons;
  String time;
  String? profilePicture;
  int noteRepresentation;

  Map<String, dynamic> toMap() {
    List<Map> mapLessons = [];
    for(Lesson l in lessons){
      mapLessons.add(l.toMap());
    }
    Map<String, dynamic> map = {
      "name": name,
      "password": password,
      "email": email,
      "id" : id,
      "appVersion": appVersion,
      // "lessons": lessons,
      "lessons": mapLessons,
      "time": time,
      "profilePicture" : profilePicture,
      "noteRepresentation" : noteRepresentation
    };
    return map;
  }

  @override
  String toString(){
    return "(id = $id, lessons = $lessons)";
  }
}
