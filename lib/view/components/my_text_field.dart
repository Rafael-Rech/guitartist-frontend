import 'package:flutter/material.dart';
import 'package:tcc/global/my_colors.dart';

class MyTextField extends StatefulWidget {
  const MyTextField({
    super.key,
    this.sidePadding,
    this.fontSize,
    this.labelText,
    this.obscureText,
    this.border,
    this.controller,
    this.focusNode,
    this.errorText,
    this.errorStyle,
    this.onSubmitted,
    this.fillColor,
    this.fontFamily,
    this.keyboardType,
    this.isDarkMode,
    this.useFillColor,
    this.errorMaxLines,
  });

  final double? sidePadding;
  final String? labelText;
  final bool? obscureText;
  final InputBorder? border;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? errorText;
  final TextStyle? errorStyle;
  final double? fontSize;
  final String? fontFamily;
  final TextInputType? keyboardType;
  final void Function(String)? onSubmitted;
  final Color? fillColor;
  final bool? isDarkMode;
  final bool? useFillColor;
  final int? errorMaxLines;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late Widget textField;
  bool hideText = false;
  IconButton? suffixIcon;

  @override
  void initState() {
    super.initState();
    if (widget.obscureText != null && widget.obscureText!) {
      hideText = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.obscureText != null && widget.obscureText!) {
      suffixIcon = IconButton(
        icon: Icon(
          hideText ? Icons.visibility_off : Icons.visibility,
        ),
        onPressed: () {
          setState(() {
            hideText = !hideText;
          });
        },
      );
    }

    textField = TextField(
      controller: widget.controller,
      style:
          TextStyle(fontSize: widget.fontSize, fontFamily: widget.fontFamily),
      decoration: InputDecoration(
        filled: widget.useFillColor != null && widget.useFillColor!,
        labelText: widget.labelText,
        border: widget.border,
        disabledBorder: widget.border,
        enabledBorder: widget.border,
        suffixIcon: suffixIcon,
        focusedBorder: widget.border,
        focusColor: Colors.blue,
        errorText: widget.errorText,
        errorStyle: widget.errorStyle,
        errorMaxLines: widget.errorMaxLines,
        fillColor: widget.useFillColor != null && widget.useFillColor == true
            ? (widget.fillColor ??
                (widget.isDarkMode != null ? MyColors.gray4 : MyColors.light))
            : null,
      ),
      obscureText: hideText,
      focusNode: widget.focusNode,
      onSubmitted: widget.onSubmitted,
    );

    return Container(
        padding: widget.sidePadding != null
            ? EdgeInsets.symmetric(horizontal: widget.sidePadding!)
            : null,
        child: textField);
  }
}
