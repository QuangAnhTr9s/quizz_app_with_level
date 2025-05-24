import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizz_app/commons/extensions/index.dart';
import 'package:quizz_app/feature/quizz/models/quiz.dart';

import '../cubit/quiz_cubit.dart';
import 'quiz_choose_ans.dart';

class QuizWidget extends StatelessWidget {
  const QuizWidget({
    super.key,
    required this.quiz,
    this.percent,
  });

  final Quiz quiz;
  final double? percent;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// question
          if (quiz.question?.isNotEmpty == true)
            Container(
              margin: EdgeInsets.symmetric(vertical: 16.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (percent != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: LinearProgressIndicator(
                        color: const Color(0xff6B4EFF),
                        backgroundColor: Colors.grey.shade300,
                        value: percent!.clamp(0, 1),
                        borderRadius: BorderRadius.circular(8.r),
                        minHeight: 6.h,
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Text(
                      quiz.question!.toCapitalized(),
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: Colors.black,
                        fontFamily: GoogleFonts.beVietnamPro().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  /// option buttons
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // button
                      Expanded(
                        child: BlocBuilder<QuizCubit, QuizState>(
                          buildWhen: (previous, current) =>
                              previous.heart != current.heart,
                          builder: (context, state) {
                            return _OptionButton(
                              text: state.heart.toString(),
                              icon: Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 20.w,
                              ),
                              onTap: () {},
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      // change question button
                      Expanded(
                        child: BlocBuilder<QuizCubit, QuizState>(
                          buildWhen: (previous, current) =>
                              previous.changeQuizCount !=
                              current.changeQuizCount,
                          builder: (context, state) {
                            return _OptionButton(
                              text: state.changeQuizCount.toString(),
                              icon: Icon(
                                Icons.autorenew,
                                color: Colors.red,
                                size: 20.w,
                              ),
                              onTap: () {
                                context.read<QuizCubit>().changeQuestion();
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),

                      // eliminate answer button
                      Expanded(
                        child: BlocBuilder<QuizCubit, QuizState>(
                          buildWhen: (previous, current) =>
                              previous.eliminateAnswerCount !=
                              current.eliminateAnswerCount,
                          builder: (context, state) {
                            return _OptionButton(
                              text: state.eliminateAnswerCount.toString(),
                              icon: Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                                size: 20.w,
                              ),
                              onTap: () {
                                context.read<QuizCubit>().eliminateAnswer();
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          /// answers
          const QuizChooseAns(
            isTrueAnswer: true,
          ),
        ],
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final Widget icon;
  final String text;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        child: Row(
          children: [
            icon,
            SizedBox(
              width: 16.w,
            ),
            Text(
              text,
              style: TextStyle(color: Colors.red, fontSize: 16.sp),
            )
          ],
        ),
      ),
    );
  }
}
