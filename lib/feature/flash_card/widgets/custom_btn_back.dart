import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBtnBack extends StatelessWidget {
  const CustomBtnBack(
      {super.key,
      this.colorBorder,
      this.colorIcon,
      this.onTap,
      this.backgroundColor,
      this.boxShadow,
      this.iconSize,
      this.icon});

  final Color? colorBorder;
  final Color? colorIcon;
  final Color? backgroundColor;
  final void Function()? onTap;
  final List<BoxShadow>? boxShadow;
  final double? iconSize;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.pop(context);
          },
      child: Container(
          width: iconSize ?? 40.h,
          height: iconSize ?? 40.h,
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(100.r),
              border: Border.all(color: colorBorder ?? Colors.grey, width: 1.5),
              boxShadow: boxShadow),
          child: Center(
            child: icon ??
                Icon(
                  Icons.navigate_before,
                  color: colorIcon ?? Colors.grey,
                ),
          )),
    );
  }
}
