import 'package:royal/core/controllers/user_auth_details_controller.dart';
import 'package:royal/core/models/paystack_bank_model.dart';
import 'package:royal/core/utils/spacing.dart';
import 'package:royal/core/models/top_header_model.dart';
import 'package:royal/core/widgets/primary_button_widget.dart';
import 'package:royal/core/widgets/top_header_widget.dart';
import 'package:royal/features/profile/controllers/withdrawal_bank_controller.dart';
import 'package:royal/features/profile/data/model/input_field_model.dart';
import 'package:royal/features/profile/presentation/widget/input_field_model.dart';
import 'package:royal/features/profile/presentation/widget/withdrawal_bank_widget.dart';
import 'package:flutter/material.dart';
import 'package:royal/core/controllers/primary_button_controller.dart';
import 'package:royal/core/models/primary_button_model.dart';
import 'package:get/get.dart';
import 'package:royal/core/controllers/transaction_auth_controller.dart';

class WithdrawalBankScreen extends StatelessWidget {
  const WithdrawalBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionAuthController transactionAuthController =
        Get.find<TransactionAuthController>();
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: GetBuilder<WithdrawalBankController>(
          init: WithdrawalBankController(),
          builder: (controller) {
            return Container(
              margin: Spacing.defaultMarginSpacing,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TopHeaderWidget(
                    data: TopHeaderModel(title: 'Withdrawal Bank'),
                  ),
                  const SizedBox(height: 37.82),
                  Text(
                    'Withdrawal Bank',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'This is where funds will be sent to',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 20),
                  WithdrawalBankWidget(),
                  const SizedBox(height: 20),
                  Autocomplete<PaystackBankModel>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return controller.banks;
                      }
                      return controller.banks.where((bank) => bank.name
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()));
                    },
                    displayStringForOption: (PaystackBankModel bank) =>
                        bank.name, // Display bank name
                    onSelected: (PaystackBankModel value) {
                      controller.selectedBank.value =
                          value; // Update selected bank
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController fieldTextEditingController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted) {
                      return TextField(
                        controller: fieldTextEditingController,
                        focusNode: fieldFocusNode,
                        decoration: InputDecoration(
                          labelText: "Select Bank",
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                    optionsViewBuilder: (BuildContext context,
                        AutocompleteOnSelected<PaystackBankModel> onSelected,
                        Iterable<PaystackBankModel> options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: 200,
                              maxWidth: MediaQuery.of(context).size.width - 40,
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final PaystackBankModel option =
                                    options.elementAt(index);
                                return ListTile(
                                  title: Text(option.name),
                                  onTap: () => onSelected(option),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  profileInputField(ProfileInputFieldModel(
                    inputcontroller: controller.accountNumberController,
                    name: 'Account Number',
                    hintText: 'Enter Account Number',
                    // keyboardType: TextInputType.number,
                  )),
                  const SizedBox(height: 15),
                  Obx(() => controller.isVerifying.value
                      ? Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Verifying account...',
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
                        )
                      : controller.accountName.value.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle,
                                      color: Colors.green),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      controller.accountName.value,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink()),
                  const SizedBox(height: 40),
                  Obx(() => controller.isLoading.value
                      ? CustomPrimaryButton(
                          controller: CustomPrimaryButtonController(
                              model: const CustomPrimaryButtonModel(
                                  child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          color: Colors.white))),
                              onPressed: () {}),
                        )
                      : CustomPrimaryButton(
                          controller: CustomPrimaryButtonController(
                            model: CustomPrimaryButtonModel(
                                text:
                                    '${Get.find<UserAuthDetailsController>().user.value?.withdrawalBank?.bankName == null ? 'Save' : 'Update'} Bank Details'),
                            onPressed: () async {
                              bool isAuthenticated =
                                  await transactionAuthController.authenticate(
                                      context, 'Save or Update Bank details');

                              if (isAuthenticated) {
                                if (controller.validateInputs()) {
                                  await controller.updateWithdrawalBank();
                                }
                              }
                            },
                          ),
                        )),
                ],
              ),
            );
          },
        ),
      )),
    );
  }
}
