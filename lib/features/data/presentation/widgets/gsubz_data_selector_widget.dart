// import 'package:royal/core/theme/colors.dart';
// import 'package:royal/core/states/mode.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:royal/core/constants/images.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:royal/features/data/controllers/gsubz_data_index_controller.dart';

// class GsubzServiceSelectorWidget extends StatelessWidget {
//   const GsubzServiceSelectorWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final GsubzDataIndexController controller =
//         Get.find<GsubzDataIndexController>();

//     return Obx(() => Column(
//           children: [
//             // Service type selector
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: controller.serviceMapping.asMap().entries.map((entry) {
//                   int index = entry.key;
//                   var service = entry.value;
//                   return Padding(
//                     padding: EdgeInsets.only(
//                       right: index < controller.serviceMapping.length - 1 ? 12 : 0,
//                     ),
//                     child: GestureDetector(
//                       onTap: () => controller.setService(index),
//                       child: ServiceCard(
//                         serviceName: service['name']!,
//                         network: service['network']!,
//                         colorHex: service['color']!,
//                         isSelected: controller.selectedService.value == index,
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ],
//         ));
//   }
// }

// class ServiceCard extends StatelessWidget {
//   final String serviceName;
//   final String network;
//   final String colorHex;
//   final bool isSelected;

//   const ServiceCard({
//     super.key,
//     required this.serviceName,
//     required this.network,
//     required this.colorHex,
//     required this.isSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final LightningModeController lightningModeController =
//         Get.find<LightningModeController>();

//     return Obx(() {
//       final isLight =
//           lightningModeController.currentMode.value.mode == "light";

//       // Parse color from hex string
//       final color = Color(int.parse(colorHex.replaceFirst('0x', '0xff')));

//       return AnimatedContainer(
//         duration: const Duration(milliseconds: 250),
//         curve: Curves.easeInOut,
//         width: 140,
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//         decoration: BoxDecoration(
//           gradient: isSelected
//               ? LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     DarkThemeColors.primaryColor.withOpacity(0.15),
//                     DarkThemeColors.primaryColor.withOpacity(0.08),
//                   ],
//                 )
//               : null,
//           color: isSelected
//               ? null
//               : (isLight ? Colors.white : const Color(0xFF1F2937)),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isSelected
//                 ? DarkThemeColors.primaryColor
//                 : (isLight
//                     ? const Color(0xFFE5E7EB)
//                     : Colors.white.withOpacity(0.1)),
//             width: isSelected ? 2.5 : 1.0,
//           ),
//           boxShadow: [
//             if (isSelected)
//               BoxShadow(
//                 color: DarkThemeColors.primaryColor.withOpacity(0.25),
//                 blurRadius: 12,
//                 offset: const Offset(0, 4),
//               )
//             else
//               BoxShadow(
//                 color: Colors.black.withOpacity(isLight ? 0.06 : 0.15),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Network icon
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.15),
//                 shape: BoxShape.circle,
//               ),
//               child: _getNetworkIcon(network),
//             ),
//             const SizedBox(height: 10),
//             // Service name
//             Text(
//               serviceName,
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w700,
//                 color: isSelected
//                     ? DarkThemeColors.primaryColor
//                     : (isLight
//                         ? const Color(0xFF111827)
//                         : Colors.white),
//                 height: 1.2,
//               ),
//               textAlign: TextAlign.center,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//             if (isSelected) ...[
//               const SizedBox(height: 6),
//               Container(
//                 padding: const EdgeInsets.all(3),
//                 decoration: BoxDecoration(
//                   color: DarkThemeColors.primaryColor,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.check_rounded,
//                   color: Colors.white,
//                   size: 12,
//                 ),
//               ),
//             ],
//           ],
//         ),
//       );
//     });
//   }

//   Widget _getNetworkIcon(String network) {
//     switch (network) {
//       case 'MTN':
//         return SvgPicture.asset(
//           SvgConstant.mtnIcon,
//           width: 24,
//           height: 24,
//         );
//       case 'GLO':
//         return SvgPicture.asset(
//           SvgConstant.gloIcon,
//           width: 24,
//           height: 24,
//         );
//       case 'AIRTEL':
//         return SvgPicture.asset(
//           SvgConstant.airtelIcon,
//           width: 24,
//           height: 24,
//         );
//       case '9MOBILE':
//         return SvgPicture.asset(
//           SvgConstant.etisalatIcon,
//           width: 24,
//           height: 24,
//         );
//       default:
//         return Icon(
//           Icons.network_cell_rounded,
//           size: 24,
//           color: DarkThemeColors.primaryColor,
//         );
//     }
//   }
// }


