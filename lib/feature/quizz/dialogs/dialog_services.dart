import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quizz_app/commons/widgets/button_with_border.dart';
import 'package:quizz_app/commons/widgets/cancel_button.dart';

import '../../../commons/constant.dart';

class DialogService {
  static showQuizDialog({
    required BuildContext context,
    required String message,
  }) {
    if (message == BlocMessage.outOfTurns) {
      showOutOfTurnsDialog(context: context);
    }
  }

  static showOutOfTurnsDialog({
    required BuildContext context,
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
          child: ContentWidget(),
        );
      },
    );
  }
}

class ContentWidget extends StatefulWidget {
  const ContentWidget({super.key});

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Loại trừ câu sai',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.black,
                      height: 1,
                      fontWeight: FontWeight.w700,
                    )),
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
                'Bạn đã hết lượt loại trừ !\nMua thêm 2 lượt ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            ButtonWithBorder(child: RichText(text: TextSpan(children: []))),
          ],
        ),
      ),
    );
  }
}
