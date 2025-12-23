import 'dart:convert';
import 'package:royal/core/constants/routes.dart';
import 'package:royal/core/errors/error_mapper.dart';
import 'package:royal/core/errors/failure.dart';
import 'package:royal/core/utils/snackbar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:royal/features/data/data/repositories/gsubz_data_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:royal/core/controllers/user_auth_details_controller.dart';


class GsubzDataIndexController extends GetxController {
  final RxInt selectedService = 0.obs; // Index for service selection
  final RxString selectedPlanValue = ''.obs;
  final RxString selectedPlanName = ''.obs;
  final RxString selectedAmount = ''.obs;
  final RxString phoneNumber = ''.obs;
  final RxBool isInformationComplete = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<dynamic> dataPlans = <dynamic>[].obs;
  final phoneController = TextEditingController();
  final GsubzDataRepository dataRepository = GsubzDataRepository();
  final UserAuthDetailsController userAuthDetailsController =
      Get.find<UserAuthDetailsController>();
  final Uuid uuid = const Uuid();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final RxBool isServiceLayoutHorizontal = true.obs; // Layout toggle

  // Key for storing data plans in FlutterSecureStorage
  static const String _dataPlansKey = 'gsubz_data_plans';

  // Service mapping (Gsubz service IDs)
  final List<Map<String, String>> serviceMapping = [
    {
      'id': 'mtn_sme',
      'name': 'MTN SME',
      'network': 'MTN',
      'color': '0xFFF7E03D'
    },
    {
      'id': 'mtn_cg_lite (SME 2.0)',
      'name': 'MTN CG Lite',
      'network': 'MTN',
      'color': '0xFFF7E03D'
    },
    {
      'id': 'mtn_gifting',
      'name': 'MTN Gifting',
      'network': 'MTN',
      'color': '0xFFF7E03D'
    },
    {
      'id': 'mtn_coupon',
      'name': 'MTN Coupon',
      'network': 'MTN',
      'color': '0xFFF7E03D'
    },
    {'id': 'mtncg', 'name': 'MTN CG', 'network': 'MTN', 'color': '0xFFF7E03D'},
    {
      'id': 'airtel_cg',
      'name': 'Airtel CG',
      'network': 'AIRTEL',
      'color': '0xFFF1A0A6'
    },
    {
      'id': 'airtel_sme',
      'name': 'Airtel SME',
      'network': 'AIRTEL',
      'color': '0xFFF1A0A6'
    },
    {
      'id': 'glo_data',
      'name': 'GLO Data',
      'network': 'GLO',
      'color': '0xFF50B651'
    },
    {
      'id': 'glo_sme',
      'name': 'GLO SME',
      'network': 'GLO',
      'color': '0xFF50B651'
    },
    {
      'id': 'etisalat_data',
      'name': '9Mobile Data',
      'network': '9MOBILE',
      'color': '0xFFD6E806'
    },
  ];

  @override
  void onInit() async {
    super.onInit();
    await _loadDataPlansFromStorage();
    fetchDataPlans();
    phoneController.addListener(() {
      phoneNumber.value = phoneController.text;
      checkInformation();
    });
  }


 void toggleServiceLayout() {
    isServiceLayoutHorizontal.value = !isServiceLayoutHorizontal.value;
  }
  /// Load data plans from FlutterSecureStorage
  Future<void> _loadDataPlansFromStorage() async {
    try {
      final dataPlansJson = await _secureStorage.read(key: _dataPlansKey);
      if (dataPlansJson != null) {
        final Map<String, dynamic> storedPlans = jsonDecode(dataPlansJson);
        dataPlans.value = storedPlans['plans'] ?? [];
        if (dataPlans.isNotEmpty) {
          selectedPlanValue.value = dataPlans[0]['value'].toString();
          selectedPlanName.value = dataPlans[0]['displayName'];
          selectedAmount.value = dataPlans[0]['price'].toString();
        }
      }
    } catch (e) {
      print('Error loading data plans from storage: $e');
    }
  }

