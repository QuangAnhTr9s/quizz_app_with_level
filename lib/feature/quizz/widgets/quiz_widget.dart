import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quizz_app/commons/extensions/index.dart';
import 'package:quizz_app/commons/widgets/button_with_border.dart';
import 'package:quizz_app/feature/quizz/models/quiz.dart';

import '../cubit/quiz_cubit.dart';
import 'quiz_choose_ans.dart';

class QuizWidget extends StatelessWidget {
  const QuizWidget({super.key, required this.quiz});

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// question
          if (quiz.question?.isNotEmpty == true)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text(
                quiz.question!.toCapitalized(),
                style: TextStyle(fontSize: 24.sp, color: Colors.white),
              ),
            ),

          /// option buttons
          Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Row(
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
                        previous.changeQuizCount != current.changeQuizCount,
                    builder: (context, state) {
                      return _OptionButton(
                        text: state.changeQuizCount.toString(),
                        icon: Icon(
                          Icons.autorenew,
                          color: Colors.purple,
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
                          color: Colors.blue,
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
    return ButtonWithBorder(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      onTap: onTap,
      bgColor: Colors.white,
      child: Row(
        children: [
          icon,
          SizedBox(
            width: 16.w,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: 16.sp),
          )
        ],
      ),
    );
  }
}
