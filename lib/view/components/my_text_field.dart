import 'package:flutter/material.dart';

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
      this.onSubmitted});

  final double? sidePadding;
  final String? labelText;
  final bool? obscureText;
  final InputBorder? border;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? errorText;
  final TextStyle? errorStyle;
  final double? fontSize;
  final void Function(String)? onSubmitted;

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
      style: TextStyle(fontSize: widget.fontSize),
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: widget.border,
        // enabledBorder: ,
        // constraints: BoxConstraints.expand(),
        focusColor: Colors.blue,
        errorText: widget.errorText,
        errorStyle: widget.errorStyle,
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
