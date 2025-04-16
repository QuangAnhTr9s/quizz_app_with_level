import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../commons/widgets/cancel_button.dart';
import '../../../cubits/user/user_cubit.dart';
import '../../purchase/coin_package_screen.dart';
import '../models/quiz_record.dart';

class QuizRecordScreen extends StatelessWidget {
  const QuizRecordScreen({super.key, required this.records});

  final List<QuizRecord> records;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
      ).copyWith(top: 16.h),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/bg_image.png"), fit: BoxFit.fill)),
      child: SafeArea(
        child: Column(
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
                        builder: (context) => const CoinPackageScreen(),
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
                                    fontSize: 16.sp, color: Colors.black),
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
            SizedBox(
              height: 20.h,
            ),

            /// content
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Bảng xếp hạng',
                  style: TextStyle(fontSize: 20.sp, color: Colors.white),
                ),
                SizedBox(
                  height: 20.h,
                ),
                ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    QuizRecord record = records[index];
                    return Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: const Color(0xffAF7EE7),
                            ),
                          ),
                          SizedBox(
                            width: 24.w,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${record.correctAnswers} câu trả lời đúng",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff46557B),
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Text(
                                DateFormat('HH:mm dd/MM/yyyy')
                                    .format(record.createdAt),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  shrinkWrap: true,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
