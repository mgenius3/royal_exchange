import 'package:royal/core/constants/symbols.dart';
import 'package:royal/core/theme/colors.dart';
import 'package:royal/core/states/mode.dart';
import 'package:royal/features/data/controllers/gsubz_data_index_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GsubzPlanWidget extends StatelessWidget {
  const GsubzPlanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GsubzDataIndexController controller =
        Get.find<GsubzDataIndexController>();

    return Obx(() {
      // Plans are already filtered by service in the controller
      final plans = controller.dataPlans;

      if (plans.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.signal_wifi_off_rounded,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 12),
              Text(
                'No plans available',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.5,
        ),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return Obx(() => GsubzPlanCard(
                plan: plan['displayName'],
                price: plan['price'].toString(),
                planValue: plan['value'].toString(),
                isSelected: controller.selectedPlanValue.value == plan['value'].toString(),
                onTap: () {
                  controller.setPlan(
                    plan['value'].toString(),
                    plan['displayName'],
                    plan['price'].toString(),
                  );
                },
              ));
        },
      );
    });
  }
}

class GsubzPlanCard extends StatelessWidget {
  final String plan;
  final String price;
  final String planValue;
  final bool isSelected;
  final Function() onTap;

  const GsubzPlanCard({
    super.key,
    required this.plan,
    required this.price,
    required this.planValue,
    required this.isSelected,
    required this.onTap,
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
          borderRadius: BorderRadius.circular(18),
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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            splashColor: DarkThemeColors.primaryColor.withOpacity(0.1),
            highlightColor: DarkThemeColors.primaryColor.withOpacity(0.05),
            child: Stack(
              children: [
                if (isSelected)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: DarkThemeColors.primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                                DarkThemeColors.primaryColor.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        plan,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? DarkThemeColors.primaryColor
                              : (isLight
                                  ? const Color(0xFF111827)
                                  : Colors.white),
                          letterSpacing: -0.2,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? DarkThemeColors.primaryColor.withOpacity(0.15)
                              : (isLight
                                  ? const Color(0xFFF3F4F6)
                                  : Colors.white.withOpacity(0.05)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: Symbols.currency_naira,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: DarkThemeColors.primaryColor,
                              height: 1,
                            ),
                            children: [
                              TextSpan(
                                text: price,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: isLight
                                      ? const Color(0xFF111827)
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}