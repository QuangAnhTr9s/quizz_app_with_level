import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DialogServices {
  static void showLoadingPurchase(BuildContext context) {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = Colors.white
      ..indicatorColor = Colors.purple
      ..textColor = Colors.black
      // ..textStyle = AppStyles.body1.copyWith(fontWeight: FontWeight600)
      ..radius = 16
      ..textPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 30)
      ..contentPadding =
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    EasyLoading.show(
      status: 'Payment in progress',
      maskType: EasyLoadingMaskType.black,
    );
  }

  static void hideLoadingPurchase(BuildContext context) {
    EasyLoading.dismiss();
  }

  static void showLoadingDialog(BuildContext context) {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = Colors.white
      ..indicatorColor = Colors.blue
      ..textColor = Colors.black
      // ..textStyle = AppStyles.body1.copyWith(fontWeight: FontWeight600)
      ..radius = 16
      ..textPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 30)
      ..contentPadding =
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    EasyLoading.dismiss();
  }

  static Future<void> showDialogSuccessUnlockBook(
    BuildContext context, {
    String? title,
    String? content,
    String? contentBtn1,
  }) {
    EasyLoading.instance.indicatorColor = Colors.green;
    return EasyLoading.showSuccess('Payment Successful');
  }

  static Future<void> showDialogWrongUnlockBook(
    BuildContext context, {
    String? title,
    String? content,
    String? contentBtn1,
  }) {
    EasyLoading.instance.indicatorColor = Colors.red;
    return EasyLoading.showError(
      'Payment Failed',
    );
  }
}
