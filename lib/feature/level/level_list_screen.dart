import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizz_app/commons/widgets/coin_button.dart';
import 'package:quizz_app/feature/quizz/quiz_screen.dart';
import 'package:quizz_app/models/level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'cubit/level_cubit.dart';

class LevelListScreen extends StatefulWidget {
  const LevelListScreen({super.key});

  @override
  State<LevelListScreen> createState() => _LevelListScreenState();
}

class _LevelListScreenState extends State<LevelListScreen> {
  late Future<List<Level>> futureCategories;
  final _levelCubit = LevelCubit();

  @override
  void initState() {
    super.initState();
    _levelCubit.loadLevels();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _levelCubit,
      child: Scaffold(
        backgroundColor: const Color(0xff793ae7),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ).copyWith(top: 16.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// coin button
                const Align(
                  alignment: Alignment.center,
                  child: CoinButton(),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  'Trials of the Mind',
                  style: TextStyle(
                      fontSize: 24.sp,
                      color: Colors.white,
                      fontFamily: GoogleFonts.jotiOne().fontFamily),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Expanded(
                  child: BlocBuilder<LevelCubit, LevelState>(
                    bloc: _levelCubit,
                    builder: (context, state) {
                      if (state is LevelLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is LevelLoaded) {
                        final item = state.levels!;

                        return ListView.separated(
                          itemCount: item.length,
                          padding: EdgeInsets.only(bottom: 20.h),
                          separatorBuilder: (_, __) => SizedBox(height: 10.h),
                          itemBuilder: (context, index) {
                            final level = item[index];
                            bool isDone = level.isDone;
                            return InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                      builder: (context) => QuizScreen(
                                        image: level.avatar,
                                        heart: level.hp,
                                        changeQuizCount: level.changeQuestion,
                                        eliminateAnswerCount:
                                            level.eliminateAnswer,
                                        currentLevel: level,
                                      ),
                                    ))
                                    .then(
                                      (value) => _levelCubit.loadLevels(),
                                    );
                              },
                              child: Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  children: [
                                    /// avatar
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: Container(
                                        width: 80.w,
                                        height: 80.w,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                        ),
                                        child: level.avatar != null &&
                                                level.avatar!.isNotEmpty
                                            ? Image.asset(
                                                "assets/${level.avatar!}",
                                                fit: BoxFit.fill,
                                              )
                                            : const SizedBox(),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),

                                    /// info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(level.name ?? '',
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                      GoogleFonts.jotiOne()
                                                          .fontFamily)),
                                          SizedBox(height: 8.h),
                                          InfoLevel(cat: level),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 6.w),

                                    /// checked icon
                                    if (isDone)
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxHeight: 24.w, maxWidth: 24.w),
                                        child: Image.asset(
                                          'assets/ic_checked.png',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoLevel extends StatelessWidget {
  const InfoLevel({
    super.key,
    required this.cat,
  });

  final Level cat;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
        fontSize: 10.w,
        fontWeight: FontWeight.w700,
        color: const Color(0xffFC6049),
        fontFamily: GoogleFonts.beVietnamPro().fontFamily);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.favorite,
          color: Colors.red,
          size: 12.w,
        ),
        Text(
          (cat.hp ?? 1).toString(),
          style: textStyle,
        ),
        SizedBox(width: 10.w),
        Icon(
          Icons.autorenew,
          color: Colors.red,
          size: 12.w,
        ),
        Text(
          (cat.changeQuestion ?? 1).toString(),
          style: textStyle,
        ),
        SizedBox(width: 10.w),
        Icon(
          Icons.remove_circle,
          color: Colors.red,
          size: 12.w,
        ),
        Text(
          (cat.eliminateAnswer ?? 1).toString(),
          style: textStyle,
        ),
        SizedBox(width: 10.w),
        Text(
          'Questions: ',
          style: textStyle,
        ),
        Text(
          (cat.questionCount ?? 20).toString(),
          style: textStyle,
        ),
      ],
    );
  }
}
