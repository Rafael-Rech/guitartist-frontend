import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class MyHorizontalButton extends StatelessWidget {
  const MyHorizontalButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.height,
    required this.width,
    required this.useGradient,
    required this.mainColor,
    this.secondaryColor,
    this.borderWidth,
    this.borderColor,
    this.textColor,
    this.fontSize,
    this.fontFamily,
  });

  final String text; //ok
  final double height; //ok
  final double width; //ok
  final bool useGradient; //ok
  final double? borderWidth; //ok
  final Color? borderColor; //ok
  final Color mainColor; //ok
  final Color? secondaryColor; //ok
  final Color? textColor; //ok
  final double? fontSize; //ok
  final String? fontFamily; //ok
  final void Function()? onPressed; //ok

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: generateGradient(),
        color: useGradient? null : mainColor,
        borderRadius: BorderRadius.circular(25),
        border: generateBorder(),
      ),
      child: TextButton(
        style: ButtonStyle(),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? (AdaptiveTheme.of(context).theme.textTheme.displayMedium?.color ?? const Color.fromARGB(255, 249, 249, 249)),
            fontSize: fontSize ?? AdaptiveTheme.of(context).theme.textTheme.displayMedium?.fontSize,
            fontFamily: fontFamily ?? AdaptiveTheme.of(context).theme.textTheme.displayMedium?.fontFamily,
          ),
        ),
      ),
    );
  }

  BoxBorder? generateBorder(){
    if(borderWidth == null || borderWidth == 0){
      return null;
    }

    return Border.all(
      color: borderColor ?? const Color.fromARGB(255, 5, 5, 5),
      width: borderWidth!,
    );
  }

  LinearGradient? generateGradient() {
    if (useGradient == false || secondaryColor == null) {
      return null;
    }

    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        mainColor,
        secondaryColor!,
      ],
    );
  }
}
