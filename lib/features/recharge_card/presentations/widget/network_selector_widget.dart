import 'package:royal/core/theme/colors.dart';
import 'package:royal/core/states/mode.dart';
import 'package:royal/features/recharge_card/controller/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:royal/core/constants/images.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RechargeCardNetworkWidget extends StatelessWidget {
  const RechargeCardNetworkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GsubzRechargeCardIndexController controller =
        Get.find<GsubzRechargeCardIndexController>();

    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: controller.networkMapping.asMap().entries.map((entry) {
              int index = entry.key;
              var network = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  right: index < controller.networkMapping.length - 1 ? 12 : 0,
                ),
                child: GestureDetector(
                  onTap: () => controller.setNetwork(index),
                  child: NetworkCard(
                    networkName: network['name']!,
                    colorHex: network['color']!,
                    isSelected: controller.selectedNetwork.value == index,
                  ),
                ),
              );
            }).toList(),
          ),
        ));
  }
}

class NetworkCard extends StatelessWidget {
  final String networkName;
  final String colorHex;
  final bool isSelected;

  const NetworkCard({
    super.key,
    required this.networkName,
    required this.colorHex,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final LightningModeController lightningModeController =
        Get.find<LightningModeController>();

    return Obx(() {
      final isLight =
          lightningModeController.currentMode.value.mode == "light";

      // Parse color from hex string
      final color = Color(int.parse(colorHex.replaceFirst('0x', '0xff')));

      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 100,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            // Network icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: _getNetworkIcon(networkName),
            ),
            const SizedBox(height: 10),
            // Network name
            Text(
              networkName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? DarkThemeColors.primaryColor
                    : (isLight ? const Color(0xFF111827) : Colors.white),
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
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

  Widget _getNetworkIcon(String network) {
    switch (network) {
      case 'MTN':
        return SvgPicture.asset(
          SvgConstant.mtnIcon,
          width: 24,
          height: 24,
        );
      case 'GLO':
        return SvgPicture.asset(
          SvgConstant.gloIcon,
          width: 24,
          height: 24,
        );
      case 'Airtel':
        return SvgPicture.asset(
          SvgConstant.airtelIcon,
          width: 24,
          height: 24,
        );
      case '9Mobile':
        return SvgPicture.asset(
          SvgConstant.etisalatIcon,
          width: 24,
          height: 24,
        );
      default:
        return Icon(
          Icons.network_cell_rounded,
          size: 24,
          color: DarkThemeColors.primaryColor,
        );
    }
  }
}