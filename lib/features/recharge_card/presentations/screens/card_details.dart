import 'package:royal/core/constants/images.dart';
import 'package:royal/core/theme/colors.dart';
import 'package:royal/core/utils/spacing.dart';
import 'package:royal/core/controllers/primary_button_controller.dart';
import 'package:royal/core/models/primary_button_model.dart';
import 'package:royal/core/models/top_header_model.dart';
import 'package:royal/core/widgets/primary_button_widget.dart';
import 'package:royal/core/widgets/top_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:royal/core/controllers/transaction_auth_controller.dart';
import 'package:royal/features/recharge_card/controller/index.dart';

class GsubzRechargeCardDetailsScreen extends StatelessWidget {
  const GsubzRechargeCardDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>;
    final network = data['network'];
    final denomination = data['denomination'];
    final quantity = data['quantity'];
    final totalAmount = data['totalAmount'];

    final GsubzRechargeCardIndexController rechargeCardController =
        Get.find<GsubzRechargeCardIndexController>();
    final TransactionAuthController transactionAuthController =
        Get.find<TransactionAuthController>();

    final networkName = rechargeCardController.networkMapping[network]['name']!;

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: Spacing.defaultMarginSpacing,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TopHeaderWidget(
                  data: TopHeaderModel(title: 'Recharge Card Details')),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF7F7F7),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(19.08),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 4,
                          offset: Offset(4, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              networkName == 'MTN'
                                  ? SvgConstant.mtnIcon
                                  : networkName == 'GLO'
                                      ? SvgConstant.gloIcon
                                      : networkName == 'Airtel'
                                          ? SvgConstant.airtelIcon
                                          : SvgConstant.etisalatIcon,
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$networkName Recharge Card',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          height: 1.38,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'E-Printing Service',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          height: 1.57,
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          decoration: ShapeDecoration(
                            color: Colors.white.withOpacity(0.8999999761581421),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 0.50),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x1E000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              details('Transaction Date',
                                  _formatDate(DateTime.now())),
                              const SizedBox(height: 5),
                              details('Transaction Type', 'Recharge Card'),
                              const SizedBox(height: 5),
                              details('Network', networkName),
                              const SizedBox(height: 5),
                              details('Denomination', '₦$denomination'),
                              const SizedBox(height: 5),
                              details('Quantity', '$quantity card(s)'),
                              const SizedBox(height: 5),
                              details('Total Amount', '₦$totalAmount'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.blue.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue.shade700,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Your recharge card PINs will be generated instantly after payment confirmation.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue.shade900,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Obx(() => rechargeCardController.isLoading.value
                  ? CustomPrimaryButton(
                      controller: CustomPrimaryButtonController(
                        model: const CustomPrimaryButtonModel(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    )
                  : CustomPrimaryButton(
                      controller: CustomPrimaryButtonController(
                        model: const CustomPrimaryButtonModel(text: 'Proceed'),
                        onPressed: () async {
                          bool isAuthenticated = await transactionAuthController
                              .authenticate(context, 'Generate Recharge Cards');
                          if (isAuthenticated) {
                            await rechargeCardController.generateRechargeCard();
                          }
                        },
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  Widget details(String name, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: Theme.of(Get.context!).textTheme.displayMedium?.copyWith(
              fontSize: 12, fontWeight: FontWeight.w500, height: 1.38),
        ),
        Flexible(
          child: Text(
            value,
            style: Theme.of(Get.context!).textTheme.displayMedium?.copyWith(
                fontSize: 12, fontWeight: FontWeight.w500, height: 1.38),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}