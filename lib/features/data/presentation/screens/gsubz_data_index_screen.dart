// import 'package:royal/core/constants/routes.dart';
// import 'package:royal/core/theme/colors.dart';
// import 'package:royal/core/utils/spacing.dart';
// import 'package:royal/core/widgets/vtu_input_field.dart';
// import 'package:royal/features/data/controllers/gsubz_data_index_controller.dart';
// import 'package:royal/features/data/presentation/widgets/gsubz_data_selector_widget.dart';
// import 'package:royal/features/data/presentation/widgets/gsubz_plan_widget.dart';
// import 'package:royal/core/models/input_field_model.dart';
// import 'package:royal/core/controllers/primary_button_controller.dart';
// import 'package:royal/core/models/primary_button_model.dart';
// import 'package:royal/core/models/top_header_model.dart';
// import 'package:royal/core/widgets/primary_button_widget.dart';
// import 'package:royal/core/widgets/top_header_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class GsubzDataScreen extends StatefulWidget {
//   const GsubzDataScreen({super.key});

//   @override
//   State<GsubzDataScreen> createState() => _GsubzDataScreenState();
// }

// class _GsubzDataScreenState extends State<GsubzDataScreen> {
//   final GsubzDataIndexController controller = Get.put(GsubzDataIndexController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           margin: Spacing.defaultMarginSpacing,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const TopHeaderWidget(
//                     data: TopHeaderModel(title: "Gsubz Data")),
//                 const SizedBox(height: 37.82),
//                 Text(
//                   'Select Service Type',
//                   style: Theme.of(context).textTheme.displayMedium?.copyWith(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w400,
//                       height: 1.83),
//                 ),
//                 const SizedBox(height: 10),
//                 const GsubzServiceSelectorWidget(),
//                 const SizedBox(height: 20),
//                 Obx(() => controller.isLoading.value
//                     ? const Center(
//                         child: Padding(
//                           padding: EdgeInsets.all(20.0),
//                           child: CircularProgressIndicator(),
//                         ),
//                       )
//                     : Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Select Data Plan',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .displayMedium
//                                 ?.copyWith(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w400,
//                                     height: 1.83),
//                           ),
//                           const SizedBox(height: 10),
//                           const GsubzPlanWidget(),
//                         ],
//                       )),
//                 const SizedBox(height: 20),
//                 vtuInputField(VtuInputFieldModel(
//                     onChanged: controller.setPhoneNumber,
//                     inputcontroller: controller.phoneController,
//                     hintText: '08134460259',
//                     name: 'Phone Number')),
//                 const SizedBox(height: 40),
//                 Obx(() => CustomPrimaryButton(
//                       controller: CustomPrimaryButtonController(
//                           model: CustomPrimaryButtonModel(
//                               text: 'Buy Data',
//                               color: controller.isInformationComplete.value
//                                   ? DarkThemeColors.primaryColor
//                                   : DarkThemeColors.disabledButtonColor),
//                           onPressed: () {
//                             if (controller.validateInputs()) {
//                               Get.toNamed(RoutesConstant.gsubz_data_details,
//                                   arguments: {
//                                     'service': controller.selectedService.value,
//                                     'plan_value': controller.selectedPlanValue.value,
//                                     'plan_name': controller.selectedPlanName.value,
//                                     'phone': controller.phoneNumber.value
//                                   });
//                             }
//                           }),
//                     ))
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:royal/core/constants/routes.dart';
import 'package:royal/core/theme/colors.dart';
import 'package:royal/core/utils/spacing.dart';
import 'package:royal/core/widgets/vtu_input_field.dart';
import 'package:royal/features/data/controllers/gsubz_data_index_controller.dart';
import 'package:royal/features/data/presentation/widgets/gsubz_data_selector_widget.dart';
import 'package:royal/features/data/presentation/widgets/gsubz_plan_widget.dart';
import 'package:royal/core/models/input_field_model.dart';
import 'package:royal/core/controllers/primary_button_controller.dart';
import 'package:royal/core/models/primary_button_model.dart';
import 'package:royal/core/models/top_header_model.dart';
import 'package:royal/core/widgets/primary_button_widget.dart';
import 'package:royal/core/widgets/top_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GsubzDataScreen extends StatefulWidget {
  const GsubzDataScreen({super.key});

  @override
  State<GsubzDataScreen> createState() => _GsubzDataScreenState();
}

class _GsubzDataScreenState extends State<GsubzDataScreen> {
  final GsubzDataIndexController controller =
      Get.put(GsubzDataIndexController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: Spacing.defaultMarginSpacing,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TopHeaderWidget(
                          data: TopHeaderModel(title: "Gsubz Data")),
                      const SizedBox(height: 37.82),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select Service Type',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    height: 1.83),
                          ),

                          // Layout toggle button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Obx(() => InkWell(
                                    onTap: () =>
                                        controller.toggleServiceLayout(),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: DarkThemeColors.primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: DarkThemeColors.primaryColor
                                              .withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            controller.isServiceLayoutHorizontal
                                                    .value
                                                ? Icons.view_list_rounded
                                                : Icons.view_module_rounded,
                                            size: 18,
                                            color: DarkThemeColors.primaryColor,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            controller.isServiceLayoutHorizontal
                                                    .value
                                                ? 'Grid'
                                                : 'List',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  DarkThemeColors.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const GsubzServiceSelectorWidget(),
                      const SizedBox(height: 20),
                      Obx(() => controller.isLoading.value
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select Data Plan',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          height: 1.83),
                                ),
                                const SizedBox(height: 10),
                                const GsubzPlanWidget(),
                              ],
                            )),
                      const SizedBox(height: 20),
                      vtuInputField(VtuInputFieldModel(
                          onChanged: controller.setPhoneNumber,
                          inputcontroller: controller.phoneController,
                          hintText: '08134460259',
                          name: 'Phone Number')),
                      const SizedBox(height: 20), // Space for bottom button
                    ],
                  ),
                ),
              ),
            ),
            // Fixed bottom button
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
                            text: 'Buy Data',
                            color: controller.isInformationComplete.value
                                ? DarkThemeColors.primaryColor
                                : DarkThemeColors.disabledButtonColor),
                        onPressed: () {
                          if (controller.validateInputs()) {
                            Get.toNamed(RoutesConstant.gsubz_data_details,
                                arguments: {
                                  'service': controller.selectedService.value,
                                  'plan_value':
                                      controller.selectedPlanValue.value,
                                  'plan_name':
                                      controller.selectedPlanName.value,
                                  'phone': controller.phoneNumber.value
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
