import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quizz_app/feature/quizz/cubit/quiz_cubit.dart';
import 'package:quizz_app/feature/quizz/models/quiz.dart';

import '../../../commons/app_colors.dart';
import '../../../commons/widgets/text_button_with_bot_border.dart';

class QuizChooseAns extends StatefulWidget {
  const QuizChooseAns({
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
  State<QuizChooseAns> createState() => _QuizChooseAnsState();
}

class _QuizChooseAnsState extends State<QuizChooseAns> {
  List<int>? indexSelectedList;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizCubit, QuizState>(
      buildWhen: (previous, current) => previous.questions != current.questions,
      builder: (context, state) {
        if (state is QuizLoaded && state.questions?.isNotEmpty == true) {
          List<Answer> answers =
              state.questions![state.indexQuestion].answers ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Text(
                  'Choose the correct answer',
                  style: TextStyle(color: AppColors.black, fontSize: 16.sp),
                ),
              ),
              ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => SizedBox(
                  height: 16.h,
                ),
                itemCount: answers.length,
                itemBuilder: (context, index) => AnswerButton(
                  key: ValueKey("${answers[index].answer}" "$index"),
                  isSelected: indexSelectedList?.isNotEmpty == true &&
                      indexSelectedList!.contains(index),
                  answer: answers[index],
                  onTap: (isCorrect) {
                    if (isCorrect) {
                      indexSelectedList = null;
                      context.read<QuizCubit>().nextQuestion();
                    } else {
                      context.read<QuizCubit>().useHeart();
                      setState(() {
                        if (indexSelectedList == null) {
                          indexSelectedList = [index];
                        } else if (indexSelectedList!.contains(index) != true) {
                          indexSelectedList!.add(index);
                        }
                      });
                    }
                  },
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    super.key,
    required this.isSelected,
    required this.answer,
    required this.onTap,
  });

  final bool isSelected;
  final Answer answer;
  final Function(bool isCorrect) onTap;

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.grayColor[20] ?? AppColors.white;
    // Color activeBorderColor = AppColors.primaryColor[700] ?? AppColors.white;
    Color bgColor = AppColors.white;
    if (answer.canShow == false) {
      borderColor = AppColors.grayColor[40] ?? Colors.grey;
      bgColor = AppColors.grayColor[40] ?? Colors.grey;
    } else if (isSelected == true) {
      if (answer.isCorrect == true) {
        borderColor = AppColors.stateSuccessColor;
      } else {
        borderColor = AppColors.stateErrorColor;
      }
    }
    return TextButtonWithBotBorder(
      text: answer.answer ?? '',
      bgColor: bgColor,
      borderColor: borderColor,
      onTap: () {
        onTap(answer.isCorrect ?? false);
      },
      onAnimation: answer.canShow,
    );
  }
}
