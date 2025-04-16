import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizz_app/commons/constant.dart';
import 'package:quizz_app/commons/widgets/cancel_button.dart';
import 'package:quizz_app/feature/quizz/widgets/quiz_widget.dart';

import '../../../models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubits/user/user_cubit.dart';
import '../purchase/coin_package_screen.dart';
import 'cubit/quiz_cubit.dart';
import 'dialogs/dialog_services.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.category});

  final Category category;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _quizCubit = QuizCubit();

  @override
  void initState() {
    super.initState();
    _quizCubit.loadQuiz();
  }

  @override
  void dispose() {
    _quizCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _quizCubit,
      child: BlocListener<QuizCubit, QuizState>(
        listenWhen: (previous, current) =>
            previous is QuizLoaded &&
            current is QuizLoaded &&
            previous.message != current.message,
        listener: (context, state) {
          /// listen message
          if (state is QuizLoaded && state.message?.isNotEmpty == true) {
            String message = state.message!;
            if (message == BlocMessage.outOfTurns) {
              DialogService.showOutOfTurnsDialog(
                context: context,
                purchaseFunc: () => _quizCubit.purchaseHeart(context: context),
                replayFunc: () {
                  _quizCubit.loadQuiz();
                },
                goHomeFunc: () {
                  Navigator.of(context).popUntil(
                    (route) => route.isFirst,
                    // (route) => route.settings.name == '/home',
                  );
                },
              );
            } else if (message == BlocMessage.outOfTurnsToChangeQuestion) {
              DialogService.showOutOfTurnsToChangeQuestion(
                context: context,
                onTap: () {
                  _quizCubit.purchaseChangeQuizCount(context: context);
                },
              );
            } else if (message == BlocMessage.outOfTurnsEliminateAnswer) {
              DialogService.showOutOfTurnsEliminateAnswer(
                context: context,
                onTap: () {
                  _quizCubit.purchaseEliminateAnswerCount(context: context);
                },
              );
            } else if (message == BlocMessage.lastTurn) {
              DialogService.showLastTurnDialog(
                context: context,
                onTap: () {
                  _quizCubit.purchaseHeart(context: context);
                },
              );
            } else if (message == BlocMessage.completeQuiz) {
              DialogService.showCompleteQuiz(
                context: context,
                replayFunc: () {
                  _quizCubit.loadQuiz();
                },
                goHomeFunc: () {
                  Navigator.of(context).popUntil(
                    (route) => route.isFirst,
                    // (route) => route.settings.name == '/home',
                  );
                },
              );
            }
          }
          _quizCubit.resetMessage();
        },
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ).copyWith(top: 16.h),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/bg_image.png"),
                    fit: BoxFit.fill)),
            child: SafeArea(
              child: BlocBuilder<QuizCubit, QuizState>(
                bloc: _quizCubit,
                builder: (context, state) {
                  if (state is QuizInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is QuizError ||
                      (state is QuizLoaded &&
                          state.questions?.isNotEmpty != true)) {
                    return const SizedBox();
                  }

                  final questions = state.questions!;
                  final indexVocabulary = state.indexQuestion;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      /// app bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: const CancelButton(),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CoinPackageScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 8.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  BlocBuilder<UserCubit, UserState>(
                                    builder: (context, state) {
                                      if (state is UserLoaded) {
                                        return Text(
                                          state.user.coins.toInt().toString(),
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.black),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Image.asset(
                                    'assets/dollar.png',
                                    height: 30.w,
                                    width: 30.w,
                                    fit: BoxFit.fill,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      /// content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: Text(
                              "Correct Answer ${indexVocabulary + 1}/${questions.length}",
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: QuizWidget(
                              key:
                                  ValueKey(questions[indexVocabulary].question),
                              quiz: questions[indexVocabulary],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NaviButton extends StatelessWidget {
  const NaviButton(
      {super.key,
      required this.onTap,
      required this.icon,
      required this.iconSize});

  final Function() onTap;
  final Widget icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        height: iconSize,
        width: iconSize,
        // padding: EdgeInsets.all(8.spMin),
        decoration: BoxDecoration(
          color: Colors.blue.shade200,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(2, 2), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: icon,
        ),
      ),
    );
  }
}
