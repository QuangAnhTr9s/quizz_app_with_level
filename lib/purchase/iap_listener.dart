import 'package:in_app_purchase/in_app_purchase.dart';

abstract class InAppPurchaseListener {
  void purchaseUpdate(List<PurchaseDetails>? purchaseDetailsList);

  void onDoneListener();

  void onErrorListener(error);

  void pendingUI(bool pending);

  void handleErrorPurchase(IAPError? error);

  Future<bool> verifyPurchase(PurchaseDetails? purchaseDetails);

  Future<void> deliverProduct(PurchaseDetails? purchaseDetails);

  void handleInvalidPurchase(PurchaseDetails? purchaseDetails);

  void setPackage();
}

enum StoreStatus { unavailable, error, empty, ok }