import 'package:royal/core/theme/colors.dart';
import 'package:royal/core/states/mode.dart';
import 'package:royal/features/data/controllers/gsubz_data_index_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:royal/core/constants/images.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GsubzServiceSelectorWidget extends StatelessWidget {
  const GsubzServiceSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GsubzDataIndexController controller =
        Get.find<GsubzDataIndexController>();

    return Column(
      children: [
        
        // Service list
        Obx(() => controller.isServiceLayoutHorizontal.value
            ? _buildHorizontalLayout(controller)
            : _buildVerticalLayout(controller)),
      ],
    );
  }

  Widget _buildHorizontalLayout(GsubzDataIndexController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: controller.serviceMapping.asMap().entries.map((entry) {
          int index = entry.key;
          var service = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              right: index < controller.serviceMapping.length - 1 ? 12 : 0,
            ),
            child: GestureDetector(
              onTap: () => controller.setService(index),
              child: Obx(() => ServiceCard(
                    serviceName: service['name']!,
                    network: service['network']!,
                    colorHex: service['color']!,
                    isSelected: controller.selectedService.value == index,
                    isHorizontal: true,
                  )),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVerticalLayout(GsubzDataIndexController controller) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: controller.serviceMapping.length,
      itemBuilder: (context, index) {
        var service = controller.serviceMapping[index];
        return GestureDetector(
          onTap: () => controller.setService(index),
          child: Obx(() => ServiceCard(
                serviceName: service['name']!,
                network: service['network']!,
                colorHex: service['color']!,
                isSelected: controller.selectedService.value == index,
                isHorizontal: false,
              )),
        );
      },
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String serviceName;
  final String network;
  final String colorHex;
  final bool isSelected;
  final bool isHorizontal;

  const ServiceCard({
    super.key,
    required this.serviceName,
    required this.network,
    required this.colorHex,
    required this.isSelected,
    this.isHorizontal = true,
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
        width: isHorizontal ? 140 : null,
        padding: EdgeInsets.symmetric(
          horizontal: isHorizontal ? 12 : 10,
          vertical: isHorizontal ? 16 : 12,
        ),
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
        child: isHorizontal
            ? _buildVerticalContent(color, isLight)
            : _buildHorizontalContent(color, isLight),
      );
    });
  }

  // Vertical content for horizontal scroll (icon on top, text below)
  Widget _buildVerticalContent(Color color, bool isLight) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Network icon
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: _getNetworkIcon(network),
        ),
        const SizedBox(height: 10),
        // Service name
        Text(
          serviceName,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected
                ? DarkThemeColors.primaryColor
                : (isLight ? const Color(0xFF111827) : Colors.white),
            height: 1.2,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
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
    );
  }

  // Horizontal content for grid view (icon left, text right)
  Widget _buildHorizontalContent(Color color, bool isLight) {
    return Row(
      children: [
        // Network icon
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: _getNetworkIcon(network, size: 20),
        ),
        const SizedBox(width: 10),
        // Service name
        Expanded(
          child: Text(
            serviceName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isSelected
                  ? DarkThemeColors.primaryColor
                  : (isLight ? const Color(0xFF111827) : Colors.white),
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isSelected)
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
    );
  }

  Widget _getNetworkIcon(String network, {double size = 24}) {
    switch (network) {
      case 'MTN':
        return SvgPicture.asset(
          SvgConstant.mtnIcon,
          width: size,
          height: size,
        );
      case 'GLO':
        return SvgPicture.asset(
          SvgConstant.gloIcon,
          width: size,
          height: size,
        );
      case 'AIRTEL':
        return SvgPicture.asset(
          SvgConstant.airtelIcon,
          width: size,
          height: size,
        );
      case '9MOBILE':
        return SvgPicture.asset(
          SvgConstant.etisalatIcon,
          width: size,
          height: size,
        );
      default:
        return Icon(
          Icons.network_cell_rounded,
          size: size,
          color: DarkThemeColors.primaryColor,
        );
    }
  }
}