  /// Save data plans to FlutterSecureStorage
  Future<void> _saveDataPlansToStorage() async {
    try {
      final dataPlansMap = {
        'service': serviceMapping[selectedService.value]['id'],
        'plans': dataPlans
      };
      final dataPlansJson = jsonEncode(dataPlansMap);
      await _secureStorage.write(key: _dataPlansKey, value: dataPlansJson);
    } catch (e) {
      print('Error saving data plans to storage: $e');
    }
  }

  void setService(int index) {
    selectedService.value = index;
    fetchDataPlans();
    checkInformation();
  }

  void setPlan(String planValue, String planName, String amount) {
    selectedPlanValue.value = planValue;
    selectedPlanName.value = planName;
    selectedAmount.value = amount;
    checkInformation();
  }

  void setPhoneNumber(String phone) {
    phoneNumber.value = phone;
    checkInformation();
  }

  void checkInformation() {
    final network = serviceMapping[selectedService.value]['network']!;
    if (selectedPlanValue.value.isNotEmpty &&
        RegExp(r'^(0[789][01]\d{8})$').hasMatch(phoneNumber.value) &&
        _isValidNetwork(phoneNumber.value, network)) {
      isInformationComplete.value = true;
    } else {
      isInformationComplete.value = false;
    }
  }

  bool validateInputs() {
    final phone = phoneNumber.value.trim();
    final planValue = selectedPlanValue.value;
    final double? amount = double.tryParse(selectedAmount.value);

    final wallet_balance = double.parse(
        userAuthDetailsController.user.value?.walletBalance ?? "0");

    if (phone.isEmpty) {
      Get.snackbar('Input Error', 'Phone number is required',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (!RegExp(r'^(0[789][01]\d{8})$').hasMatch(phone)) {
      Get.snackbar('Input Error', 'Enter a valid Nigerian phone number',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    final network = serviceMapping[selectedService.value]['network']!;
    if (!_isValidNetwork(phone, network)) {
      Get.snackbar(
          'Input Error', 'Phone number does not match selected network',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (planValue.isEmpty) {
      Get.snackbar('Input Error', 'Please select a data plan',
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

  /// Validate that the phone number matches the selected network
  bool _isValidNetwork(String phone, String network) {
    final prefixes = {
      'MTN': [
        '0803',
        '0806',
        '0703',
        '0706',
        '0810',
        '0813',
        '0814',
        '0816',
        '0903',
        '0906',
        '0913',
        '0916'
      ],
      'GLO': ['0805', '0807', '0811', '0815', '0705', '0905'],
      '9MOBILE': ['0809', '0817', '0818', '0908', '0909'],
      'AIRTEL': ['0802', '0808', '0812', '0701', '0708', '0902', '0907'],
    };

    final networkPrefixes = prefixes[network] ?? [];
    return networkPrefixes.any((prefix) => phone.startsWith(prefix));
  }

  Future<void> fetchDataPlans() async {
    isLoading.value = true;
    try {
      final serviceId = serviceMapping[selectedService.value]['id']!;
      final response = await dataRepository.getDataPlans(serviceId);
      dataPlans.value = response['plans'] ?? [];

      if (dataPlans.isNotEmpty) {
        selectedPlanValue.value = dataPlans[0]['value'].toString();
        selectedPlanName.value = dataPlans[0]['displayName'];
        selectedAmount.value = dataPlans[0]['price'].toString();
      }

      await _saveDataPlansToStorage();
    } catch (e) {
      Failure failure = ErrorMapper.map(e as Exception);
      showSnackbar('Error', failure.message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> buyData() async {
    if (!isInformationComplete.value) return;
    isLoading.value = true;
    try {
      final requestID = uuid.v4();
      final amount = double.parse(selectedAmount.value);
      final serviceID = serviceMapping[selectedService.value]['id']!;

      final response = await dataRepository.buyData(
          userId: userAuthDetailsController.user.value!.id.toString(),
          amount: amount,
          mobileNumber: phoneNumber.value,
          serviceID: serviceID,
          plan: selectedPlanValue.value,
          requestId: requestID);

      final receiptData = response!['receipt_data'];
      Get.offNamed(RoutesConstant.gsubz_data_receipt, arguments: receiptData);
    } catch (e) {
      print(e.toString());
      Failure failure = ErrorMapper.map(e as Exception);
      showSnackbar('Error', failure.message);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
