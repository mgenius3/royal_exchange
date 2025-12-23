import 'package:royal/core/constants/routes.dart';
import 'package:royal/core/theme/colors.dart';
import 'package:royal/core/utils/spacing.dart';
import 'package:royal/features/recharge_card/controller/index.dart';
import 'package:royal/core/controllers/primary_button_controller.dart';
import 'package:royal/core/models/primary_button_model.dart';
import 'package:royal/core/models/top_header_model.dart';
import 'package:royal/core/widgets/primary_button_widget.dart';
import 'package:royal/core/widgets/top_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:royal/features/recharge_card/presentations/widget/domination_widget.dart';
import 'package:royal/features/recharge_card/presentations/widget/network_selector_widget.dart';
import 'package:royal/features/recharge_card/presentations/widget/quantity_widget.dart';

class GsubzRechargeCardScreen extends StatefulWidget {
  const GsubzRechargeCardScreen({super.key});

  @override
  State<GsubzRechargeCardScreen> createState() =>
      _GsubzRechargeCardScreenState();
}

class _GsubzRechargeCardScreenState extends State<GsubzRechargeCardScreen> {
  final GsubzRechargeCardIndexController controller =
      Get.put(GsubzRechargeCardIndexController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: Spacing.defaultMarginSpacing,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TopHeaderWidget(
                          data: TopHeaderModel(title: "Recharge Card")),
                      const SizedBox(height: 37.82),
                      Text(
                        'Select Network',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 1.83),
                      ),
                      const SizedBox(height: 10),
                      const RechargeCardNetworkWidget(),
                      const SizedBox(height: 20),
                      Obx(() => controller.isLoading.value
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select Denomination',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          height: 1.83),
                                ),
                                const SizedBox(height: 10),
                                const RechargeCardDenominationWidget(),
                                const SizedBox(height: 20),
                                Text(
                                  'Select Quantity',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          height: 1.83),
                                ),
                                const SizedBox(height: 10),
                                const RechargeCardQuantityWidget(),
                                const SizedBox(height: 20),
                                // Total Amount Display
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: DarkThemeColors.primaryColor
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: DarkThemeColors.primaryColor
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total Amount',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      Obx(() => Text(
                                            '₦${controller.totalAmount.value}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium
                                                ?.copyWith(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  color: DarkThemeColors
                                                      .primaryColor,
                                                ),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            // Fixed bottom button
            Container(
              padding: EdgeInsets.fromLTRB(
                Spacing.defaultMarginSpacing.left,
                16,
                Spacing.defaultMarginSpacing.right,
                Spacing.defaultMarginSpacing.bottom,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Obx(() => CustomPrimaryButton(
                    controller: CustomPrimaryButtonController(
                        model: CustomPrimaryButtonModel(
                            text: 'Generate Cards',
                            color: controller.isInformationComplete.value
                                ? DarkThemeColors.primaryColor
                                : DarkThemeColors.disabledButtonColor),
                        onPressed: () {
                          if (controller.validateInputs()) {
                            Get.toNamed(
                                RoutesConstant.gsubz_recharge_card_details,
                                arguments: {
                                  'network': controller.selectedNetwork.value,
                                  'denomination':
                                      controller.selectedDenomination.value,
                                  'quantity': controller.quantity.value,
                                  'totalAmount': controller.totalAmount.value,
                                });
                          }
                        }),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
