import 'package:flash_card_app/commons/extensions/string_extension.dart';
import 'package:flash_card_app/feature/flash_card/widgets/coin_package_screen.dart';
import 'package:flash_card_app/feature/flash_card/widgets/flash_card_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../models/category_model.dart';
import '../../../services/category_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Topics',
                    style: TextStyle(fontSize: 24.sp),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoinPackageScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_bag_rounded)),
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

                    return ListView.separated(
                      itemCount: categories.length,
                      padding: EdgeInsets.only(bottom: 20.h),
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: ListTile(
                            title: Text(cat.title),
                            subtitle: Text(cat.slug
                                .replaceAll('-', ' ')
                                .capitalizeFirstLetter),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => FlashCardDetail(
                                  category: cat,
                                ),
                              ));
                            },
                          ),
                        );
                      },
                    );
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
