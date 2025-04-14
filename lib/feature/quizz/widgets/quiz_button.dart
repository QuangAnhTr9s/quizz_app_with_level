import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commons/app_colors.dart';
import '../../../commons/widgets/custom_text_button.dart';

class QuizletBtnTrueFalse extends StatefulWidget {
  const QuizletBtnTrueFalse({
    super.key,
    this.onTrueSelected,
    this.answerText,
    this.isChecked,
    this.isTrueAnswer,
  });

  final Function(bool selectedTrue)? onTrueSelected;
  final String? answerText;
  final bool? isChecked;
  final bool? isTrueAnswer;

  @override
  State<QuizletBtnTrueFalse> createState() => _QuizletBtnTrueFalseState();
}

class _QuizletBtnTrueFalseState extends State<QuizletBtnTrueFalse> {
  bool? isSelectedTrue;

  @override
  void didUpdateWidget(covariant QuizletBtnTrueFalse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isChecked != widget.isChecked && widget.isChecked == null) {
      isSelectedTrue = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color defaultBorderColor = Colors.grey[20] ?? AppColors.white;
    Color activeBorderColor = AppColors.primaryColor[700] ?? AppColors.white;
    Color borderColorTrueButton = AppColors.grayColor[20] ?? AppColors.white;
    Color borderColorFalseButton = AppColors.grayColor[20] ?? AppColors.white;
    Color bgColorTrueButton = AppColors.white;
    Color bgColorFalseButton = AppColors.white;
    if (widget.isChecked == true) {
      if (isSelectedTrue == true) {
        borderColorTrueButton = widget.isTrueAnswer == true
            ? AppColors.stateSuccessColor
            : AppColors.stateErrorColor;
        if (widget.isTrueAnswer == false) {
          borderColorFalseButton = AppColors.stateSuccessColor;
        }
      } else {
        if (widget.isTrueAnswer == true) {
          borderColorTrueButton = AppColors.stateSuccessColor;
        }
        borderColorFalseButton = widget.isTrueAnswer == true
            ? AppColors.stateErrorColor
            : AppColors.stateSuccessColor;
      }
    } else if (isSelectedTrue != null) {
      bool isTrue = isSelectedTrue == true;
      borderColorTrueButton = isTrue ? activeBorderColor : defaultBorderColor;
      borderColorFalseButton = isTrue ? defaultBorderColor : activeBorderColor;

      Color activeBgColor = AppColors.primaryColor[100] ?? AppColors.white;
      bgColorTrueButton = isTrue ? activeBgColor : AppColors.white;
      bgColorFalseButton = isTrue ? AppColors.white : activeBgColor;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose the correct answer',
          style: TextStyle(color: AppColors.black, fontSize: 16.sp),
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(vertical: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomTextButton(
                  text: 'True',
                  bgColor: bgColorTrueButton,
                  onAnimation: widget.isChecked != true,
                  buttonFn: () {
                    if (widget.isChecked != true) {
                      widget.onTrueSelected?.call(true);
                      setState(() {
                        isSelectedTrue = true;
                      });
                    }
                  },
                  border: Border(
                    top: BorderSide(
                        color: borderColorTrueButton, width: 2.w), // Viền trên
                    left: BorderSide(
                        color: borderColorTrueButton, width: 2.w), // Viền trái
                    right: BorderSide(
                        color: borderColorTrueButton, width: 2.w), // Viền phải
                    bottom: BorderSide.none, // Không viền dưới
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 6.w),
                      color: borderColorTrueButton,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 16.w,
              ),
              Expanded(
                child: CustomTextButton(
                  text: 'False',
                  onAnimation: widget.isChecked != true,
                  bgColor: bgColorFalseButton,
                  buttonFn: () {
                    if (widget.isChecked != true) {
                      widget.onTrueSelected?.call(false);
                      setState(() {
                        isSelectedTrue = false;
                      });
                    }
                  },
                  border: Border(
                    top: BorderSide(
                        color: borderColorFalseButton, width: 2.w), // Viền trên
                    left: BorderSide(
                        color: borderColorFalseButton, width: 2.w), // Viền trái
                    right: BorderSide(
                        color: borderColorFalseButton, width: 2.w), // Viền phải
                    bottom: BorderSide.none, // Không viền dưới
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 6.w),
                      color: borderColorFalseButton,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        // //dap an
        // if (widget.isChecked == true)
        //   AnswerTextWidget(
        //     answerText: widget.answerText ?? '',
        //   )
      ],
    );
  }
}
