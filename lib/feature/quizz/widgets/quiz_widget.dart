import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quizz_app/commons/extensions/index.dart';
import 'package:quizz_app/feature/quizz/widgets/quiz_button.dart';

class QuizWidget extends StatelessWidget {
  const QuizWidget({
    super.key,
    this.image,
    this.content,
  });

  final String? image;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade300,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// question
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (image?.isNotEmpty == true)
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    child: CachedNetworkImage(
                      imageUrl: image!,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const SizedBox(),
                      fit: BoxFit.contain,
                      // memCacheHeight: 150,
                      // memCacheWidth: 150,
                    ),
                  ),
                ),
              if (content?.isNotEmpty == true)
                Text(
                  content!.toCapitalized(),
                  style: TextStyle(fontSize: 24.sp, color: Colors.white),
                ),
            ],
          ),

          /// answers
          QuizletBtnTrueFalse(
            isTrueAnswer: true,
          ),
        ],
      ),
    );
  }
}
