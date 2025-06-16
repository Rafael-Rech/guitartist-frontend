import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tcc/global/my_colors.dart';

class AnswerOption extends StatelessWidget {
  const AnswerOption({
    super.key,
    required this.text,
    this.width,
    required this.height,
    required this.correct,
    required this.answered,
  });

  final bool answered;
  final bool correct;
  final String text;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: MyColors.dark,
          width: 5.0,
        ),
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: _getColors()),
      ),
      child: Center(
        child: AutoSizeText(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: MyColors.light,
            fontFamily: "Anonymous Pro",
            fontSize: 34.0,
          ),
          maxLines: 2,
        ),
      ),
    );
  }

  List<Color> _getColors() {
    if (!answered) {
      return [MyColors.darkPrimary, MyColors.brightPrimary];
    }
    if (correct) {
      return [const Color(0xFF18600A), const Color(0xFF28D806)];
    }
    return [const Color(0xFF662634), const Color(0xFFDE3E5F)];
  }
}
