import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:quizz_app/commons/widgets/custom_btn_back.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({
    super.key,
    this.colorBorder,
    this.colorIcon,
    this.iconSize,
  });

  final Color? colorBorder;
  final Color? colorIcon;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return CustomBtnBack(
      colorBorder: colorBorder ?? Colors.white,
      iconSize: iconSize ?? 30.w,
      icon: Icon(Icons.close,
          color: colorIcon ?? Colors.white,
          size: iconSize != null ? iconSize! / 2 : null),
    );
  }
}
