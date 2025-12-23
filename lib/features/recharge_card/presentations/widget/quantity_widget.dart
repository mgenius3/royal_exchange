import 'package:royal/core/theme/colors.dart';
import 'package:royal/core/states/mode.dart';
import 'package:royal/features/recharge_card/controller/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RechargeCardQuantityWidget extends StatelessWidget {
  const RechargeCardQuantityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GsubzRechargeCardIndexController controller =
        Get.find<GsubzRechargeCardIndexController>();
    final LightningModeController lightningModeController =
        Get.find<LightningModeController>();

    return Obx(() {
      final isLight =
          lightningModeController.currentMode.value.mode == "light";

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isLight ? Colors.white : const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isLight
                ? const Color(0xFFE5E7EB)
                : Colors.white.withOpacity(0.1),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isLight ? 0.06 : 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Quantity label and value
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Number of Cards',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isLight
                        ? const Color(0xFF374151)
                        : Colors.white.withOpacity(0.8),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: DarkThemeColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Obx(() => Text(
                        '${controller.quantity.value}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: DarkThemeColors.primaryColor,
                        ),
                      )),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Quantity controls
            Row(
              children: [
                // Decrement button
                Expanded(
                  child: GestureDetector(
                    onTap: controller.decrementQuantity,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: controller.quantity.value > 1
                            ? DarkThemeColors.primaryColor.withOpacity(0.1)
                            : (isLight
                                ? Colors.grey.shade200
                                : Colors.grey.shade800),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller.quantity.value > 1
                              ? DarkThemeColors.primaryColor.withOpacity(0.3)
                              : Colors.grey.shade400,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.remove,
                        color: controller.quantity.value > 1
                            ? DarkThemeColors.primaryColor
                            : Colors.grey.shade500,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Quantity input
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: isLight
                          ? Colors.grey.shade50
                          : const Color(0xFF374151),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: DarkThemeColors.primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isLight ? Colors.black : Colors.white,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '${controller.quantity.value}',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          int? qty = int.tryParse(value);
                          if (qty != null) {
                            controller.setQuantity(qty);
                          }
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Increment button
                Expanded(
                  child: GestureDetector(
                    onTap: controller.incrementQuantity,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: controller.quantity.value < 50
                            ? DarkThemeColors.primaryColor.withOpacity(0.1)
                            : (isLight
                                ? Colors.grey.shade200
                                : Colors.grey.shade800),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller.quantity.value < 50
                              ? DarkThemeColors.primaryColor.withOpacity(0.3)
                              : Colors.grey.shade400,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        color: controller.quantity.value < 50
                            ? DarkThemeColors.primaryColor
                            : Colors.grey.shade500,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Quantity limit text
            Text(
              'Min: 1 | Max: 50 cards',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    });
  }
}