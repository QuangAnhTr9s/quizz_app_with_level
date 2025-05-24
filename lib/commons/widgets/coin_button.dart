import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizz_app/cubits/user/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quizz_app/feature/purchase/coin_package_screen.dart';

class CoinButton extends StatefulWidget {
  const CoinButton({super.key});

  @override
  State<CoinButton> createState() => _CoinButtonState();
}

class _CoinButtonState extends State<CoinButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
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
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),
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
                        fontFamily: GoogleFonts.beVietnamPro().fontFamily,
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
    );
  }
}
