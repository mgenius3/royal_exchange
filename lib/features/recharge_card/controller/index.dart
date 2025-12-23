import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:royal/core/controllers/user_auth_details_controller.dart';
import 'package:royal/core/errors/error_mapper.dart';
import 'package:royal/core/errors/failure.dart';
import 'package:royal/core/utils/snackbar.dart';
import 'package:royal/features/recharge_card/data/repository/index.dart';
import 'package:uuid/uuid.dart';
import 'package:royal/core/constants/routes.dart';

class GsubzRechargeCardIndexController extends GetxController {
  final RxInt selectedNetwork = 0.obs; // 0=Airtel, 1=GLO, 2=9Mobile, 3=MTN
  final RxString selectedDenomination = ''.obs;
  final RxString selectedPrice = ''.obs;
  final RxInt quantity = 1.obs;
  final RxString totalAmount = '0'.obs;
  final RxBool isInformationComplete = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<dynamic> denominations = <dynamic>[].obs;

  final GsubzRechargeCardRepository rechargeCardRepository =
      GsubzRechargeCardRepository();
  final UserAuthDetailsController userAuthDetailsController =
      Get.find<UserAuthDetailsController>();
  final Uuid uuid = const Uuid();

  // Network mapping
  final List<Map<String, String>> networkMapping = [
    {'id': 'airtel', 'name': 'Airtel', 'color': '0xFFF1A0A6'},
    {'id': 'glo', 'name': 'GLO', 'color': '0xFF50B651'},
    {'id': '9mobile', 'name': '9Mobile', 'color': '0xFFD6E806'},
    {'id': 'mtn', 'name': 'MTN', 'color': '0xFFF7E03D'},
  ];

  @override
  void onInit() {
    super.onInit();
    fetchDenominations();
  }

  void setNetwork(int index) {
    selectedNetwork.value = index;
    checkInformation();
  }

  void setDenomination(String value, String price) {
    print(value);
    print(price);
    selectedDenomination.value = value;
    selectedPrice.value = price;
    calculateTotal();
    checkInformation();
  }

  void incrementQuantity() {
    if (quantity.value < 50) {
      quantity.value++;
      calculateTotal();
      checkInformation();
    }
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
      calculateTotal();
      checkInformation();
    }
  }

  void setQuantity(int value) {
    if (value >= 1 && value <= 50) {
      quantity.value = value;
      calculateTotal();
      checkInformation();
    }
  }

  void calculateTotal() {
    if (selectedPrice.value.isNotEmpty) {
      final price = double.parse(selectedPrice.value);
      final total = price * quantity.value;
      totalAmount.value = total.toStringAsFixed(2);
    } else {
      totalAmount.value = '0';
    }
  }

  void checkInformation() {
    if (selectedDenomination.value.isNotEmpty && quantity.value > 0) {
      isInformationComplete.value = true;
    } else {
      isInformationComplete.value = false;
    }
  }

  bool validateInputs() {
    final denomination = selectedDenomination.value;
    final qty = quantity.value;
    final double? amount = double.tryParse(totalAmount.value);

    final wallet_balance = double.parse(
        userAuthDetailsController.user.value?.walletBalance ?? "0");

    if (denomination.isEmpty) {
      Get.snackbar('Input Error', 'Please select a card denomination',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (qty < 1 || qty > 50) {
      Get.snackbar('Input Error', 'Quantity must be between 1 and 50',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (amount! > wallet_balance) {
      Get.snackbar('Wallet Error', 'Amount exceeds your wallet balance',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    return true;
  }

  Future<void> fetchDenominations() async {
    isLoading.value = true;
    try {
      final response = await rechargeCardRepository.getCardDenominations();
      denominations.value = response['denominations'] ?? [];

      if (denominations.isNotEmpty) {
        selectedDenomination.value = denominations[0]['value'];
        selectedPrice.value = denominations[0]['price'].toString();
        calculateTotal();
      }
    } catch (e) {
      Failure failure = ErrorMapper.map(e as Exception);
      showSnackbar('Error', failure.message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> generateRechargeCard() async {
    if (!isInformationComplete.value) return;
    isLoading.value = true;
    try {
      final requestID = uuid.v4();
      final amount = double.parse(totalAmount.value);
      final network = networkMapping[selectedNetwork.value]['id']!;

      final response = await rechargeCardRepository.generateRechargeCard(
        userId: userAuthDetailsController.user.value!.id.toString(),
        amount: amount,
        network: network,
        value: selectedDenomination.value,
        number: quantity.value,
        requestID: requestID,
      );

      final receiptData = response!['receipt_data'];
      Get.offNamed(RoutesConstant.gsubz_recharge_card_receipt,
          arguments: receiptData);
    } catch (e) {
      Failure failure = ErrorMapper.map(e as Exception);
      showSnackbar('Error', failure.message);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
