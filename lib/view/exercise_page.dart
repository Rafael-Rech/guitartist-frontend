import 'package:flutter/material.dart';
import 'package:tcc/model/Enum/e_subject.dart';
import 'package:tcc/music_theory_components/exercise.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage(this.id, this.exercises, this.index, {super.key, required this.answersProvided, required this.correctAnswersProvided, required this.timeSpent, required this.subject});

  final String id;
  final List<Exercise> exercises;
  final int index;
  final int answersProvided;
  final int correctAnswersProvided;
  final Duration timeSpent;
  final ESubject subject;

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

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}