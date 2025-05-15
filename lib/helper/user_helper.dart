import 'package:tcc/helper/lesson_helper.dart';
import 'package:tcc/helper/token_helper.dart';

import '../model/lesson.dart';
import '../model/user.dart';
import 'package:sqflite/sqflite.dart';

abstract class UserHelper {
  static const String userTable = "userTable";
  static const String name = "name";
  static const String password = "password";
  static const String email = "email";
  static const String id = "id";
  static const String appVersion = "appVersion";
  static const String time = "time";
  static const String lessons = "lessons"; // ?
  static const String profilePicture = "profilePicture";
  static const String noteRepresentation = "noteRepresentation";

  static Future<Database> get db async {
    return TokenHelper.internal().db;
  }

  static Future<User?> getUser() async {
    Database database = await db;
    List<Map> listMap = await database.rawQuery("SELECT * FROM $userTable");
    print("listMap no getUser local e seu tipo: $listMap, ${listMap.runtimeType}");
    Map map = Map.of(listMap.first);
    if (listMap.isNotEmpty && map.containsKey("id")) {
      List<Lesson> lessons = await LessonHelper.getLessons(map["id"]);
      // map.putIfAbsent("lessons", () => lessons);
      print("Lessons no banco local: $lessons");
      map["lessons"] = lessons;
      return mapToUser(map);
    }
    return null;
  }

  static Future<void> deleteUser() async {
    Database database = await db;
    await database.delete(LessonHelper.lessonTable); 
    await database.delete(userTable);
  }

  static Future<void> saveUser(User user) async {
    Database database = await db;
    await deleteUser();
    List<Lesson> lessons = user.lessons;
    Map<String, dynamic> map = user.toMap();
    map.remove("lessons");
    await database.insert(userTable, map);
    if (user.id != null) {
      for (Lesson l in lessons) {
        await LessonHelper.saveLesson(l, user.id!);
      }
    }
  }

  static User mapToUser(Map map) {
    List<Lesson> lessons = [];
    if (map.containsKey("lessons")) {
      for (var lesson in map["lessons"]) {
        if (lesson.runtimeType == Map) {
          lessons.add(LessonHelper.mapToLesson(lesson));
        } else if (lesson.runtimeType == Lesson) {
          lessons.add(lesson);
        } else {
          try{
            lesson = lesson as Map<String, dynamic>;
          } on Exception{
            throw Exception("Erro ao decodificar progresso de lição recebido");
          }
          lesson = LessonHelper.mapToLesson(lesson);
          lessons.add(lesson);
        }
      }
    }

    return User(
      map["name"],
      map.containsKey("password") ? map["password"] : null,
      map["email"],
      map.containsKey("id") ? map["id"] : null,
      map["appVersion"],
      lessons,
      map["time"],
      map.containsKey(profilePicture) ? map[profilePicture] : null,
      map[noteRepresentation]
    );
  }
}
