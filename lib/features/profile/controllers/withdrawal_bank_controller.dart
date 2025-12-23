import 'package:royal/core/models/user_auth_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:royal/core/constants/api_url.dart';
import 'package:royal/core/errors/error_mapper.dart';
import 'package:royal/core/errors/failure.dart';
import 'package:royal/core/models/paystack_bank_model.dart';
import 'package:royal/core/repository/payment_repository.dart';
import 'package:royal/core/utils/snackbar.dart';
import 'package:royal/features/profile/data/repositories/edit_profile_repository.dart';
import 'package:royal/core/controllers/user_auth_details_controller.dart';
import 'package:royal/core/services/secure_storage_service.dart';
import 'dart:convert';
import 'package:royal/core/controllers/transaction_auth_controller.dart';

class WithdrawalBankController extends GetxController {
  final formKey = GlobalKey<FormState>();
  var banks = <PaystackBankModel>[].obs; // Observable list of banks
  final accountNumberController = TextEditingController();
  var selectedBank =
      Rxn<PaystackBankModel>(); // Nullable reactive selected bank
  var isLoading = false.obs; // Loading state for the save button
  final PaymentRepository paymentRepository = PaymentRepository();
  final EditProfileRepository editrepo = EditProfileRepository();
  final UserAuthDetailsController authDetailsController =
      Get.find<UserAuthDetailsController>();
  var accountName = ''.obs; // Observable account name
  var isVerifying = false.obs; // Verification loading state

  @override
  void onInit() {
    super.onInit();
    fetchBanks(); // Fetch banks when the controller initializes
    // Auto-verify when account number reaches 10 digits
    accountNumberController.addListener(_autoVerifyAccount);

    // Clear account name when bank changes
    ever(selectedBank, (_) {
      if (accountName.value.isNotEmpty) {
        accountName.value = '';
        // Re-verify if account number is complete
        if (accountNumberController.text.trim().length == 10) {
          _autoVerifyAccount();
        }
      }
    });
  }

// Auto-verify account when conditions are met
  void _autoVerifyAccount() {
    final accountNumber = accountNumberController.text.trim();

    // Clear account name if number is incomplete
    if (accountNumber.length < 10 && accountName.value.isNotEmpty) {
      accountName.value = '';
    }

    // Auto-verify when number is complete and bank is selected
    if (accountNumber.length == 10 && selectedBank.value != null) {
      verifyBankAccount();
    }
  }

  // bool validateInputs() {
  //   if (accountNumberController.text.trim().length != 10) {
  //     showSnackbar('Validation Error', "Enter correct account number");
  //     return false;
  //   } else if (selectedBank.value == null) {
  //     showSnackbar('Validation Error', "Pelease select bank name");
  //   }
  //   return true;
  // }

  bool validateInputs() {
    if (accountNumberController.text.trim().length != 10) {
      showSnackbar('Validation Error', "Enter correct account number");
      return false;
    } else if (selectedBank.value == null) {
      showSnackbar('Validation Error', "Please select bank name");
      return false;
    } else if (accountName.value.isEmpty) {
      showSnackbar('Validation Error', "Please verify account number first");
      return false;
    }
    return true;
  }

  // Fetch the list of banks from the API
  Future<void> fetchBanks() async {
    try {
      final response = await paymentRepository
          .fetchBanks('${ApiUrl.base_url}/payment/paystack/banks');
      banks.assignAll(response); // Populate the banks list
    } catch (e) {
      Failure failure = ErrorMapper.map(e as Exception);
      showSnackbar('Error', failure.message);
    }
  }

  // Update the user's withdrawal bank details
  Future<void> updateWithdrawalBank() async {
    // Validate that a bank is selected and account number is provided
    if (selectedBank.value == null || accountNumberController.text.isEmpty) {
      showSnackbar('Error', 'Please select a bank and enter an account number');
      return;
    }

    try {
      isLoading(true); // Show loading indicator

      Map data = {
        'bank_name': selectedBank.value!.name, // Send bank name
        'bank_code': selectedBank.value!.code, // Send bank code
        'account_number': accountNumberController.text, // Send account number
      };

      User response = await editrepo.updateWithdrawalBank(
          '${ApiUrl.users}/${authDetailsController.user.value?.id.toString()}/withdrawal-bank',
          data);

      Get.find<UserAuthDetailsController>().updateUser(response);
      await _storeAuthDetails(response);
    } catch (e) {
      showSnackbar('Error', 'Failed to update withdrawal bank: $e');
    } finally {
      isLoading(false); // Hide loading indicator
    }
  }

  // Store authentication details
  Future<void> _storeAuthDetails(User response) async {
    final storageService = SecureStorageService();
    await storageService.saveData(
        'user_details', jsonEncode(response.toJson()));
  }

  // Verify bank account
  // Verify bank account
  Future<void> verifyBankAccount({bool showSuccessMessage = false}) async {
    if (accountNumberController.text.trim().length != 10) {
      return;
    }

    if (selectedBank.value == null) {
      return;
    }

    try {
      isVerifying(true);
      accountName.value = ''; // Clear previous name

      final result = await editrepo.verifyBankAccount(
        accountNumberController.text,
        selectedBank.value!.code,
      );

      if (result['success'] == true) {
        accountName.value = result['account_name'];
        if (showSuccessMessage) {
          showSnackbar('Success', 'Account verified successfully');
        }
      } else {
        showSnackbar('Error', result['message'] ?? 'Verification failed');
      }
    } catch (e) {
      Failure failure = ErrorMapper.map(e as Exception);
      showSnackbar('Error', failure.message);
    } finally {
      isVerifying(false);
    }
  }

  @override
  void onClose() {
    accountNumberController.dispose(); // Clean up controller
    super.onClose();
  }
}
