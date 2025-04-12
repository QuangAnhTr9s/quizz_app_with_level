import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flash_card_app/purchase/models/coin_package.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

import '../services/dialog_services.dart';
import '../services/user_service.dart';
import '../utils/constant.dart';
import 'config_key.dart';
import 'iap_listener.dart';
import 'iap_module.dart';
import 'models/sub_package.dart';

class PurchaseBookServices implements InAppPurchaseListener {
  static final PurchaseBookServices _instance =
      PurchaseBookServices._internal();

  factory PurchaseBookServices() {
    return _instance;
  }

  PurchaseBookServices._internal() {
    listSubBookPackages = AppInfoConstants.listSubPackages;
    listCoinPackages = AppInfoConstants.coinsPackages;
    _currentSubBookPackage ??= listSubBookPackages[0];
  }

  List<SubPackage> listSubBookPackages = [];
  List<CoinPackage> listCoinPackages = [];

  SubPackage? _currentSubBookPackage;
  CoinPackage? _currentCoinPackage;

  bool checkCallPurchase = false;
  int? bookId = 0;
  BuildContext? buildContext;

  //String _key = 'purchased_book';
  ValueNotifier<bool> isSuccessPurchaseNotifier = ValueNotifier(false);
  bool canShowSuccessDialog = true;
  bool canShowWrongDialog = true;
  bool _isBuyNonConsumable = true;

  Timer? paymentTimeoutTimer;

  // final int _paymentTimeoutSeconds = 90;

  ///Todo: init when start purchase
  void initApp({bool isBuyNonConsumable = true}) {
    _isBuyNonConsumable = isBuyNonConsumable;
    InAppPurchaseModule.getInstance().inAppPurchaseListener = this;
    InAppPurchaseModule.getInstance().installIAP();
    InAppPurchaseModule.getInstance().setProduct = [];
    InAppPurchaseModule.getInstance().kProductIdsNull = [];
    if (Platform.isAndroid) {
      InAppPurchaseModule.getInstance().kProductIds = isBuyNonConsumable
          ? [
              ConfigKey.keySub1Android,
              ConfigKey.keySub2Android,
              ConfigKey.keySub3Android,
              ConfigKey.keySub4Android,
              ConfigKey.keySub5Android,
              ConfigKey.keySub6Android,
            ]
          : [
              ConfigKey.keyCoin1,
              ConfigKey.keyCoin2,
              ConfigKey.keyCoin3,
              ConfigKey.keyCoin4,
              ConfigKey.keyCoin5,
              ConfigKey.keyCoin6,
            ];
    } else if (Platform.isIOS) {
      InAppPurchaseModule.getInstance().kProductIds = isBuyNonConsumable
          ? [
              ConfigKey.keySub1Ios,
              ConfigKey.keySub2Ios,
              ConfigKey.keySub3Ios,
              ConfigKey.keySub4Ios,
              ConfigKey.keySub5Ios,
              ConfigKey.keySub6Ios,
            ]
          : [
              ConfigKey.keyCoin1,
              ConfigKey.keyCoin2,
              ConfigKey.keyCoin3,
              ConfigKey.keyCoin4,
              ConfigKey.keyCoin5,
              ConfigKey.keyCoin6,
            ];
    }
  }

  List<ProductDetails> removeDuplicateProductWithId(List<ProductDetails> pros) {
    // Sử dụng Map để lưu trữ các phần tử với id duy nhất
    final Map<String, ProductDetails> uniqueProMap = {};

    for (var pro in pros) {
      uniqueProMap[pro.id] = pro;
    }

    // Chuyển đổi Map trở lại thành List
    return uniqueProMap.values.toList();
  }

  ///Todo load info product

  Future<void> getStoreInfo() async {
    // add loading

    await Future<void>.delayed(const Duration(seconds: 1));

    await InAppPurchaseModule.getInstance().getStoreInfo();
    var list = InAppPurchaseModule.getInstance().products;
    list = removeDuplicateProductWithId(list);
    checkCallPurchase = false;
    // emit(PaymentBooksSucssess(
    //   status: status,
    //   bookId: this.bookId,
    //   productDetails: list,
    //   purchasePending: false,
    //   listHistory: [],
    // ));
  }

  ///Todo close iap
  void dispose() {
    InAppPurchaseModule.getInstance().close();
  }

  // void setPaymentTimeoutTimer() {
  //   if (paymentTimeoutTimer != null && paymentTimeoutTimer!.isActive) {
  //     paymentTimeoutTimer!.cancel();
  //     paymentTimeoutTimer = null;
  //   }
  //   paymentTimeoutTimer = Timer(Duration(seconds: _paymentTimeoutSeconds), () {
  //     hideLoadingPurchase();
  //     if (buildContext != null && buildContext!.mounted) {
  //       DialogServices.showDialogTimeoutPurchase(buildContext!);
  //     }
  //   });
  // }

