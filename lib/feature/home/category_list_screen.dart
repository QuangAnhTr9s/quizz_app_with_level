import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizz_app/commons/extensions/index.dart';
import 'package:quizz_app/cubits/user/user_cubit.dart';
import 'package:quizz_app/feature/quizz/quiz_screen.dart';
import '../purchase/coin_package_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/category_model.dart';
import '../../services/category_service.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  late Future<List<Category>> futureCategories;

  @override
  void initState() {
    super.initState();
    futureCategories =
        CategoryService().loadCategories('assets/data/categories.json');
  }

  void _showPurchaseDialog(Category category) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Purchase "${category.title}"',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.orange.shade700),
          ),
          content: Text(
            'Do you want to purchase this category for ${category.price} coins?',
            style: const TextStyle(fontSize: 16),
          ),
          actionsPadding:
              EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black87,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (context.read<UserCubit>().state is UserLoaded) {
                  final currentCoins =
                      (context.read<UserCubit>().state as UserLoaded)
                          .user
                          .coins;
                  if (currentCoins >= category.price) {
                    // Deduct coins
                    context.read<UserCubit>().purchaseTopic(category);

                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    _showInsufficientCoinDialog();
                  }
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Buy'),
            ),
          ],
        );
      },
    );
  }

  void _showInsufficientCoinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Insufficient Coins',
          style: TextStyle(
              color: Colors.red.shade700, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'You do not have enough coins to purchase this category.',
          style: TextStyle(fontSize: 16),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.orange.shade200,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0b36c),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ).copyWith(top: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Topics',
                    style: TextStyle(fontSize: 24.sp),
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
                                    fontSize: 24.sp, color: Colors.yellow),
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
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Expanded(
                child: FutureBuilder<List<Category>>(
                  future: futureCategories,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const SizedBox();
                    }

                    final categories = snapshot.data!;

                    return BlocBuilder<UserCubit, UserState>(
                        builder: (context, state) {
                      return ListView.separated(
                        itemCount: categories.length,
                        padding: EdgeInsets.only(bottom: 20.h),
                        separatorBuilder: (_, __) => SizedBox(height: 10.h),
                        itemBuilder: (context, index) {
                          if (state is UserLoaded) {
                            final cat = categories[index];
                            bool isUnlocked =
                                state.user.unlockedTopics.contains(cat.title) ||
                                    cat.price == 0;
                            return InkWell(
                              onTap: () {
                                if (isUnlocked) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const QuizScreen(),
                                  ));
                                } else {
                                  _showPurchaseDialog(cat);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50.w,
                                      height: 50.w,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: cat.image != null &&
                                              cat.image!.isNotEmpty
                                          ? CachedNetworkImage(
                                              imageUrl: cat.image!)
                                          : const SizedBox(),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(cat.title,
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              cat.slug
                                                  .replaceAll('-', ' ')
                                                  .capitalizeFirstLetter,
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Colors.black54)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    if (isUnlocked)
                                      Icon(Icons.arrow_forward_ios, size: 16.w)
                                    else
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w, vertical: 4.h),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade200,
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                        ),
                                        child: Text(
                                          '${cat.price}\ncoins',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
