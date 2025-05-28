import 'package:flutter/material.dart';

class TextRosario extends StatelessWidget {
  const TextRosario({
    super.key,
    required this.text,
    this.fontSize,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w400,
    this.textAlign,
    this.letterSpacing,
    this.lineHeight,
    this.overflow,
    this.maxLines,
    this.fontStyle,
    this.decoration,
  });

  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final double? letterSpacing;
  final double? lineHeight;
  final TextOverflow? overflow;
  final int? maxLines;
  final FontStyle? fontStyle;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontFamily: "Rosario-Regular",
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        color: color,
        letterSpacing: letterSpacing,
        height: lineHeight,
        decoration: decoration,
      ),
    );
  }
}
