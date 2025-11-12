import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_sudoku/purchase/purchase_controller.dart';
import 'package:i_sudoku/themes/c_colors.dart';
import 'package:i_sudoku/themes/c_textstyle.dart';
import 'package:i_sudoku/widgets/c_text.dart';

class PurchaseScreen extends StatelessWidget {
  const PurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PurchaseController controller = Get.put(PurchaseController());

    return Scaffold(
      appBar: AppBar(
        title: CText(
          'Get More Hints',
          style: CTextStyles.base.s18.w600().setColor(CColors.inkA500),
        ),
        backgroundColor: CColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CColors.inkA500),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: CColors.white,
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.isAvailable.value) {
          return const Center(
            child: CText('In-app purchases are not available.'),
          );
        }

        if (controller.products.isEmpty) {
          return const Center(child: CText('No products found.'));
        }

        return ListView.builder(
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: Image.asset(
                  'assets/icons/light-bulb.png',
                  height: 40,
                  width: 40,
                ),
                title: CText(product.title, style: CTextStyles.base.s16.w600()),
                subtitle: CText(
                  product.description,
                  style: CTextStyles.base.s14.setColor(CColors.inkA400),
                ),
                trailing: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: CColors.greenA300,
                    foregroundColor: CColors.white,
                  ),
                  onPressed: () {
                    controller.buyProduct(product);
                  },
                  child: Obx(() {
                    if (controller.purchasePending.value) {
                      return const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      );
                    }
                    return CText(product.price);
                  }),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
