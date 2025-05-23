import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    super.key,
    this.hintText,
    this.controller,
    this.validate,
    this.onSave,
    this.maxLine,
    this.isPassword,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.prefix,
    this.suffix,
    this.enable = true,
    this.check,
  });

  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validate;
  final String? Function(String?)? onSave;
  final int? maxLine;
  final bool? isPassword;
  final bool? enable;
  final bool? check;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Widget? prefix;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      //*inputs
      enabled: enable == true ? true : false,
      maxLines: maxLine ?? 1,
      onSaved: onSave,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: keyboardType ?? TextInputType.name,
      controller: controller,
      validator: validate,
      obscureText: isPassword == false ? false : true,

      //*decoration
      decoration: InputDecoration(
        prefix: prefix,
        suffix: suffix,
        labelText: hintText,
        //# border
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            style: BorderStyle.solid,
          ),
        ),
        //
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            style: BorderStyle.solid,
            color: Colors.pink,
          ),
        ),
      ),
    );
  }
}
