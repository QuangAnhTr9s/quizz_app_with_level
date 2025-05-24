import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quizz_app/commons/widgets/button_with_border.dart';
import 'package:quizz_app/commons/widgets/cancel_button.dart';

class DialogService {
  static showQuizDialog({
    required BuildContext context,
    required String message,
  }) {}

  static showOutOfTurnsEliminateAnswer({
    required BuildContext context,
    required Function() onTap,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xffCFBAE6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          insetPadding: REdgeInsets.symmetric(horizontal: 20.w),
          child: HeartContentDialog(
            title: 'Eliminate Wrong Answers',
            content: 'You are out of elimination turns!\nBuy 2 more turns?',
            price: 100,
            onTap: onTap,
          ),
        );
      },
    );
  }

  static showOutOfTurnsToChangeQuestion({
    required BuildContext context,
    required Function() onTap,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xffCFBAE6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          insetPadding: REdgeInsets.symmetric(horizontal: 20.w),
          child: HeartContentDialog(
            title: 'Change Question',
            content: 'You are out of question change turns!\nBuy 2 more turns?',
            price: 100,
            onTap: onTap,
          ),
        );
      },
    );
  }

  static showLastTurnDialog({
    required BuildContext context,
    required Function() onTap,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xffCFBAE6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          insetPadding: REdgeInsets.symmetric(horizontal: 20.w),
          child: HeartContentDialog(
            title: 'You Have 1 Life Left',
            content: 'Would you like to buy 2 more lives?',
            price: 100,
            onTap: onTap,
          ),
        );
      },
    );
  }

  static showCompleteQuiz({
    required BuildContext context,
    required Function() replayFunc,
    required Function() goHomeFunc,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xffCFBAE6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          insetPadding: REdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Congratulations',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.black,
                          height: 1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      // CancelButton(
                      //   iconSize: 30.sp,
                      //   colorBorder: Colors.black,
                      //   colorIcon: Colors.black,
                      // ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.sp),
                    child: Text(
                      'You have correctly answered all 20 questions',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  ButtonWithBorder(
                    bgColor: Colors.white,
                    onTap: () {
                      Navigator.pop(context);
                      replayFunc();
                    },
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Text(
                        'Play Again',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ButtonWithBorder(
                    bgColor: Colors.white,
                    onTap: () {
                      Navigator.pop(context);
                      goHomeFunc();
                    },
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Text(
                        'Home Screen',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static showOutOfTurnsDialog({
    required BuildContext context,
    required Function() purchaseFunc,
    required Function() replayFunc,
    required Function() goHomeFunc,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xffCFBAE6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          insetPadding: REdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'You are out of lives',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.black,
                          height: 1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.sp),
                    child: Text(
                      'Would you like to buy 2 more lives?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  ButtonWithBorder(
                    bgColor: Colors.white,
                    onTap: () {
                      Navigator.pop(context);
                      purchaseFunc();
                    },
                    child: SizedBox(
                      width: double.maxFinite,
                      child: RichText(
                        textScaler: MediaQuery.of(context).textScaler,
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            const TextSpan(text: 'Buy '),
                            WidgetSpan(
                              child: SizedBox(
                                height: 20.sp,
                                width: 20.sp,
                                child: Image.asset(
                                  'assets/dollar.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            const TextSpan(text: ' 100 coins'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ButtonWithBorder(
                    bgColor: Colors.white,
                    onTap: () {
                      Navigator.pop(context);
                      replayFunc();
                    },
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Text(
                        'Play Again',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ButtonWithBorder(
                    bgColor: Colors.white,
                    onTap: () {
                      Navigator.pop(context);
                      goHomeFunc();
                    },
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Text(
                        'Home Screen',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class HeartContentDialog extends StatefulWidget {
  const HeartContentDialog({
    super.key,
    required this.title,
    required this.content,
    required this.price,
    required this.onTap,
  });

  final String title;
  final String content;
  final int price;
  final Function() onTap;

  @override
  State<HeartContentDialog> createState() => _HeartContentDialogState();
}

class _HeartContentDialogState extends State<HeartContentDialog> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black,
                    height: 1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                CancelButton(
                  iconSize: 30.sp,
                  colorBorder: Colors.black,
                  colorIcon: Colors.black,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.sp),
              child: Text(
                widget.content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            ButtonWithBorder(
              onTap: () {
                Navigator.pop(context);
                widget.onTap();
              },
              bgColor: Colors.white,
              child: SizedBox(
                width: double.maxFinite,
                child: RichText(
                  textAlign: TextAlign.center,
                  textScaler: MediaQuery.of(context).textScaler,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      const TextSpan(text: 'Buy '),
                      WidgetSpan(
                        child: SizedBox(
                          height: 20.sp,
                          width: 20.sp,
                          child: Image.asset(
                            'assets/dollar.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      TextSpan(text: ' ${widget.price} coins'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
