import '../../../feature/flash_card/widgets/flash_card.dart';
import '../../../models/category_model.dart';
import '../../../models/vocabulary_model.dart';
import '../../../services/vocabulary_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_btn_back.dart';
import 'linear_progress_widget.dart';

class FlashCardDetail extends StatefulWidget {
  const FlashCardDetail({super.key, required this.category});

  final Category category;

  @override
  State<FlashCardDetail> createState() => _FlashCardDetailState();
}

class _FlashCardDetailState extends State<FlashCardDetail> {
  late Future<List<Vocabulary>> _futureVocabularies;
  int _indexVocabulary = 0;

  @override
  void initState() {
    super.initState();
    _futureVocabularies = VocabularyService()
        .loadVocabulary("assets/data/${widget.category.filename}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder<List<Vocabulary>>(
        future: _futureVocabularies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data?.isNotEmpty != true) {
            return const SizedBox();
          }

          final vocabularies = snapshot.data!;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ).copyWith(top: 16.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: CustomBtnBack(
                        iconSize: 30.h,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: LinearProgressWidget(
                        percent: (_indexVocabulary + 1) / vocabularies.length,
                        lineHeight: 24.h,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          child: FlashCard(
                            key: ValueKey(vocabularies[_indexVocabulary].word),
                            vocabulary: vocabularies[_indexVocabulary],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            NaviButton(
                              onTap: () {
                                setState(() {
                                  _indexVocabulary = (_indexVocabulary - 1)
                                      .clamp(0, vocabularies.length - 1);
                                });
                              },
                              iconSize: 40.w,
                              icon: Icon(
                                Icons.arrow_back_ios_rounded,
                                size: 16.w,
                                color: Colors.white,
                              ),
                            ),
                            NaviButton(
                              onTap: () {
                                setState(() {
                                  _indexVocabulary = (_indexVocabulary + 1)
                                      .clamp(0, vocabularies.length - 1);
                                });
                              },
                              iconSize: 40.w,
                              icon: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16.w,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      )),
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
