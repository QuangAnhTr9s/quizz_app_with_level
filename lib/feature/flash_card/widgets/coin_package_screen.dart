import 'package:flash_card_app/feature/flash_card/widgets/custom_btn_back.dart';
import 'package:flash_card_app/purchase/models/coin_package.dart';
import 'package:flash_card_app/purchase/purchase_book_services.dart';
import 'package:flash_card_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoinPackageScreen extends StatefulWidget {
  const CoinPackageScreen({super.key});

  @override
  State<CoinPackageScreen> createState() => _CoinPackageScreenState();
}

class _CoinPackageScreenState extends State<CoinPackageScreen> {
  final List<CoinPackage> packages = AppInfoConstants.coinsPackages;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBtnBack(
                    iconSize: 30.w,
                  ),
                  Text(
                    'Coins',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  SizedBox(
                    width: 30.w,
                  )
                ],
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: packages.length,
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  physics: const ClampingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    mainAxisExtent: 200.h,
                    // childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final pkg = packages[index];
                    return InkWell(
                      onTap: () => PurchaseBookServices()
                          .purchase(coinPackage: pkg, context: context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.shade100,
                              blurRadius: 6.r,
                              offset: Offset(0, 4.h),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(height: 12.h),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Image.asset(pkg.imageAsset,
                                    fit: BoxFit.contain),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              '${pkg.coinAmount} Coins',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 40.h,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16.r),
                                    bottomRight: Radius.circular(16.r),
                                  ),
                                ),
                                child: Center(
                                    child: Text(pkg.price,
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.white))),
                              ),
                            ),
                          ],
                        ),
                      ),
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
