import 'package:cached_network_image/cached_network_image.dart';
import '../../../commons/extensions/string_extension.dart';
import '../../../commons/text_to_speech.dart';
import '../../../models/vocabulary_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_flip_builder/page_flip_builder.dart';

class FlashCard extends StatefulWidget {
  const FlashCard({super.key, required this.vocabulary});

  final Vocabulary vocabulary;

  @override
  State<FlashCard> createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 600.h),
      child: PageFlipBuilder(
        frontBuilder: (context) {
          return CardWidget(
            content: widget.vocabulary.word,
          );
        },
        backBuilder: (context) {
          return CardWidget(
            image: widget.vocabulary.image,
            content: widget.vocabulary.translate,
          );
        },
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                TextToSpeech().speakText(content ?? '');
              },
              child: Container(
                  height: 36.w,
                  width: 36.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade600,
                  ),
                  child: const Icon(Icons.volume_up, color: Colors.white)),
            ),
          ),
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
        ],
      ),
    );
  }
}
