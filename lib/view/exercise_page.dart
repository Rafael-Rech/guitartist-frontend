import 'package:flutter/material.dart';
import 'package:tcc/global/e_result.dart';
import 'package:tcc/helper/lesson_helper.dart';
import 'package:tcc/helper/user_helper.dart';
import 'package:tcc/model/Enum/e_lesson_type.dart';
import 'package:tcc/model/Enum/e_subject.dart';
import 'package:tcc/model/lesson.dart';
import 'package:tcc/model/user.dart';
import 'package:tcc/music_theory_components/exercise.dart';
import 'package:tcc/service/user_service.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage(this.id, this.exercises, this.index,
      {super.key,
      required this.answersProvided,
      required this.correctAnswersProvided,
      required this.timeSpent,
      required this.subject});

  final String id;
  final List<Exercise> exercises;
  final int index;
  final int answersProvided;
  final int correctAnswersProvided;
  final Duration timeSpent;
  final ESubject subject;

  final Duration answerToPushDuration = const Duration(milliseconds: 1500);

  static Route createAnimatedRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;

        var curve = Curves.ease;
        var curveTween = CurveTween(curve: curve);

        final tween = Tween(begin: begin, end: end).chain(curveTween);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 1000),
    );
  }

  Future<EResult?> updateProgress(int precisionInThisAttempt, Duration timeSpent,
      ELessonType lessonType) async {
    User? user = await UserHelper.getUser();
    if (user == null) {
      return EResult.noUser;
    }
    String? userId = user.id;
    if (userId == null) {
      return EResult.noUserId;
    }
    Lesson? lesson = await LessonHelper.getLesson(userId, id);

    int averagePrecision, proficiency;
    if (lesson == null) {
      // It's the first time the user completes this lesson
      averagePrecision = precisionInThisAttempt;
      proficiency = averagePrecision ~/ timeSpent.inSeconds;
      lesson = Lesson(
        subject,
        id,
        lessonType,
        1,
        averagePrecision,
        proficiency,
      );
      await LessonHelper.saveLesson(lesson, userId);
    } else {
      // The user has already completed the lesson
      int numberOfTries = lesson.numberOfTries;
      averagePrecision =
          ((numberOfTries * lesson.averagePrecision) + precisionInThisAttempt);
      averagePrecision = averagePrecision ~/ (numberOfTries + 1);
      proficiency = ((precisionInThisAttempt / timeSpent.inSeconds) * 10 +
              lesson.proficiency)
          .ceil();
      if (proficiency > 100) {
        proficiency = 100;
      }
      lesson.numberOfTries++;
      lesson.averagePrecision = averagePrecision;
      lesson.proficiency = proficiency;
      await LessonHelper.updateLesson(lesson, userId);
    }

    user = await UserHelper.getUser();
    if (user == null) {
      return EResult.noUser;
    }
    final EResult result = await update(user);
    if (result != EResult.ok) {
      return result;
    }
    return null;
  }

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