  /// Todo purchase
  Future<void> purchase(
      {SubPackage? subBookPackage,
      CoinPackage? coinPackage,
      required BuildContext context}) async {
    buildContext = context;
    canShowSuccessDialog = true;
    canShowWrongDialog = true;
    showLoadingPurchase();
    // setPaymentTimeoutTimer();

    var status = await InAppPurchaseModule.getInstance().getStoreInfo();

    if (StoreStatus.empty == status ||
        StoreStatus.error == status ||
        StoreStatus.unavailable == status) {
      showErrorDialog();
      return;
    }
    try {
      int productIndex = 0;

      int index = -1;
      if (_isBuyNonConsumable) {
        _currentSubBookPackage =
            subBookPackage ?? _currentSubBookPackage ?? listSubBookPackages[0];
        index = listSubBookPackages.indexWhere((element) =>
            element.keyStoreAndroid == _currentSubBookPackage?.keyStoreAndroid);
      } else {
        _currentCoinPackage =
            coinPackage ?? _currentCoinPackage ?? listCoinPackages[0];
        index = listCoinPackages.indexWhere(
            (element) => element.keyStore == _currentCoinPackage?.keyStore);
      }
      productIndex = index != -1 ? index : productIndex;

      InAppPurchaseModule.getInstance().setNavigators = true;
      // await ApiClient.dioCacheManager.clearAll();

      await getStoreInfo();
      // emit((state as PaymentBooksSucssess)
      //     .copyWith(purchasePending: true, bookId: bookId));

      var userId = AppInfoConstants.userId;
      var product = InAppPurchaseModule.getInstance().products[productIndex];

      if (kDebugMode) {
        print('isBuyNonConsumable: $_isBuyNonConsumable');
      }
      await InAppPurchaseModule.getInstance().purchase(product, {}, userId,
          isBuyNonConsumable: _isBuyNonConsumable);
    } catch (e) {
      // Handle exceptions here
      hideLoadingPurchase();
      if (kDebugMode) {
        print('Purchase failed: $e');
      }
    }
  }

  ///Todo restore
  void restore(
      {String? originalTransactionId,
      String? paymentPackage,
      bool? isRestore}) async {
    canShowSuccessDialog = false;
    canShowWrongDialog = false;
    checkCallPurchase = false;
    var username = AppInfoConstants.userId;
    await InAppPurchaseModule.getInstance()
        .inAppPurchase
        .restorePurchases(applicationUserName: username);
  }

  @override
  Future<void> deliverProduct(PurchaseDetails? purchaseDetails) async {
    InAppPurchaseModule.getInstance().setNavigators = false;
  }

  @override
  Future<void> handleErrorPurchase(IAPError? error) async {
    if (Platform.isIOS) {
      if (error?.message == 'SKErrorDomain' ||
          error?.message == 'NSCocoaErrorDomain') {
        hideLoadingPurchase();
        // emit(PaymentBooksError(isTap: false));
      } else {
        if (kDebugMode) {
          print('handleErrorPurchase ${error?.message}');
        }
        showErrorDialog();
        // emit(PaymentBooksError(isTap: true));
      }
    } else {
      if (error?.message == 'BillingResponse.userCanceled') {
        hideLoadingPurchase();
        // emit(PaymentBooksError(isTap: false));
      } else {
        showErrorDialog();
        // emit(PaymentBooksError(isTap: true));
      }
    }
  }

  @override
  void handleInvalidPurchase(PurchaseDetails? purchaseDetails) async {
    if (purchaseDetails?.productID == '') {
      return;
    }
    showErrorDialog();
    // emit(PaymentBooksError(isTap: true));
  }

  @override
  void onDoneListener() {
    log('message done');
  }

  @override
  void onErrorListener(error) {
    // TODO: implement onErrorListener
    log('message $error');
  }

  @override
  void purchaseUpdate(List<PurchaseDetails>? purchaseDetailsList) {}

  @override
  Future<bool> verifyPurchase(PurchaseDetails? purchaseDetails) async {
    if (purchaseDetails == null) {
      return false;
    }

    if (Platform.isAndroid) {
      await handleAndroidPurchase(
          purchaseDetails: purchaseDetails as GooglePlayPurchaseDetails);
    }

    if (Platform.isIOS && purchaseDetails.status == PurchaseStatus.purchased) {
      await handleIOSPurchase(
          purchaseDetails: purchaseDetails as AppStorePurchaseDetails);
    }

    return true;
  }

