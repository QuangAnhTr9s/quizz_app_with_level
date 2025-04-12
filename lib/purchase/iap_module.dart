import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import '../utils/constant.dart';
import 'iap_listener.dart';
import 'models/sub_package.dart';

class InAppPurchaseModule {
  InAppPurchaseListener? inAppPurchaseListener;
  late InAppPurchase _inAppPurchase;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];

  bool purchasePending = false;
  bool _isNavigator = false;
  String? _queryProductError;
  final List<String> _kProductIds = <String>[];

  static InAppPurchaseModule? _inAppPurchaseModule;

  static InAppPurchaseModule getInstance() {
    return _inAppPurchaseModule ??= InAppPurchaseModule();
  }

  void debugPrint(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  ///init open app
  void installIAP() {
    _products = [];
    _inAppPurchase = InAppPurchase.instance;

    ///lắng nghe nhận thông tin cập nhật theo thời gian thực cho các giao dịch mua.
    final purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      inAppPurchaseListener?.onDoneListener();
      _subscription.cancel();
    }, onError: (error) {
      inAppPurchaseListener?.onErrorListener(error);
    });
  }

  ///load product
  Future<StoreStatus> getStoreInfo() async {
    ///Trả về `true` nếu nền tảng thanh toán đã sẵn sàng và có sẵn.
    _products = [];
    final isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      _products = [];
      _purchases = [];
      _notFoundIds = [];
      inAppPurchaseListener?.pendingUI(false);
      return StoreStatus.unavailable;
    }

    if (Platform.isIOS) {
      var iosPlatformAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(PaymentQueueDelegate());
    }
    var productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      _queryProductError = productDetailResponse.error!.message;
      _products = productDetailResponse.productDetails;
      _purchases = [];
      _notFoundIds = productDetailResponse.notFoundIDs;
      inAppPurchaseListener?.pendingUI(false);
      return StoreStatus.error;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      _queryProductError = null;
      _products = productDetailResponse.productDetails;
      _purchases = [];
      _notFoundIds = productDetailResponse.notFoundIDs;
      inAppPurchaseListener?.pendingUI(false);
      return StoreStatus.empty;
    }
    _products = productDetailResponse.productDetails;
    if (Platform.isIOS) {
      _products.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
    }
    _notFoundIds = productDetailResponse.notFoundIDs;
    inAppPurchaseListener?.pendingUI(false);
    await clearTransactionsIos();
    return StoreStatus.ok;
  }

  Future<void> purchase(ProductDetails productDetails,
      Map<String, PurchaseDetails> purchases, String applicationUserName,
      {bool isBuyNonConsumable = false}) async {
    late PurchaseParam purchaseParam;
    if (Platform.isAndroid) {
      final purchasess = Map<String, PurchaseDetails>.fromEntries(
          _purchases.map((PurchaseDetails purchase) {
        if (purchase.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchase);
        }
        return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
      }));
      final oldSubscription =
          await _getOldSubscription(productDetails, purchasess);
      purchaseParam = GooglePlayPurchaseParam(
          productDetails: productDetails,
          applicationUserName: applicationUserName,
          changeSubscriptionParam: (oldSubscription != null)
              ? ChangeSubscriptionParam(
                  oldPurchaseDetails: oldSubscription,
                  replacementMode:
                      oldSubscription.productID == AppInfoConstants.appId
                          ? ReplacementMode.deferred
                          : ReplacementMode.withTimeProration,
                )
              : null);
    } else {
      purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: applicationUserName,
      );
    }
    try {
      if (isBuyNonConsumable) {
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        await _inAppPurchase.buyConsumable(
            purchaseParam: purchaseParam, autoConsume: true);
      }
    } on PlatformException catch (e) {
      if (e.code == 'storekit_duplicate_product_object') {
        debugPrint('storekit_duplicate_product_object');
        inAppPurchaseListener
            ?.handleErrorPurchase(IAPError(source: '', message: '', code: ''));
      }
    }
  }

  Future<GooglePlayPurchaseDetails?> _getOldSubscription(
      ProductDetails productDetails,
      Map<String, PurchaseDetails> purchases) async {
    InAppPurchaseAndroidPlatformAddition androidAddition = InAppPurchase
        .instance
        .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();

    QueryPurchaseDetailsResponse? response;
    response = await androidAddition.queryPastPurchases();
    GooglePlayPurchaseDetails? oldSubscription;
    List<SubPackage> subscriptions = AppInfoConstants.listSubPackages;

    if (response.pastPurchases.isNotEmpty) {
      for (var sub in subscriptions) {
        if (productDetails.id == sub.keyStoreAndroid &&
            response.pastPurchases.first.productID == sub.keyStoreAndroid) {
          oldSubscription =
              purchases[sub.keyStoreAndroid] as GooglePlayPurchaseDetails?;
          break;
        }
      }
    }

    return oldSubscription;
  }

  Future<void> listenToPurchaseUpdated(
      List<PurchaseDetails>? purchaseDetailsList) async {
    if (purchaseDetailsList?.isEmpty == true) {
      inAppPurchaseListener?.handleInvalidPurchase(PurchaseDetails(
          status: PurchaseStatus.error,
          verificationData: PurchaseVerificationData(
              source: '',
              serverVerificationData: '',
              localVerificationData: ''),
          transactionDate: '',
          productID: ''));
      inAppPurchaseListener?.setPackage();
    }
    List<PurchaseDetails>? list;
    list = purchaseDetailsList;
    if (list == null) {
      return;
    }
    for (int i = 0; i < list.length; i++) {
      // _purchases.add(purchaseDetails);
      PurchaseDetails purchaseDetails = list[i];

      ///Quá trình giao dịch đang được xử lý
      if (purchaseDetails.status == PurchaseStatus.pending) {
        inAppPurchaseListener?.pendingUI(true);
      } else {
        ///lỗi
        if (purchaseDetails.status == PurchaseStatus.error) {
          if (Platform.isIOS) {
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
          inAppPurchaseListener?.handleErrorPurchase(purchaseDetails.error);
          // inAppPurchaseListener?.pendingUI(false);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          ///Xác thực giao dịch
          var valid =
              await inAppPurchaseListener?.verifyPurchase(purchaseDetails);
          valid ??= false;
          if (valid) {
            _purchases.add(purchaseDetails);
            await inAppPurchaseListener?.deliverProduct(purchaseDetails);
          } else {
            inAppPurchaseListener?.handleInvalidPurchase(purchaseDetails);
            return;
          }
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          inAppPurchaseListener?.handleErrorPurchase(purchaseDetails.error);
          // inAppPurchaseListener?.pendingUI(false);
        }
        if (Platform.isAndroid) {
          final androidAddition = _inAppPurchase
              .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
          await androidAddition.consumePurchase(purchaseDetails);
        }

        ///hoàn tất mua
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }

        inAppPurchaseListener?.pendingUI(false);
      }
    }
  }

  Future<List<GooglePlayPurchaseDetails>?> history() async {
    final androidAddition = _inAppPurchase
        .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
    List<GooglePlayPurchaseDetails>? result;
    await androidAddition.queryPastPurchases().then((value) {
      result = value.pastPurchases;
    });
    return result;
  }

  void close() {
    if (Platform.isIOS) {
      var iosPlatformAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
  }

  Future<void> clearTransactionsIos() async {
    if (Platform.isIOS) {
      var transactions = await SKPaymentQueueWrapper().transactions();
      debugPrint('clearTransactionsIos: ${transactions.length}');
      for (int i = 0; i < transactions.length; i++) {
        try {
          await SKPaymentQueueWrapper().finishTransaction(transactions[i]);
        } catch (e) {
          debugPrint('error clearTransactionsIos: $e');
        }
        await Future.delayed(const Duration(milliseconds: 70));
      }
    }
  }

  List<String> get kProductIds => _kProductIds;

  set kProductIds(List<String> value) {
    _kProductIds.addAll(value);
  }

  set kProductIdsNull(List<String> value) {
    _kProductIds.clear();
  }

  String? get queryProductError => _queryProductError;

  set purchases(List<PurchaseDetails> purchaseDetails) {
    purchases.addAll(purchaseDetails);
  }

  List<PurchaseDetails> get purchases => _purchases;

  List<ProductDetails> get products => _products;

  set setProduct(List<PurchaseDetails> purchaseDetails) {
    _products.clear();
  }

  List<String> get notFoundIds => _notFoundIds;

  bool get isNavigator => _isNavigator;

  set setNavigators(bool value) {
    _isNavigator = value;
  }

  StreamSubscription<List<PurchaseDetails>> get subscription => _subscription;

  InAppPurchase get inAppPurchase => _inAppPurchase;
}

class PaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
