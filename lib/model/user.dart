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
    Map<String, dynamic> map = {
      "name": name,
      "password": password,
      "email": email,
      "id" : id,
      "appVersion": appVersion,
      "lessons": lessons,
      "time": time,
      "profilePicture" : profilePicture,
      "noteRepresentation" : noteRepresentation
    };
    return map;
  }
}
