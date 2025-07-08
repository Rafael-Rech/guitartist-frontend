
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tcc/global/alerts.dart';
import 'package:tcc/global/e_result.dart';
import 'package:tcc/global/my_colors.dart';
import 'package:tcc/helper/user_helper.dart';
import 'package:tcc/model/Enum/e_subject.dart';
import 'package:tcc/model/user.dart';
import 'package:tcc/view/lesson_info_page.dart';


class LessonMenuButton extends StatefulWidget {
  const LessonMenuButton({
    super.key,
    required this.lessonName,
    required this.lessonId,
    required this.width,
    required this.height,
    required this.locked,
    required this.subject,
    required this.components,
    required this.highlightedComponents,
    required this.precision,
    required this.tries,
    required this.proficiency,
    required this.darkMode,
  });

  final bool darkMode;
  final String lessonName;
  final String lessonId;
  final double width;
  final double height;
  final bool locked;
  final ESubject subject;
  final List<int> components;
  final List<int> highlightedComponents;
  final int precision;
  final int tries;
  final int proficiency;

  @override
  State<LessonMenuButton> createState() => _LessonMenuButtonState();
}

class _LessonMenuButtonState extends State<LessonMenuButton> {
  // Icon? helpIcon;
  // bool expanded = false;
  // IconData? sideIcon;

  late bool isDarkMode;

  final int numberOfExercisesPerLesson = 5;
  // final int numberOfExercisesPerLesson = 15;

  // final Duration animationDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    isDarkMode = AdaptiveTheme.of(context).brightness == Brightness.dark;
    // if (widget.locked) {
    //   sideIcon = Icons.lock;
    //   expanded = false;
    // } else {
    //   sideIcon = Icons.arrow_right;
    // }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: _getGradientColors(),
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextButton(
          onPressed: _pressFunction,
          child: AutoSizeText(
            maxLines: 1,
            widget.lessonName,
            style: TextStyle(
              fontFamily: "Archivo Narrow",
              fontSize: 50.0,
              color: _getFontColor(),
            ),
          ),
        ),
      ),

      // GestureDetector(
      //   child: Container(
      //     height: widget.width * 0.3,
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(10.0),
      //       color: widget.locked ? MyColors.neutral3 : MyColors.secondary5,
      //     ),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         AnimatedContainer(
      //           duration: animationDuration,
      //           width: widget.width * 0.2,
      //           child: AnimatedSwitcher(
      //             duration: animationDuration,
      //             child: expanded
      //                 ? IconButton(
      //                     onPressed: () {
      //                       Navigator.push(
      //                         context,
      //                         MaterialPageRoute(
      //                           builder: (context) => LessonHelpPage(
      //                               lessonId: widget.lessonId),
      //                         ),
      //                       );
      //                     },
      //                     icon: Icon(Icons.help),
      //                   )
      //                 : null,
      //           ),
      //         ),
      //         Flexible(
      //           child: Text(
      //             widget.lessonName,
      //             style: TextStyle(
      //                 fontSize: 24.0, fontWeight: FontWeight.w600),
      //             textAlign: TextAlign.center,
      //           ),
      //         ),
      //         SizedBox(
      //           width: widget.width * 0.2,
      //           child: widget.locked
      //               ? Icon(sideIcon)
      //               : AnimatedSwitcher(
      //                   duration: animationDuration,
      //                   child: Transform.rotate(
      //                     key: expanded
      //                         ? ValueKey("Expanded")
      //                         : ValueKey("Collapsed"),
      //                     angle: expanded ? math.pi / 2 : 0.0,
      //                     child: Icon(sideIcon),
      //                   )),
      //         ),
      //       ],
      //     ),
      //   ),
      //   onTap: () {
      //     if (!widget.locked) {
      //       setState(() {
      //         expanded = !expanded;
      //       });
      //     } else {
      //       showDialog(
      //         context: context,
      //         builder: (context) => AlertDialog(
      //           title: Text(
      //             "LIÇÃO BLOQUEADA",
      //             textAlign: TextAlign.center,
      //           ),
      //           content: Padding(
      //             padding: EdgeInsets.symmetric(horizontal: 3.0),
      //             child: Text(
      //               "Esta lição será desbloqueada quando você atingir uma proficiência de 70% na lição anterior.",
      //               textAlign: TextAlign.justify,
      //             ),
      //           ),
      //           actions: [
      //             TextButton(
      //               onPressed: () {
      //                 Navigator.pop(context);
      //               },
      //               child:
      //                   Text("Ok", style: TextStyle(color: MyColors.main6)),
      //             )
      //           ],
      //         ),
      //       );
      //     }
      //   },
      // ),
    );
  }

  Color _getFontColor() {
    if (widget.darkMode) {
      return MyColors.light;
    }
    return MyColors.dark;
  }

  List<Color> _getGradientColors() {
    if (widget.locked) {
      return [MyColors.gray3, MyColors.gray4];
    }
    if (widget.darkMode) {
      return [MyColors.darkPrimary, MyColors.primary];
    }
    return [MyColors.primary, MyColors.brightPrimary];
  }

  void _pressFunction() {
    if (!widget.locked) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LessonInfoPage(
                lessonName: widget.lessonName,
                components: widget.components,
                lessonId: widget.lessonId,
                precision: widget.precision,
                proficiency: widget.proficiency,
                subject: widget.subject,
                tries: widget.tries,
                highlightedComponents: widget.highlightedComponents,
              )));
    } else {
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: Text(
      //       "LIÇÃO BLOQUEADA",
      //       textAlign: TextAlign.center,
      //     ),
      //     content: Padding(
      //       padding: EdgeInsets.symmetric(horizontal: 3.0),
      //       child: Text(
      //         "Esta lição será desbloqueada quando você atingir uma proficiência de 70% na lição anterior.",
      //         textAlign: TextAlign.justify,
      //       ),
      //     ),
      //     actions: [
      //       TextButton(
      //         onPressed: () {
      //           Navigator.pop(context);
      //         },
      //         child: Text("Ok", style: TextStyle(color: MyColors.dark)),
      //       )
      //     ],
      //   ),
      // );
      alert(
          context,
          "Lição bloqueada",
          "Esta lição será desbloqueada quando você atingir uma proficiência de 70% na lição anterior.",
          [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Ok",
                  style: TextStyle(
                    color: isDarkMode ? MyColors.gray5 : MyColors.primary,
                    fontSize: 22.0,
                  ),
                ))
          ],
          isDarkMode);
    }
  }

  Future<int> getNoteRepresentation() async {
    User? user = await UserHelper.getUser();

    if (user == null) {
      if (mounted) {
        await EResult.noUser.createAlert(context, isDarkMode);
      }
      return -1;
    }

    final int noteRepresentation = user.noteRepresentation;
    return noteRepresentation;
  }

}
