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
import 'package:royal/features/data/controllers/gsubz_data_index_controller.dart';

class GsubzDataDetailsScreen extends StatelessWidget {
  const GsubzDataDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>;
    final service = data['service']; // Service index
    final phoneNumber = data['phone'];
    final planName = data['plan_name'];

    final GsubzDataIndexController dataIndexController =
        Get.find<GsubzDataIndexController>();
    final TransactionAuthController transactionAuthController =
        Get.find<TransactionAuthController>();

    // Get service details
    final serviceName = dataIndexController.serviceMapping[service]['name']!;
    final network = dataIndexController.serviceMapping[service]['network']!;

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: Spacing.defaultMarginSpacing,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TopHeaderWidget(data: TopHeaderModel(title: 'Gsubz Data')),
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
                            // Network icon based on network type
                            SvgPicture.asset(
                              network == 'MTN'
                                  ? SvgConstant.mtnIcon
                                  : network == 'GLO'
                                      ? SvgConstant.gloIcon
                                      : network == 'AIRTEL'
                                          ? SvgConstant.airtelIcon
                                          : SvgConstant.etisalatIcon,
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    serviceName,
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
                                    phoneNumber,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                          fontSize: 17.75,
                                          fontWeight: FontWeight.w500,
                                          height: 1.57,
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
                              details('Transaction Type', 'Gsubz Data'),
                              const SizedBox(height: 5),
                              details('Service Type', serviceName),
                              const SizedBox(height: 5),
                              details('Data Plan', planName),
                              const SizedBox(height: 5),
                              details('Amount',
                                  '₦${dataIndexController.selectedAmount.value}'),
                              const SizedBox(height: 5),
                              details('Phone Number', phoneNumber),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              Obx(() => dataIndexController.isLoading.value
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
                              .authenticate(context, 'Buy Gsubz Data');
                          if (isAuthenticated) {
                            await dataIndexController.buyData();
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