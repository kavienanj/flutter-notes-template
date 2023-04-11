import 'package:flutter/material.dart';

class NoteTextField extends StatelessWidget {
  const NoteTextField({
    super.key, 
    this.text,
    required this.fontSize,
    this.hintText = '',
    this.fontWeight,
    this.multiline = false,
    required this.onChanged,
  });

  final String? text;
  final double fontSize;
  final FontWeight? fontWeight;
  final String hintText;
  final void Function(String?) onChanged;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: text,
      style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
      maxLines: multiline ? null : 1,
      keyboardType: multiline ? TextInputType.multiline : null,
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
      ),
      onChanged: onChanged,
    );
  }
}
