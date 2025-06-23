import 'package:flutter/material.dart';
import 'package:tcc/global/my_colors.dart';

Future<void> alert(BuildContext context, String title, String content,
    List<Widget> actions, bool isDarkTheme,
    {MainAxisAlignment? actionsAlignment,
    bool dismissible = true,
    TextAlign textAlign = TextAlign.start}) async {
  await showDialog(
    context: context,
    barrierDismissible: dismissible,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
        maxLines: 2,
        style: TextStyle(
          fontFamily: "Roboto",
          fontSize: 26.0,
          color: isDarkTheme ? MyColors.light : MyColors.dark,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        content,
        textAlign: textAlign,
        style: TextStyle(
          fontFamily: "Roboto",
          fontSize: 24.0,
          color: isDarkTheme ? MyColors.light : MyColors.dark,
        ),
      ),
      actions: actions,
      actionsAlignment: actionsAlignment,
      backgroundColor: isDarkTheme ? MyColors.gray1 : MyColors.light,
    ),
  );
}
