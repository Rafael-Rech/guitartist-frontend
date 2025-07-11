import 'package:sqflite/sqflite.dart';
import 'package:tcc/helper/token_helper.dart';
import 'package:tcc/model/Enum/e_lesson_type.dart';
import 'package:tcc/model/Enum/e_subject.dart';
import 'package:tcc/model/lesson.dart';

abstract class LessonHelper {
  static const String lessonTable = "lessonTable";
  static const String subject = "subject";
  static const String id = "id";
  static const String type = "type";
  static const String numberOfTries = "numberOfTries";
  static const String averagePrecision = "averagePrecision";
  static const String proficiency = "proficiency";

  static Future<Database> get db async {
    return TokenHelper.internal().db;
  }

  static Future<List<Lesson>> getLessons(String userId) async {
    Database database = await db;
    List<Map<String, dynamic>> listMap = await database
        .rawQuery("SELECT * FROM $lessonTable l WHERE l.userId = ?", [userId]);
    List<Lesson> lessons = [];
    for (Map<String, dynamic> map in listMap) {
      lessons.add(mapToLesson(map));
    }
    return lessons;
  }

  static Future<Lesson?> getLesson(String userId, String lessonId) async {
    Database database = await db;
    List<Map<String, dynamic>> listMap = await database.rawQuery(
        "SELECT * FROM $lessonTable WHERE userId = ? AND id = ?",
        [userId, lessonId]);
    List<Lesson> lessons = [];
    for (Map<String, dynamic> map in listMap) {
      lessons.add(mapToLesson(map));
    }
    if (lessons.isEmpty) {
      return null;
    }
    return lessons.first;
  }

  static Future<void> saveLesson(Lesson lesson, String userId) async {
    Database database = await db;
    Map<String, dynamic> map = lesson.toMap();
    map["userId"] = userId;
    await database.insert(lessonTable, map);
  }

  static Future<void> updateLesson(Lesson lesson, String userId) async {
    Database database = await db;
    Map<String, dynamic> map = lesson.toMap();
    await database
        .update(lessonTable, map, where: "id = ?", whereArgs: [lesson.id]);
  }

  static Future<void> deleteLesson(String userId, String lessonId) async {
    Database database = await db;
    await database.delete(
      lessonTable,
      where: "userId = ? AND id = ?",
      whereArgs: [userId, lessonId],
    );
  }

  static Future<void> deleteLessons(String userId) async {
    Database database = await db;
    await database
        .delete(lessonTable, where: "userId = ?", whereArgs: [userId]);
  }

  static Future<void> deleteAllLessons() async {
    Database database = await db;
    await database.delete(lessonTable);
  }

  static Lesson mapToLesson(Map<String, dynamic> map) {
    late final ESubject subjectEnum;
    late final ELessonType typeEnum;
    for(var k in [subject, type]){
      if(map[k].runtimeType == int){
        (k == subject)? subjectEnum = ESubject.values[map[subject]] : typeEnum = ELessonType.values[map[type]];
      } else if(map[k].runtimeType == String){
        if(k == subject){
          for(var value in ESubject.values){
            if(value.backendDescription.toUpperCase() == map[k].toUpperCase()){
              subjectEnum = value;
            }
          }
        } else {
          for(var value in ELessonType.values){
            if(value.backendDescription.toUpperCase() == map[k].toUpperCase()){
              typeEnum = value;
            }
          }
        }
      }
    }

    return Lesson(
      subjectEnum,
      (map["id"].runtimeType == int)? map["id"].toString().padLeft(4, "0") : map["id"],
      typeEnum,
      map[numberOfTries],
      map[averagePrecision],
      map[proficiency],
    );
  }
}
