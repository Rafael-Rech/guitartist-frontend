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
        labelText: widget.labelText,
        labelStyle: TextStyle(color: MyColors.secondary8),
        enabledBorder: widget.border,
        // enabledBorder: ,
        // constraints: BoxConstraints.expand(),
        focusColor: MyColors.secondary5,
        suffixIcon: suffixIcon,
        fillColor: widget.fillColor,
        focusedBorder: widget.border,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: MyColors.main6, width: 2.0)),
      ),
      style: TextStyle(fontFamily: widget.fontFamily),
      obscureText: hideText,
      focusNode: widget.focusNode,
      validator: widget.validator,
      inputFormatters: widget.formatters,
      onChanged: (value) {
        
      },
    );

    return Container(
        padding: widget.sidePadding != null
            ? EdgeInsets.symmetric(horizontal: widget.sidePadding!)
            : null,
        child: textField);
  }
}
