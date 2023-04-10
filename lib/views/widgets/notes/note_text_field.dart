import 'package:flutter/material.dart';

class NoteTextField extends StatelessWidget {
  const NoteTextField({
    super.key, 
    required this.controller,
    required this.fontSize,
    this.hintText = '',
    this.fontWeight,
    this.multiline = false,
    required this.onEditingComplete,
  });

  final TextEditingController controller;
  final double fontSize;
  final FontWeight? fontWeight;
  final String hintText;
  final VoidCallback onEditingComplete;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
      maxLines: multiline ? null : 1,
      keyboardType: multiline ? TextInputType.multiline : null,
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
      ),
      onEditingComplete: onEditingComplete,
    );
  }
}
