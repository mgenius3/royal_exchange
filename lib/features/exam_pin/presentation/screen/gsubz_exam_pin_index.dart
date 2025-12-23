import 'package:royal/core/constants/routes.dart';
import 'package:royal/core/theme/colors.dart';
import 'package:royal/core/utils/spacing.dart';
import 'package:royal/core/widgets/vtu_input_field.dart';
import 'package:royal/features/exam_pin/controller/gsubz_exam_pin_index_controller.dart';
import 'package:royal/core/models/input_field_model.dart';
import 'package:royal/core/controllers/primary_button_controller.dart';
import 'package:royal/core/models/primary_button_model.dart';
import 'package:royal/core/models/top_header_model.dart';
import 'package:royal/core/widgets/primary_button_widget.dart';
import 'package:royal/core/widgets/top_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:royal/features/exam_pin/presentation/widget/gsubz_exam_pin_selector_widget.dart';

class GsubzExamPinScreen extends StatefulWidget {
  const GsubzExamPinScreen({super.key});

  @override
  State<GsubzExamPinScreen> createState() => _GsubzExamPinScreenState();
}

class _GsubzExamPinScreenState extends State<GsubzExamPinScreen> {
  final GsubzExamPinIndexController controller =
      Get.put(GsubzExamPinIndexController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: Spacing.defaultMarginSpacing,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TopHeaderWidget(
                          data: TopHeaderModel(title: "Exam Pin")),
                      const SizedBox(height: 37.82),
                      Text(
                        'Select Exam',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 1.83),
                      ),
                      const SizedBox(height: 10),
                      const ExamPinSelectorWidget(),
                      const SizedBox(height: 20),
                      Obx(() {
                        if (controller.selectedPrice.value.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.orange.shade200,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.orange.shade700,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Please select an exam to continue',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.orange.shade900,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                    'Price per PIN',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  Text(
                                    '₦${controller.selectedPrice.value}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: DarkThemeColors.primaryColor,
                                        ),
                                  ),
                                ],
                              ),
                            ),
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
                            vtuInputField(VtuInputFieldModel(
                                onChanged: controller.setPhoneNumber,
                                inputcontroller: controller.phoneController,
                                hintText: '08134460259',
                                name: 'Phone Number')),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    DarkThemeColors.primaryColor
                                        .withOpacity(0.15),
                                    DarkThemeColors.primaryColor
                                        .withOpacity(0.08),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: DarkThemeColors.primaryColor
                                      .withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Amount',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Obx(() => Text(
                                        '₦${controller.totalAmount.value}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  DarkThemeColors.primaryColor,
                                            ),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
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
                            text: 'Buy Exam PIN',
                            color: controller.isInformationComplete.value
                                ? DarkThemeColors.primaryColor
                                : DarkThemeColors.disabledButtonColor),
                        onPressed: () {
                          if (controller.validateInputs()) {
                            Get.toNamed(RoutesConstant.gsubz_exam_pin_details,
                                arguments: {
                                  'exam': controller.selectedExam.value,
                                  'price': controller.selectedPrice.value,
                                  'phone': controller.phoneNumber.value,
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
