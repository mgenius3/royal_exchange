// import 'package:royal/core/constants/routes.dart';
// import 'package:royal/core/errors/error_mapper.dart';
// import 'package:royal/core/errors/failure.dart';
// import 'package:royal/core/utils/snackbar.dart';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:royal/features/exam_pin/data/repository/gsubz_exam_pin_index.dart';
// import 'package:uuid/uuid.dart';
// import 'package:royal/core/controllers/user_auth_details_controller.dart';

// class GsubzExamPinIndexController extends GetxController {
//   final RxInt selectedExam = 0.obs; // 1=WAEC, 2=NECO, 3=NABTEB, 4=JAMB
//   final RxInt quantity = 1.obs;
//   final RxString selectedAmount = '0'.obs;
//   final RxBool isInformationComplete = false.obs;
//   final RxBool isLoading = false.obs;

//   final GsubzExamPinRepository examPinRepository = GsubzExamPinRepository();
//   final UserAuthDetailsController userAuthDetailsController =
//       Get.find<UserAuthDetailsController>();
//   final Uuid uuid = const Uuid();

//   // Exam mapping (examId => examName)
//   final Map<int, String> examMapping = {
//     1: 'WAEC',
//     2: 'NECO',
//     3: 'NABTEB',
//     4: 'JAMB',
//     5: 'OTHERS'
//   };

//   // Pricing per exam (this should ideally come from API)
//   final Map<int, double> examPrices = {
//     1: 3500.0, // WAEC
//     2: 1000.0, // NECO
//     3: 1000.0, // NABTEB
//     4: 4700.0, // JAMB
//     5: 500.0, // OTHERS
//   };

//   @override
//   void onInit() {
//     super.onInit();
//     _calculateAmount();
//   }

//   void setExam(int examId) {
//     selectedExam.value = examId;
//     _calculateAmount();
//     checkInformation();
//   }

//   void incrementQuantity() {
//     if (quantity.value < 50) {
//       quantity.value++;
//       _calculateAmount();
//       checkInformation();
//     }
//   }

//   void decrementQuantity() {
//     if (quantity.value > 1) {
//       quantity.value--;
//       _calculateAmount();
//       checkInformation();
//     }
//   }

//   void setQuantity(int value) {
//     if (value >= 1 && value <= 50) {
//       quantity.value = value;
//       _calculateAmount();
//       checkInformation();
//     }
//   }

//   void _calculateAmount() {
//     final price = examPrices[selectedExam.value] ?? 0.0;
//     selectedAmount.value = (price * quantity.value).toStringAsFixed(2);
//   }

//   void checkInformation() {
//     if (selectedExam.value > 0 && quantity.value > 0) {
//       isInformationComplete.value = true;
//     } else {
//       isInformationComplete.value = false;
//     }
//   }

//   bool validateInputs() {
//     final double? amount = double.tryParse(selectedAmount.value);
//     final wallet_balance = double.parse(
//         userAuthDetailsController.user.value?.walletBalance ?? "0");

//     if (selectedExam.value <= 0) {
//       Get.snackbar('Input Error', 'Please select an exam type',
//           backgroundColor: Colors.red, colorText: Colors.white);
//       return false;
//     }

//     if (quantity.value < 1 || quantity.value > 50) {
//       Get.snackbar('Input Error', 'Quantity must be between 1 and 50',
//           backgroundColor: Colors.red, colorText: Colors.white);
//       return false;
//     }

//     if (amount! > wallet_balance) {
//       Get.snackbar('Wallet Error', 'Amount exceeds your wallet balance',
//           backgroundColor: Colors.red, colorText: Colors.white);
//       return false;
//     }

//     return true;
//   }

//   Future<void> buyExamPin() async {
//     if (!isInformationComplete.value) return;
//     isLoading.value = true;
//     try {
//       final requestId = uuid.v4();
//       final amount = double.parse(selectedAmount.value);

//       final response = await examPinRepository.buyExamPin(
//         userId: userAuthDetailsController.user.value!.id.toString(),
//         amount: amount,
//         examName: selectedExam.value,
//         quantity: quantity.value,
//         requestId: requestId,
//       );

//       final receiptData = response!['receipt_data'];
//       Get.offNamed(RoutesConstant.gsubz_exam_pin_receipt,
//           arguments: receiptData);
//     } catch (e) {
//       Failure failure = ErrorMapper.map(e as Exception);
//       showSnackbar('Error', failure.message);
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:royal/core/controllers/user_auth_details_controller.dart';
import 'package:royal/core/errors/error_mapper.dart';
import 'package:royal/core/errors/failure.dart';
import 'package:royal/core/utils/snackbar.dart';
import 'package:royal/features/exam_pin/data/repository/gsubz_exam_pin_index.dart';
import 'package:uuid/uuid.dart';
import 'package:royal/core/constants/routes.dart';

