import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcc/global/my_colors.dart';

class MyTextFormField extends StatefulWidget {
  const MyTextFormField({
    super.key,
    this.labelText,
    this.obscureText,
    this.border,
    this.controller,
    this.focusNode,
    this.validator,
    this.sidePadding,
    this.formatters,
    this.fontFamily,
    this.keyboardType,
    this.fillColor,
    this.fill,
    this.labelColor,
  });

  final String? labelText;
  final bool? obscureText;
  final InputBorder? border;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final double? sidePadding;
  final List<TextInputFormatter>? formatters;
  final String? fontFamily;
  final TextInputType? keyboardType;
  final Color? fillColor;
  final bool? fill;
  final Color? labelColor;

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
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

    textField = TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        filled: widget.fill,
        labelText: widget.labelText,
        labelStyle: TextStyle(color: widget.labelColor?? MyColors.gray1),
        enabledBorder: widget.border,
        // focusColor: MyColors.secondary5,
        suffixIcon: suffixIcon,
        fillColor: widget.fillColor,
        focusedBorder: widget.border,
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
                color: AdaptiveTheme.of(context).theme.colorScheme.error, width: 2.0)),
      ),
      style: TextStyle(fontFamily: widget.fontFamily),
      obscureText: hideText,
      focusNode: widget.focusNode,
      validator: widget.validator,
      inputFormatters: widget.formatters,
      onChanged: (value) {},
    );

    return Container(
        padding: widget.sidePadding != null
            ? EdgeInsets.symmetric(horizontal: widget.sidePadding!)
            : null,
        child: textField);
  }
}
