import 'package:flutter/material.dart';
import 'package:tcc/global/my_colors.dart';

class MyTextButton extends StatefulWidget {
  const MyTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.fontSize,
    this.width,
    this.height,
    this.borderWidth,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.icon,
    this.fontFamily,
  });

  final void Function()? onPressed;
  final String text;
  final double? fontSize;
  final double? width;
  final double? height;
  final double? borderWidth;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Icon? icon;
  final String? fontFamily;

  @override
  State<MyTextButton> createState() => _MyTextButtonState();
}

class _MyTextButtonState extends State<MyTextButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TextButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(
              widget.backgroundColor == null
                  ? Colors.white
                  : widget.backgroundColor!),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              side: BorderSide(
                // color: ((widget.borderColor == null)
                //     ? MyColors.main5
                //     : widget.borderColor!),
                width: widget.borderWidth == null ? 1 : widget.borderWidth!,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        child: ((widget.icon != null)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:
                          (widget.fontSize == null) ? 20 : widget.fontSize,
                      color: widget.textColor ?? Colors.grey,
                      fontFamily: widget.fontFamily,
                    ),
                  ),
                  widget.icon!,
                ],
              )
            : Text(
                widget.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: (widget.fontSize == null) ? 20 : widget.fontSize,
                  color: widget.textColor ?? Colors.grey,
                ),
              )),
      ),
    );
  }
}