class GsubzExamPinIndexController extends GetxController {
  final RxInt selectedExam = 0.obs; // 0=WAEC, 1=NECO, 2=NABTEB
  final RxString selectedPrice = ''.obs;
  final RxString selectedPlan = ''.obs;
  final RxString phoneNumber = ''.obs;
  final RxString totalAmount = '0'.obs;
  final RxBool isInformationComplete = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<dynamic> availableExams = <dynamic>[].obs;
  final phoneController = TextEditingController();

  final GsubzExamPinRepository examPinRepository = GsubzExamPinRepository();
  final UserAuthDetailsController userAuthDetailsController =
      Get.find<UserAuthDetailsController>();
  final Uuid uuid = const Uuid();

  // Exam mapping with service IDs
  final List<Map<String, dynamic>> examMapping = [
    {
      'id': 'waec',
      'name': 'WAEC',
      'color': '0xFF4CAF50',
      'active': false,
      'price': 0,
      'plan': '',
      'loading': false,
    },
    {
      'id': 'neco',
      'name': 'NECO',
      'color': '0xFF2196F3',
      'active': false,
      'price': 0,
      'plan': '',
      'loading': false,
    },
    {
      'id': 'nabteb',
      'name': 'NABTEB',
      'color': '0xFFFF9800',
      'active': false,
      'price': 0,
      'plan': '',
      'loading': false,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    fetchAllExamPrices();
  }

  void setExam(int index) {
    if (examMapping[index]['active'] == true) {
      selectedExam.value = index;
      selectedPrice.value = examMapping[index]['price'].toString();
      selectedPlan.value = examMapping[index]['plan'];
      calculateTotal();
      checkInformation();
    }
  }

  void setPhoneNumber(String phone) {
    phoneNumber.value = phone;
    checkInformation();
  }



 



  void calculateTotal() {
    if (selectedPrice.value.isNotEmpty) {
      final price = double.parse(selectedPrice.value);
      final total = price;
      totalAmount.value = total.toStringAsFixed(2);
    } else {
      totalAmount.value = '0';
    }
  }

  void checkInformation() {
    if (selectedPrice.value.isNotEmpty &&
        phoneNumber.value.length == 11 ) {
      isInformationComplete.value = true;
    } else {
      isInformationComplete.value = false;
    }
  }

  bool validateInputs() {
    final phone = phoneNumber.value;
    final double? amount = double.tryParse(totalAmount.value);
    final wallet_balance = double.parse(
        userAuthDetailsController.user.value?.walletBalance ?? "0");

    if (selectedPrice.value.isEmpty) {
      Get.snackbar('Input Error', 'Please select an exam',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (!RegExp(r'^(0[789][01]\d{8})$').hasMatch(phone)) {
      Get.snackbar('Input Error', 'Please enter a valid Nigerian phone number',
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

  Future<void> fetchAllExamPrices() async {
    isLoading.value = true;
    try {
      // Fetch prices for all 3 exams
      for (int i = 0; i < examMapping.length; i++) {
        examMapping[i]['loading'] = true;
        try {
          final response =
              await examPinRepository.getExamPinPlans(examMapping[i]['id']);

          if (response['status'] == 'success' &&
              response['data']['active'] == true) {
            final plans = response['data']['plans'] as List;
            if (plans.isNotEmpty) {
              examMapping[i]['active'] = true;
              examMapping[i]['price'] = plans[0]['price'];
              examMapping[i]['plan'] = plans[0]['value'];
            }
          } else {
            // Service inactive or error
            examMapping[i]['active'] = false;
          }
        } catch (e) {
          // Service failed to load
          examMapping[i]['active'] = false;
        }
        examMapping[i]['loading'] = false;
      }

      // Auto-select first active exam
      final firstActive =
          examMapping.indexWhere((exam) => exam['active'] == true);
      if (firstActive != -1) {
        setExam(firstActive);
      }

      availableExams.value = examMapping;
    } catch (e) {
      Failure failure = ErrorMapper.map(e as Exception);
      showSnackbar('Error', failure.message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> buyExamPin() async {
    if (!isInformationComplete.value) return;
    isLoading.value = true;
    try {
      final requestID = uuid.v4();
      final amount = double.parse(totalAmount.value);
      final serviceID = examMapping[selectedExam.value]['id'];
      final plan = examMapping[selectedExam.value]['plan'];

      final response = await examPinRepository.buyExamPin(
        userId: userAuthDetailsController.user.value!.id.toString(),
        amount: amount,
        serviceID: serviceID,
        plan: plan,
        phone: phoneNumber.value,
        requestID: requestID,
      );

      final receiptData = response!['receipt_data'];
      Get.offNamed(RoutesConstant.gsubz_exam_pin_receipt,
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
    phoneController.dispose();
    super.onClose();
  }
}