  Future<void> handleAndroidPurchase({
    GooglePlayPurchaseDetails? purchaseDetails,
  }) async {
    if (purchaseDetails == null) {
      return;
    }
    // PurchasedBook purchasedBook = PurchasedBook(
    //   id: bookId ?? AppInfoConstants.bookId,
    //   purchaseID: purchaseDetails.productID,
    //   purchaseToken: purchaseDetails.verificationData.serverVerificationData,
    //   serverVerificationData:
    //       purchaseDetails.verificationData.serverVerificationData,
    //   localVerificationData:
    //       purchaseDetails.verificationData.localVerificationData,
    // );
    if (!checkCallPurchase) {
      checkCallPurchase = true;
      await showSuccessDialog();

      // /// log to server
      // Either<BaseError, dynamic> response;
      // if (_isBuyNonConsumable) {
      //   response = await _purchaseBookRepo.subBook(
      //     purchaseToken:
      //         purchaseDetails.verificationData.serverVerificationData,
      //     bookId: bookId ?? AppInfoConstants.bookId,
      //     packageName: AppInfoConstants.appId,
      //     productId: purchaseDetails.productID,
      //   );
      // } else {
      //   response = await _purchaseBookRepo.purchaseBook(
      //     purchaseToken:
      //         purchaseDetails.verificationData.serverVerificationData,
      //     bookId: bookId ?? AppInfoConstants.bookId,
      //     packageName: AppInfoConstants.appId,
      //     productId: purchaseDetails.productID,
      //   );
      // }
      //
      // response.fold((l) async {
      //   purchasedBook = purchasedBook.copyWith(
      //     purchasedBookState: PurchasedBookState.error,
      //   );
      //   showErrorDialog();
      //   await saveListPurchasedBooks(purchasedBook);
      // }, (r) async {
      //   await showSuccessDialog();
      // });
    }
  }

  Future<void> handleIOSPurchase(
      {AppStorePurchaseDetails? purchaseDetails, int? bookId}) async {
    if (purchaseDetails == null) {
      return;
    }
    // var skPaymentTransaction = purchaseDetails.skPaymentTransaction;
    // // String? purchaseID = '${skPaymentTransaction.transactionIdentifier}';
    // String? purchaseID =
    //     skPaymentTransaction.originalTransaction?.transactionIdentifier ??
    //         '${skPaymentTransaction.transactionIdentifier}';
    // PurchasedBook purchasedBook = PurchasedBook(
    //   id: bookId ?? AppInfoConstants.bookId,
    //   purchaseID: purchaseID,
    //   productID: purchaseDetails.productID,
    //   serverVerificationData:
    //       purchaseDetails.verificationData.serverVerificationData,
    // );
    if (!checkCallPurchase) {
      checkCallPurchase = true;
      await showSuccessDialog();

      // /// log to server
      // Either<BaseError, dynamic> response;
      // if (_isBuyNonConsumable) {
      //   response = await _purchaseBookRepo.subBook(
      //     bookId: bookId ?? AppInfoConstants.bookId,
      //     purchaseID: purchaseID,
      //   );
      // } else {
      //   response = await _purchaseBookRepo.purchaseBook(
      //     bookId: bookId ?? AppInfoConstants.bookId,
      //     purchaseID: purchaseID,
      //   );
      // }
      // response.fold((l) async {
      //   purchasedBook = purchasedBook.copyWith(
      //     purchasedBookState: PurchasedBookState.error,
      //   );
      //   showErrorDialog();
      //   await saveListPurchasedBooks(purchasedBook);
      // }, (r) async {
      //   await showSuccessDialog();
      // });
    }
  }

  @override
  void pendingUI(bool pending) {
    // if (state is PaymentBooksSucssess) {
    //   emit((state as PaymentBooksSucssess)
    //       .copyWith(purchasePending: pending, isNavigator: false));
    // }

    if (pending) {
      if (Platform.isIOS) {
        // setPaymentTimeoutTimer();
      }
    } else {
      if (paymentTimeoutTimer != null && paymentTimeoutTimer!.isActive) {
        paymentTimeoutTimer!.cancel();
        paymentTimeoutTimer = null;
      }
    }
  }

  @override
  Future<void> setPackage() async {
    try {} catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> showSuccessDialog() async {
    // UserService.isUnlocked = true;
    if (buildContext != null && buildContext!.mounted && canShowSuccessDialog) {
      canShowSuccessDialog = false;
      canShowWrongDialog = false;
      hideLoadingPurchase();
      await DialogServices.showDialogSuccessUnlockBook(buildContext!).then(
        (value) {
          canShowSuccessDialog = true;
          canShowWrongDialog = true;
        },
      );
    }
    isSuccessPurchaseNotifier.value = true;

    // QuestionImageService downloadQuestionImageService = QuestionImageService();
    // await downloadQuestionImageService.downloadQuestionImages(buildContext!);

    // await downloadQuestionImageService.deleteFilesInDirectory().then(
    //       (value) async {
    //     await downloadQuestionImageService
    //         .downloadQuestionImages(buildContext!);
    //   },
    // );
  }

  void showErrorDialog() {
    isSuccessPurchaseNotifier.value = false;
    if (buildContext != null && buildContext!.mounted && canShowWrongDialog) {
      canShowSuccessDialog = false;
      canShowWrongDialog = false;
      hideLoadingPurchase();
      DialogServices.showDialogWrongUnlockBook(buildContext!).then(
        (value) {
          canShowSuccessDialog = true;
          canShowWrongDialog = true;
        },
      );
    }
  }

  void showLoadingPurchase() {
    isSuccessPurchaseNotifier.value = false;
    if (buildContext != null && buildContext!.mounted) {
      DialogServices.showLoadingPurchase(buildContext!);
    }
  }

  void hideLoadingPurchase() {
    if (buildContext != null && buildContext!.mounted) {
      DialogServices.hideLoadingPurchase(buildContext!);
    }
  }
}
