import 'package:royal/core/theme/colors.dart';
import 'package:royal/core/states/mode.dart';
import 'package:royal/features/recharge_card/controller/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RechargeCardDenominationWidget extends StatelessWidget {
  const RechargeCardDenominationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GsubzRechargeCardIndexController controller =
        Get.find<GsubzRechargeCardIndexController>();

    return Obx(() {
      if (controller.denominations.isEmpty) {
        return const Center(
          child: Text('No denominations available'),
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.0,
        ),
        itemCount: controller.denominations.length,
        itemBuilder: (context, index) {
          final denomination = controller.denominations[index];
          final value = denomination['value'].toString();
          final displayValue = denomination['display_value'].toString();
          final price = denomination['price'].toString();
          final discount = denomination['discount'].toString();
          // final isSelected = controller.selectedDenomination.value == value;

          return GestureDetector(
              onTap: () => controller.setDenomination(value, price),
              child: Obx(
                () => DenominationCard(
                  displayValue: displayValue,
                  price: price,
                  discount: discount,
                  isSelected: controller.selectedDenomination.value == value,
                ),
              ));
        },
      );
    });
  }
}

class DenominationCard extends StatelessWidget {
  final String displayValue;
  final String price;
  final String discount;
  final bool isSelected;

  const DenominationCard({
    super.key,
    required this.displayValue,
    required this.price,
    required this.discount,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final LightningModeController lightningModeController =
        Get.find<LightningModeController>();

    return Obx(() {
      final isLight = lightningModeController.currentMode.value.mode == "light";

      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    DarkThemeColors.primaryColor.withOpacity(0.15),
                    DarkThemeColors.primaryColor.withOpacity(0.08),
                  ],
                )
              : null,
          color: isSelected
              ? null
              : (isLight ? Colors.white : const Color(0xFF1F2937)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? DarkThemeColors.primaryColor
                : (isLight
                    ? const Color(0xFFE5E7EB)
                    : Colors.white.withOpacity(0.1)),
            width: isSelected ? 2.5 : 1.0,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: DarkThemeColors.primaryColor.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(isLight ? 0.06 : 0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Card value
            Text(
              displayValue,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? DarkThemeColors.primaryColor
                    : (isLight ? const Color(0xFF111827) : Colors.white),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            // Price
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       '₦$price',
            //       style: TextStyle(
            //         fontSize: 14,
            //         fontWeight: FontWeight.w600,
            //         color: isSelected
            //             ? DarkThemeColors.primaryColor
            //             : (isLight
            //                 ? const Color(0xFF374151)
            //                 : Colors.white.withOpacity(0.8)),
            //       ),
            //     ),
            //     const SizedBox(width: 6),
            //     Container(
            //       padding:
            //           const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            //       decoration: BoxDecoration(
            //         color: Colors.green.withOpacity(0.15),
            //         borderRadius: BorderRadius.circular(6),
            //       ),
            //       child: Text(
            //         '-$discount%',
            //         style: TextStyle(
            //           fontSize: 10,
            //           fontWeight: FontWeight.w600,
            //           color: Colors.green.shade700,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            if (isSelected) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: DarkThemeColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}
