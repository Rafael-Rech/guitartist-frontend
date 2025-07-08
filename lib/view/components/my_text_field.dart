import 'package:flutter/material.dart';
import 'package:tcc/global/my_colors.dart';

class MyTextField extends StatefulWidget {
  const MyTextField(
      {super.key,
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
      this.suffixText,
      this.textColor,
      this.suffixStyle,
      this.textAlign,
      this.contentPadding});

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
  final String? suffixText;
  final Color? textColor;
  final TextStyle? suffixStyle;
  final TextAlign? textAlign;
  final EdgeInsets? contentPadding;

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
          color: (widget.isDarkMode != null && widget.isDarkMode!)? MyColors.light : MyColors.dark,
        ),
        onPressed: () {
          setState(() {
            hideText = !hideText;
          });
        },
      );
    }

    textField = TextField(
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      style: TextStyle(
        fontSize: widget.fontSize,
        fontFamily: widget.fontFamily,
        color: widget.textColor,
      ),
      decoration: InputDecoration(
          filled: widget.useFillColor != null && widget.useFillColor!,
          labelText: widget.labelText,
          border: widget.border,
          disabledBorder: widget.border,
          enabledBorder: widget.border,
          suffixIcon: suffixIcon,
          focusedBorder: widget.border,
          suffixStyle: widget.suffixStyle,
          focusColor: Colors.blue,
          errorText: widget.errorText,
          errorStyle: widget.errorStyle,
          contentPadding: widget.contentPadding,
          errorMaxLines: widget.errorMaxLines,
          fillColor: widget.useFillColor != null && widget.useFillColor == true
              ? (widget.fillColor ??
                  (widget.isDarkMode != null ? MyColors.gray4 : MyColors.light))
              : null,
          suffixText: widget.suffixText),
      obscureText: hideText,
      focusNode: widget.focusNode,
      onSubmitted: widget.onSubmitted,
      textAlign: widget.textAlign ?? TextAlign.start,
    );

    return Container(
        padding: widget.sidePadding != null
            ? EdgeInsets.symmetric(horizontal: widget.sidePadding!)
            : null,
        child: textField);
  }
}
