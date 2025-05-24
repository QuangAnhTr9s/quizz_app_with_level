import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizz_app/commons/constant.dart';
import 'package:quizz_app/commons/widgets/cancel_button.dart';
import 'package:quizz_app/commons/widgets/coin_button.dart';
import 'package:quizz_app/feature/quizz/widgets/quiz_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quizz_app/models/level.dart';

import 'cubit/quiz_cubit.dart';
import 'dialogs/dialog_services.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    this.heart,
    this.changeQuizCount,
    this.eliminateAnswerCount,
    this.image,
    this.currentLevel,
  });

  static const routeName = '/quizScreen';
  final int? heart;
  final int? changeQuizCount;
  final int? eliminateAnswerCount;
  final String? image;
  final Level? currentLevel;
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _quizCubit = QuizCubit();

  @override
  void initState() {
    super.initState();
    _quizCubit.level = widget.currentLevel;
    _quizCubit.loadQuiz(
      heart: widget.heart,
      changeQuizCount: widget.changeQuizCount,
      eliminateAnswerCount: widget.eliminateAnswerCount,
    );
  }

  @override
  void dispose() {
    _quizCubit.close();
    super.dispose();
  }

  void replayFunc() {
    _quizCubit.saveRecord();
    _quizCubit.loadQuiz(
      heart: widget.heart,
      changeQuizCount: widget.changeQuizCount,
      eliminateAnswerCount: widget.eliminateAnswerCount,
    );
  }

  void goHomeFunc() {
    _quizCubit.saveRecord();
    Navigator.of(context).popUntil(
      (route) => route.isFirst,
      // (route) => route.settings.name == '/home',
    );
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
                replayFunc: replayFunc,
                goHomeFunc: goHomeFunc,
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
                replayFunc: replayFunc,
                goHomeFunc: goHomeFunc,
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
              color: Color(0xff793ae7),
            ),
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
                  final indexQuestion = state.indexQuestion;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      /// app bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: CancelButton(
                              onTap: () => _quizCubit.saveRecord(),
                            ),
                          ),
                          const CoinButton(),
                        ],
                      ),
                      SizedBox(
                        height: 16.h,
                      ),

                      /// content
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            /// image
                            if (widget.image?.isNotEmpty == true)
                              Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Container(
                                    width: double.maxFinite,
                                    height: 300.h,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                    ),
                                    child: Image.asset(
                                      "assets/${widget.image!}",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: QuizWidget(
                                key:
                                    ValueKey(questions[indexQuestion].question),
                                quiz: questions[indexQuestion],
                                percent:
                                    (indexQuestion) / (questions.length - 1),
                              ),
                            ),
                          ],
                        ),
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
