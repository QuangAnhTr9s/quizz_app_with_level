import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_animation_widget.dart';

class CustomAnimationButton extends StatelessWidget {
  const CustomAnimationButton({
    super.key,
    this.buttonFn,
    this.bgColor,
    this.height,
    this.width,
    this.text,
    this.colorText,
    this.textStyle,
    this.borderRadius,
    this.padding,
    this.margin,
    this.heightText,
    this.border,
    this.boxShadow,
    this.onAnimation = true,
    this.intrinsicWidth = true,
    this.textScaler,
    this.child,
  });

  final Function()? buttonFn;
  final Color? bgColor;
  final double? height;
  final double? width;
  final String? text;
  final Color? colorText;
  final TextStyle? textStyle;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? heightText;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final bool onAnimation;
  final bool intrinsicWidth;
  final TextScaler? textScaler;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    double radius = borderRadius ?? 24.r;
    return InkWell(
      onTap: buttonFn,
      borderRadius: BorderRadius.circular(radius),
      child: CustomAnimationWidget(
        onAnimation: onAnimation,
        child: intrinsicWidth
            ? IntrinsicWidth(
                child: _contentButton(radius),
              )
            : _contentButton(radius),
      ),
    );
  }

  Container _contentButton(double radius) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 12.h,
          ),
      decoration: BoxDecoration(
          color: bgColor ?? Colors.blue,
          borderRadius: BorderRadius.circular(radius),
          border: border,
          boxShadow: boxShadow),
      child: Center(
        child: child ??
            Text(
              '$text',
              textAlign: TextAlign.center,
              textScaler: textScaler,
              style: textStyle ??
                  TextStyle(
                      color: colorText, height: heightText, fontSize: 16.sp),
            ),
      ),
    );
  }
}
