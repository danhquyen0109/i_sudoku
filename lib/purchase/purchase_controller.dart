import 'dart:async';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:i_sudoku/sudoku_controller.dart';

const String _hintPackage3 = 'com.galaxy.isudoku.hints3';
const String _hintPackage5 = 'com.galaxy.isudoku.hints5';
const String _hintPackage10 = 'com.galaxy.isudoku.hints10';
const String _hintPackage15 = 'com.galaxy.isudoku.hints15';
const String _hintPackage20 = 'com.galaxy.isudoku.hints20';
const String _hintPackage25 = 'com.galaxy.isudoku.hints25';
const List<String> _kProductIds = <String>[
  _hintPackage3,
  _hintPackage5,
  _hintPackage10,
  _hintPackage15,
  _hintPackage20,
  _hintPackage25,
];

class PurchaseController extends GetxController {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final products = <ProductDetails>[].obs;
  final notFoundIds = <String>[].obs;
  final isAvailable = false.obs;
  final purchasePending = false.obs;
  final loading = true.obs;

  final SudokuController _sudokuController = Get.find();

  @override
  void onInit() {
    super.onInit();
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        // Xử lý lỗi tại đây
        print(error);
      },
    );
    initStoreInfo();
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }

  Future<void> initStoreInfo() async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      isAvailable.value = false;
      products.value = [];
      notFoundIds.value = [];
      purchasePending.value = false;
      loading.value = false;
      return;
    }

    isAvailable.value = true;

    final ProductDetailsResponse productDetailResponse = await _inAppPurchase
        .queryProductDetails(_kProductIds.toSet());

    if (productDetailResponse.error != null) {
      // Xử lý lỗi
      loading.value = false;
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      // Không tìm thấy sản phẩm
      loading.value = false;
      return;
    }

    products.value = productDetailResponse.productDetails;
    notFoundIds.value = productDetailResponse.notFoundIDs;
    loading.value = false;
  }

  void buyProduct(ProductDetails productDetails) {
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
    );
    _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        purchasePending.value = true;
      } else {
        purchasePending.value = false;
        if (purchaseDetails.status == PurchaseStatus.error) {
          // Xử lý lỗi mua hàng
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          _deliverPurchase(purchaseDetails);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> _deliverPurchase(PurchaseDetails purchaseDetails) async {
    // Cộng gợi ý cho người dùng dựa trên ID sản phẩm
    if (purchaseDetails.productID == _hintPackage3) {
      await _sudokuController.addHints(3);
    } else if (purchaseDetails.productID == _hintPackage5) {
      await _sudokuController.addHints(5);
    } else if (purchaseDetails.productID == _hintPackage10) {
      await _sudokuController.addHints(10);
    } else if (purchaseDetails.productID == _hintPackage15) {
      await _sudokuController.addHints(15);
    } else if (purchaseDetails.productID == _hintPackage20) {
      await _sudokuController.addHints(20);
    } else if (purchaseDetails.productID == _hintPackage25) {
      await _sudokuController.addHints(25);
    }

    Get.snackbar(
      'Purchase Successful',
      'Hints added to your account.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
