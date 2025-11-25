// import 'package:royal/core/constants/routes.dart';
// import 'package:royal/core/theme/colors.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:royal/core/states/mode.dart';

// class BottomNavigationWidget extends StatelessWidget {
//   final int currentIndex;
//   const BottomNavigationWidget({super.key, required this.currentIndex});

//   @override
//   Widget build(BuildContext context) {
//     final LightningModeController lightningModeController =
//         Get.find<LightningModeController>();

//     return Obx(() => Container(
//         height: 103,
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         decoration: ShapeDecoration(
//           color: lightningModeController.currentMode.value.mode == "light"
//               ? Colors.white
//               : Colors.black,
//           shape: RoundedRectangleBorder(
//             side: BorderSide(width: 1, color: Colors.black.withOpacity(0.25)),
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Get.toNamed(RoutesConstant.home);
//                   },
//                   child: Column(
//                     children: [
//                       SizedBox(
//                           width: 24,
//                           height: 24,
//                           child: Icon(CupertinoIcons.home,
//                               color: currentIndex == 0
//                                   ? DarkThemeColors.primaryColor
//                                   : null)),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Home',
//                         style: Theme.of(context)
//                             .textTheme
//                             .displayMedium
//                             ?.copyWith(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w500,
//                                 color: currentIndex == 0
//                                     ? DarkThemeColors.primaryColor
//                                     : null),
//                       )
//                     ],
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {},
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         width: 24,
//                         height: 24,
//                         child: Icon(Icons.wallet_giftcard,
//                             color: currentIndex == 1
//                                 ? DarkThemeColors.primaryColor
//                                 : null),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Gift Card',
//                         style: Theme.of(context)
//                             .textTheme
//                             .displayMedium
//                             ?.copyWith(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w500,
//                                 color: currentIndex == 1
//                                     ? DarkThemeColors.primaryColor
//                                     : null),
//                       )
//                     ],
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {},
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         width: 24,
//                         height: 24,
//                         child: Icon(CupertinoIcons.bitcoin,
//                             color: currentIndex == 2
//                                 ? DarkThemeColors.primaryColor
//                                 : null),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Crypto',
//                         style: Theme.of(context)
//                             .textTheme
//                             .displayMedium
//                             ?.copyWith(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w500,
//                                 color: currentIndex == 2
//                                     ? DarkThemeColors.primaryColor
//                                     : null),
//                       )
//                     ],
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {},
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         width: 24,
//                         height: 24,
//                         child: Icon(Icons.wallet,
//                             color: currentIndex == 3
//                                 ? DarkThemeColors.primaryColor
//                                 : null),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Wallet',
//                         style: Theme.of(context)
//                             .textTheme
//                             .displayMedium
//                             ?.copyWith(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w500,
//                                 color: currentIndex == 3
//                                     ? DarkThemeColors.primaryColor
//                                     : null),
//                       )
//                     ],
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Get.toNamed(RoutesConstant.profile);
//                   },
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         width: 24,
//                         height: 24,
//                         child: Icon(CupertinoIcons.profile_circled,
//                             color: currentIndex == 4
//                                 ? DarkThemeColors.primaryColor
//                                 : null),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Profile',
//                         style: Theme.of(context)
//                             .textTheme
//                             .displayMedium
//                             ?.copyWith(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w500,
//                                 color: currentIndex == 4
//                                     ? DarkThemeColors.primaryColor
//                                     : null),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         )));
//   }
// }
import 'package:royal/core/constants/routes.dart';
import 'package:royal/core/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:royal/core/states/mode.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  const BottomNavigationWidget({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final LightningModeController lightningModeController =
        Get.find<LightningModeController>();

    return Obx(() => Container(
        height: 103,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: ShapeDecoration(
          color: lightningModeController.currentMode.value.mode == "light"
              ? Colors.white
              : Colors.black,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Colors.black.withOpacity(0.25)),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(RoutesConstant.home);
                  },
                  child: Column(
                    children: [
                      SizedBox(
                          width: 24,
                          height: 24,
                          child: Icon(
                              currentIndex == 0
                                  ? Icons.home_rounded
                                  : Icons.home_outlined,
                              color: currentIndex == 0
                                  ? DarkThemeColors.primaryColor
                                  : null)),
                      const SizedBox(height: 4),
                      Text(
                        'Home',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: currentIndex == 0
                                    ? DarkThemeColors.primaryColor
                                    : null),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Icon(
                            currentIndex == 1
                                ? Icons.card_giftcard_rounded
                                : Icons.card_giftcard_outlined,
                            color: currentIndex == 1
                                ? DarkThemeColors.primaryColor
                                : null),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Gift Card',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: currentIndex == 1
                                    ? DarkThemeColors.primaryColor
                                    : null),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Icon(
                            currentIndex == 2
                                ? Icons.currency_bitcoin_rounded
                                : Icons.currency_bitcoin,
                            color: currentIndex == 2
                                ? DarkThemeColors.primaryColor
                                : null),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Crypto',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: currentIndex == 2
                                    ? DarkThemeColors.primaryColor
                                    : null),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Icon(
                            currentIndex == 3
                                ? Icons.account_balance_wallet_rounded
                                : Icons.account_balance_wallet_outlined,
                            color: currentIndex == 3
                                ? DarkThemeColors.primaryColor
                                : null),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Wallet',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: currentIndex == 3
                                    ? DarkThemeColors.primaryColor
                                    : null),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(RoutesConstant.profile);
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Icon(
                            currentIndex == 4
                                ? Icons.person_rounded
                                : Icons.person_outline_rounded,
                            color: currentIndex == 4
                                ? DarkThemeColors.primaryColor
                                : null),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Profile',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: currentIndex == 4
                                    ? DarkThemeColors.primaryColor
                                    : null),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        )));
  }
}