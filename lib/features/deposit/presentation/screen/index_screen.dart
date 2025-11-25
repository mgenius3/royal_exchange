// import 'package:royal/core/theme/colors.dart';
// import 'package:royal/features/deposit/controllers/index_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:get/get.dart';

// class DepositScreen extends StatelessWidget {
//   const DepositScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final DepositController controller = Get.put(DepositController());

//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 200,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                       colors: [LightThemeColors.primaryColor, LightThemeColors.primaryColor.withOpacity(.7)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight),
//                 ),
//                 child: const Center(
//                   child: Text(
//                     'Deposit Funds',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ),
//             pinned: true,
//             backgroundColor: LightThemeColors.primaryColor,
//           ),
//           SliverToBoxAdapter(
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Enter Amount',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ).animate().fadeIn(duration: 500.ms),
//                   const SizedBox(height: 12),
//                   TextField(
//                     controller: controller.amountController,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       hintText: 'e.g., 1000',
//                       prefixText: '₦ ',
//                       filled: true,
//                       fillColor: Colors.grey[100],
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 18,
//                       ),
//                     ),
//                   ).animate().slideY(begin: 0.2, duration: 600.ms),
//                   const SizedBox(height: 24),
//                   const Text(
//                     // Select
//                     'Payment Method',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ).animate().fadeIn(duration: 700.ms),
//                   const SizedBox(height: 12),
//                   Obx(() => Row(
//                         children: [
//                           Expanded(
//                             child: PaymentMethodCard(
//                               logo: 'assets/images/paystack.png',
//                               label: 'Paystack',
//                               isSelected: controller.selectedGateway.value ==
//                                   'paystack',
//                               onTap: () => controller.selectGateway('paystack'),
//                             ),
//                           ),
//                           // const SizedBox(width: 12),
//                           // Expanded(
//                           //   child: PaymentMethodCard(
//                           //     logo: 'assets/images/flutterwave.png',
//                           //     label: 'Flutterwave',
//                           //     isSelected: controller.selectedGateway.value ==
//                           //         'flutterwave',
//                           //     onTap: () =>
//                           //         controller.selectGateway('flutterwave'),
//                           //   ),
//                           // ),
//                         ],
//                       )).animate().slideY(begin: 0.2, duration: 800.ms),
//                   const SizedBox(height: 32),
//                   Obx(() => SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: controller.isLoading.value
//                               ? null
//                               : controller.initializePayment,
//                           style: ElevatedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(vertical: 18),
//                             backgroundColor: LightThemeColors.primaryColor,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             elevation: 5,
//                           ),
//                           child: controller.isLoading.value
//                               ? const SpinKitFadingCircle(
//                                   color: Colors.white, size: 24)
//                               : const Text(
//                                   'Proceed to Payment',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                         ),
//                       )).animate().fadeIn(duration: 900.ms),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Custom widget for payment method cards
// class PaymentMethodCard extends StatelessWidget {
//   final String logo;
//   final String label;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const PaymentMethodCard({
//     super.key,
//     required this.logo,
//     required this.label,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(
//             color:
//                 isSelected ? LightThemeColors.primaryColor : Colors.grey[200]!,
//             width: isSelected ? 2 : 1,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               logo,
//               height: 40,
//               fit: BoxFit.contain,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               label,
//               style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                   color: isSelected
//                       ? LightThemeColors.primaryColor
//                       : Colors.black87),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:royal/core/theme/colors.dart';
import 'package:royal/features/deposit/controllers/index_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class DepositScreen extends StatelessWidget {
  const DepositScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DepositController controller = Get.put(DepositController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: LightThemeColors.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      LightThemeColors.primaryColor,
                      LightThemeColors.primaryColor.withOpacity(.85)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 40,
                      right: -20,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      left: -30,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Deposit Funds',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: LightThemeColors.primaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Enter Amount',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 500.ms),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[200]!, width: 1.5),
                    ),
                    child: TextField(
                      controller: controller.amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        hintText: '0.00',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 12),
                          child: Text(
                            '₦',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: LightThemeColors.primaryColor,
                            ),
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 22,
                        ),
                      ),
                    ),
                  ).animate().slideY(begin: 0.2, duration: 600.ms),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: LightThemeColors.primaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Payment Method',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 700.ms),
                  const SizedBox(height: 16),
                  Obx(() => Row(
                        children: [
                          Expanded(
                            child: PaymentMethodCard(
                              logo: 'assets/images/paystack.png',
                              label: 'Paystack',
                              isSelected: controller.selectedGateway.value ==
                                  'paystack',
                              onTap: () => controller.selectGateway('paystack'),
                            ),
                          ),
                          // const SizedBox(width: 12),
                          // Expanded(
                          //   child: PaymentMethodCard(
                          //     logo: 'assets/images/flutterwave.png',
                          //     label: 'Flutterwave',
                          //     isSelected: controller.selectedGateway.value ==
                          //         'flutterwave',
                          //     onTap: () =>
                          //         controller.selectGateway('flutterwave'),
                          //   ),
                          // ),
                        ],
                      )).animate().slideY(begin: 0.2, duration: 800.ms),
                  const SizedBox(height: 40),
                  Obx(() => Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: controller.isLoading.value
                              ? null
                              : LinearGradient(
                                  colors: [
                                    LightThemeColors.primaryColor,
                                    LightThemeColors.primaryColor
                                        .withOpacity(0.8),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                          color: controller.isLoading.value
                              ? Colors.grey[300]
                              : null,
                          boxShadow: controller.isLoading.value
                              ? null
                              : [
                                  BoxShadow(
                                    color: LightThemeColors.primaryColor
                                        .withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                        ),
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.initializePayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? const SpinKitFadingCircle(
                                  color: Colors.white, size: 28)
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Proceed to Payment',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      )).animate().fadeIn(duration: 900.ms),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom widget for payment method cards
class PaymentMethodCard extends StatelessWidget {
  final String logo;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.logo,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    LightThemeColors.primaryColor.withOpacity(0.1),
                    LightThemeColors.primaryColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? LightThemeColors.primaryColor
                : Colors.grey[200]!,
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? LightThemeColors.primaryColor.withOpacity(0.15)
                  : Colors.black.withOpacity(0.04),
              blurRadius: isSelected ? 15 : 8,
              offset: Offset(0, isSelected ? 6 : 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                logo,
                height: 36,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected
                    ? LightThemeColors.primaryColor
                    : Colors.black87,
                letterSpacing: 0.3,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: LightThemeColors.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}