import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../constants/app_constants.dart';
import 'storage_service.dart';

class SubscriptionService {
  static final InAppPurchase _iap = InAppPurchase.instance;
  static StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// Initialize the subscription service
  static Future<void> init() async {
    final available = await _iap.isAvailable();
    if (!available) {
      // In-app purchases not available
      return;
    }

    // Listen to purchase updates
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (error) {
        // Purchase stream error
      },
    );

    // Check for pending purchases
    await _restorePurchases();
  }

  /// Handle purchase updates
  static Future<void> _onPurchaseUpdate(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // Grant premium access
        await StorageService.setPremium(true);
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetails);
      }
    }
  }

  /// Purchase premium subscription
  static Future<bool> purchaseSubscription() async {
    final available = await _iap.isAvailable();
    if (!available) return false;

    try {
      final ProductDetailsResponse response = await _iap.queryProductDetails(
        {AppConstants.subscriptionProductId},
      );

      if (response.productDetails.isEmpty) {
        // No products found
        return false;
      }

      final ProductDetails productDetails = response.productDetails.first;
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: productDetails);

      return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      // Purchase error
      return false;
    }
  }

  /// Restore previous purchases
  static Future<void> _restorePurchases() async {
    try {
      await _iap.restorePurchases();
    } catch (e) {
      // Restore purchases error
    }
  }

  /// Manually trigger restore purchases
  static Future<void> restorePurchases() async {
    await _restorePurchases();
  }

  /// Check subscription status
  static Future<bool> isSubscribed() async {
    return await StorageService.isPremium();
  }

  /// Dispose of subscription listener
  static void dispose() {
    _subscription?.cancel();
  }
}

