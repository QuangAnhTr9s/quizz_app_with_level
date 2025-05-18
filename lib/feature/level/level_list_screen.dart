import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizz_app/cubits/user/user_cubit.dart';
import 'package:quizz_app/feature/quizz/quiz_screen.dart';
import 'package:quizz_app/models/level.dart';
import '../purchase/coin_package_screen.dart';
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
        backgroundColor: const Color(0xff272052),
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
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CoinPackageScreen(),
                        ),
                      );
                    },
                    child: IntrinsicWidth(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 4.h, horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BlocBuilder<UserCubit, UserState>(
                              builder: (context, state) {
                                if (state is UserLoaded) {
                                  return Text(
                                    state.user.coins.toInt().toString(),
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontFamily:
                                          GoogleFonts.beVietnamPro().fontFamily,
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                            SizedBox(
                              width: 8.w,
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
                  ),
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
                            if (state is UserLoaded) {
                              final cat = item[index];
                              bool isDone = cat.isDone;
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const QuizScreen(),
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
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        child: Container(
                                          width: 80.w,
                                          height: 80.w,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                          ),
                                          child: cat.avatar != null &&
                                                  cat.avatar!.isNotEmpty
                                              ? Image.asset(
                                                  "assets/${cat.avatar!}",
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
                                            Text(cat.name ?? '',
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        GoogleFonts.jotiOne()
                                                            .fontFamily)),
                                            SizedBox(height: 8.h),
                                            InfoLevel(cat: cat),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 6.w),

                                      /// checked icon
                                      if (isDone)
                                        Image.asset(
                                          'assets/ic_checked.png',
                                          height: 24.w,
                                          width: 24.w,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
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
