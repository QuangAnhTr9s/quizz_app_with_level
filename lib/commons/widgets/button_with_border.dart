import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quizz_app/commons/app_colors.dart';

import 'custom_text_button.dart';

class ButtonWithBorder extends StatefulWidget {
  const ButtonWithBorder({
    super.key,
    this.onAnimation = true,
    this.bgColor,
    this.borderColor,
    this.onTap,
    required this.child,
    this.padding,
  });

  final bool onAnimation;
  final Color? bgColor;
  final Color? borderColor;
  final Function()? onTap;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  State<ButtonWithBorder> createState() => _ButtonWithBorderState();
}

class _ButtonWithBorderState extends State<ButtonWithBorder> {
  Color borderColor = AppColors.grayColor[20] ?? AppColors.white;
  @override
  Widget build(BuildContext context) {
    return CustomAnimationButton(
      padding: widget.padding,
      onAnimation: widget.onAnimation,
      bgColor: widget.bgColor,
      buttonFn: widget.onTap,
      border: Border(
        top: BorderSide(color: borderColor, width: 2.w), // Viền trên
        left: BorderSide(color: borderColor, width: 2.w), // Viền trái
        right: BorderSide(color: borderColor, width: 2.w), // Viền phải
        bottom: BorderSide.none, // Không viền dưới
      ),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 6.w),
          color: borderColor,
        )
      ],
      child: widget.child,
    );
  }
}
