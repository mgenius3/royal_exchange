import 'package:royal/core/constants/routes.dart';
import 'package:royal/core/theme/colors.dart';
import 'package:royal/core/utils/spacing.dart';
import 'package:royal/core/models/top_header_model.dart';
import 'package:royal/core/widgets/top_header_widget.dart';
import 'package:royal/features/giftcards/controllers/index_controller.dart'; // Assuming this is GiftCardController
import 'package:royal/features/giftcards/presentation/widgets/giftcards_transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class GiftCardScreen extends StatelessWidget {
  const GiftCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GiftCardController controller = Get.put(GiftCardController());

    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Container(
            margin: Spacing.defaultMarginSpacing,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'GiftCard\'s Transactions',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: Get.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
                  decoration: ShapeDecoration(
                    color:  LightThemeColors.primaryColor.withOpacity(.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.updateBuyOrSell('buy');
                        },
                        child: Container(
                          width: Get.width * .4,
                          height: 40,
                          padding: const EdgeInsets.all(10),
                          decoration: ShapeDecoration(
                            color: controller.buy_or_sell.value == 'buy'
                                ? LightThemeColors.primaryColor
                                : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Buy',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    height: 0.71),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          controller.updateBuyOrSell('sell');
                        },
                        child: Container(
                          width: Get.width < 400
                              ? Get.width * .35
                              : Get.width * .4,
                          height: 40,
                          padding: const EdgeInsets.all(10),
                          decoration: ShapeDecoration(
                            color: controller.buy_or_sell.value == 'sell'
                                ?  LightThemeColors.primaryColor
                                : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Sell',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    height: 1.10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                    child: RefreshIndicator(
                  onRefresh: controller.fetchAllGiftCardsTransaction,
                  child: controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : controller.errorMessage.isNotEmpty
                          ? Center(
                              child: Text(
                                  'Error: ${controller.errorMessage.value}'))
                          : controller.filteredTransactions.isEmpty
                              ? Center(
                                  child: Column(
                                  children: [
                                    SvgPicture.asset(
                                        "assets/svg/empty_transaction.svg"),
                                    const SizedBox(height: 20),
                                    const Text('No transactions available')
                                  ],
                                ))
                              : ListView.builder(
                                  itemCount:
                                      controller.filteredTransactions.length,
                                  itemBuilder: (context, index) {
                                    final transaction =
                                        controller.filteredTransactions[index];
                                    return GestureDetector(
                                      onTap: () {
                                        // Navigate to details screen with the selected transaction
                                        Get.toNamed(
                                            RoutesConstant
                                                .giftCardTransactionDetails,
                                            arguments: transaction);
                                      },
                                      child: GiftcardsTransactionListWidget(
                                          data: transaction),
                                    );
                                  },
                                ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
