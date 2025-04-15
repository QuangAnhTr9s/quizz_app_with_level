import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_text_button.dart';

class TextButtonWithBotBorder extends StatefulWidget {
  const TextButtonWithBotBorder(
      {super.key,
      required this.text,
      this.onAnimation = true,
      this.bgColor,
      this.borderColor,
      this.onTap});

  final String text;
  final bool onAnimation;
  final Color? bgColor;
  final Color? borderColor;
  final Function()? onTap;

  @override
  State<TextButtonWithBotBorder> createState() =>
      _TextButtonWithBotBorderState();
}

class _TextButtonWithBotBorderState extends State<TextButtonWithBotBorder> {
  @override
  Widget build(BuildContext context) {
    return CustomAnimationButton(
      text: widget.text,
      onAnimation: widget.onAnimation,
      bgColor: widget.bgColor,
      buttonFn: widget.onTap,
      border: Border(
        top: BorderSide(
            color: widget.borderColor ?? Colors.white, width: 2.w), // Viền trên
        left: BorderSide(
            color: widget.borderColor ?? Colors.white, width: 2.w), // Viền trái
        right: BorderSide(
            color: widget.borderColor ?? Colors.white, width: 2.w), // Viền phải
        bottom: BorderSide.none, // Không viền dưới
      ),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 6.w),
          color: widget.borderColor ?? Colors.white,
        )
      ],
    );
  }
}
