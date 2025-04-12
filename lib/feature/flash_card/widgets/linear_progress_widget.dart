import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LinearProgressWidget extends StatelessWidget {
  const LinearProgressWidget({
    super.key,
    this.percent,
    this.score,
    this.length,
    required this.lineHeight,
    this.backgroundColor,
    this.progressColor,
  });

  final double? percent;
  final double? score;
  final int? length;
  final double lineHeight;
  final Color? backgroundColor;
  final Color? progressColor;

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      lineHeight: lineHeight,
      percent: percent?.clamp(0, 1) ?? ((score ?? 0) / (length ?? 100)),
      backgroundColor: backgroundColor ?? Colors.orange.shade100,
      progressColor: progressColor ?? Colors.orange.shade400,
      barRadius: Radius.circular(50.r),
      padding: EdgeInsets.zero,
    );
  }
}
