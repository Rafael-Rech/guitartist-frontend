import 'package:flutter/material.dart';
import 'package:tcc/global/my_colors.dart';

class LessonHelpPage extends StatelessWidget {
  const LessonHelpPage({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: MyColors.main5,
      ),
      body: Center(child: Text("Lesson ID: $lessonId"),),
    );
  }
}
