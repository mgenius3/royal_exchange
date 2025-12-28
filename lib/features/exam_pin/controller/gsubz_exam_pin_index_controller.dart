// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:royal/core/controllers/user_auth_details_controller.dart';
// import 'package:royal/core/errors/error_mapper.dart';
// import 'package:royal/core/errors/failure.dart';
// import 'package:royal/core/utils/snackbar.dart';
// import 'package:royal/features/exam_pin/data/repository/gsubz_exam_pin_index.dart';
// import 'package:uuid/uuid.dart';
// import 'package:royal/core/constants/routes.dart';

// class GsubzExamPinIndexController extends GetxController {
//   final RxInt selectedExam = 0.obs; // 0=WAEC, 1=NECO, 2=NABTEB
//   final RxString selectedPrice = ''.obs;
//   final RxString selectedPlan = ''.obs;
//   final RxString phoneNumber = ''.obs;
//   final RxString totalAmount = '0'.obs;
//   final RxBool isInformationComplete = false.obs;
//   final RxBool isLoading = false.obs;
//   final RxList<dynamic> availableExams = <dynamic>[].obs;
//   final phoneController = TextEditingController();

//   final GsubzExamPinRepository examPinRepository = GsubzExamPinRepository();
//   final UserAuthDetailsController userAuthDetailsController =
//       Get.find<UserAuthDetailsController>();
//   final Uuid uuid = const Uuid();

//   // Exam mapping with service IDs
//   final List<Map<String, dynamic>> examMapping = [
//     {
//       'id': 'waec',
//       'name': 'WAEC',
//       'color': '0xFF4CAF50',
//       'active': false,
//       'price': 0,
//       'plan': '',
//       'loading': false,
//     },
//     {
//       'id': 'neco',
//       'name': 'NECO',
//       'color': '0xFF2196F3',
//       'active': false,
//       'price': 0,
//       'plan': '',
//       'loading': false,
//     },
//     {
//       'id': 'nabteb',
//       'name': 'NABTEB',
//       'color': '0xFFFF9800',
//       'active': false,
//       'price': 0,
//       'plan': '',
//       'loading': false,
//     },
//   ];

//   @override
//   void onInit() {
//     super.onInit();
//     fetchAllExamPrices();
//   }

//   void setExam(int index) {
//     if (examMapping[index]['active'] == true) {
//       selectedExam.value = index;
//       selectedPrice.value = examMapping[index]['price'].toString();
//       selectedPlan.value = examMapping[index]['plan'];
//       calculateTotal();
//       checkInformation();
//     }
//   }

//   void setPhoneNumber(String phone) {
//     phoneNumber.value = phone;
//     checkInformation();
//   }

//   void calculateTotal() {
//     if (selectedPrice.value.isNotEmpty) {
//       final price = double.parse(selectedPrice.value);
//       final total = price;
//       totalAmount.value = total.toStringAsFixed(2);
//     } else {
//       totalAmount.value = '0';
//     }
//   }

//   void checkInformation() {
//     if (selectedPrice.value.isNotEmpty && phoneNumber.value.length == 11) {
//       isInformationComplete.value = true;
//     } else {
//       isInformationComplete.value = false;
//     }
//   }

//   bool validateInputs() {
//     final phone = phoneNumber.value;
//     final double? amount = double.tryParse(totalAmount.value);
//     final wallet_balance = double.parse(
//         userAuthDetailsController.user.value?.walletBalance ?? "0");

//     if (selectedPrice.value.isEmpty) {
//       Get.snackbar('Input Error', 'Please select an exam',
//           backgroundColor: Colors.red, colorText: Colors.white);
//       return false;
//     }

//     if (!RegExp(r'^(0[789][01]\d{8})$').hasMatch(phone)) {
//       Get.snackbar('Input Error', 'Please enter a valid Nigerian phone number',
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

//   Future<void> fetchAllExamPrices() async {
//     isLoading.value = true;
//     try {
//       // Fetch prices for all 3 exams
//       for (int i = 0; i < examMapping.length; i++) {
//         examMapping[i]['loading'] = true;
//         try {
//           final response =
//               await examPinRepository.getExamPinPlans(examMapping[i]['id']);

//           if (response['status'] == 'success' &&
//               response['data']['active'] == true) {
//             final plans = response['data']['plans'] as List;
//             if (plans.isNotEmpty) {
//               examMapping[i]['active'] = true;
//               examMapping[i]['price'] = plans[0]['price'];
//               examMapping[i]['plan'] = plans[0]['value'];
//             }
//           } else {
//             // Service inactive or error
//             examMapping[i]['active'] = false;
//           }
//         } catch (e) {
//           // Service failed to load
//           examMapping[i]['active'] = false;
//         }
//         examMapping[i]['loading'] = false;
//       }

//       // Auto-select first active exam
//       final firstActive =
//           examMapping.indexWhere((exam) => exam['active'] == true);
//       if (firstActive != -1) {
//         setExam(firstActive);
//       }

//       availableExams.value = examMapping;
//     } catch (e) {
//       Failure failure = ErrorMapper.map(e as Exception);
//       showSnackbar('Error', failure.message);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> buyExamPin() async {
//     if (!isInformationComplete.value) return;
//     isLoading.value = true;
//     try {
//       final requestID = uuid.v4();
//       final amount = double.parse(totalAmount.value);
//       final serviceID = examMapping[selectedExam.value]['id'];
//       final plan = examMapping[selectedExam.value]['plan'];

//       final response = await examPinRepository.buyExamPin(
//         userId: userAuthDetailsController.user.value!.id.toString(),
//         amount: amount,
//         serviceID: serviceID,
//         plan: plan,
//         phone: phoneNumber.value,
//         requestID: requestID,
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

//   @override
//   void onClose() {
//     phoneController.dispose();
//     super.onClose();
//   }
// }

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:royal/features/exam_pin/data/repository/gsubz_exam_pin_index.dart';

class GsubzExamPinIndexController extends GetxController {
  final GsubzExamPinRepository repository = GsubzExamPinRepository();

  GsubzExamPinIndexController();

  // Make examMapping reactive by using RxList
  final RxList<Map<String, dynamic>> examMapping =
      RxList<Map<String, dynamic>>([
    {
      'id': 'waec',
      'name': 'WAEC',
      'color': '0xFF4CAF50',
      'active': false,
      'price': 0,
      'plan': 'WAEC',
      'loading': true
    },
    {
      'id': 'neco',
      'name': 'NECO',
      'color': '0xFF2196F3',
      'active': false,
      'price': 0,
      'plan': 'NECO',
      'loading': true
    },
    {
      'id': 'nabteb',
      'name': 'NABTEB',
      'color': '0xFFFF9800',
      'active': false,
      'price': 0,
      'plan': 'NABTEB',
      'loading': true
    },
  ]);

  final selectedExam = RxInt(-1);
  final selectedPrice = RxString('');
  final quantity = RxInt(1);
  final phoneNumber = RxString('');
  final totalAmount = RxString('0');
  final isLoading = RxBool(false);

  final phoneController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchAllExamPrices();
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  /// Fetch prices for all exams
  Future<void> fetchAllExamPrices() async {
    isLoading.value = true;

    for (int i = 0; i < examMapping.length; i++) {
      final exam = examMapping[i];

      try {
        final response = await repository.getExamPinPlans(exam['id']);

        if (response['status'] == 'success' && response['data'] != null) {
          final data = response['data'];

          final plans = response['data']['plans'] as List;

          // Create a new map with updated values
          examMapping[i] = {
            ...exam,
            'active': data['active'] == true,
            'price': plans[0]['price'] ?? 0,
            'plan': plans[0]['value'] ?? exam['plan'],
            'loading': false,
          };

          // Trigger reactivity
          examMapping.refresh();

          // Auto-select first active exam
          if (selectedExam.value == -1 && data['active'] == true) {
            setExam(i);
          }
        } else {
          // Mark as inactive if fetch failed
          examMapping[i] = {
            ...exam,
            'active': false,
            'loading': false,
          };
          examMapping.refresh();
        }
      } catch (e) {
        print('Error fetching ${exam['name']} price: $e');
        examMapping[i] = {
          ...exam,
          'active': false,
          'loading': false,
        };
        examMapping.refresh();
      }
    }

    isLoading.value = false;
  }

  /// Set selected exam
  void setExam(int index) {
    if (index < 0 || index >= examMapping.length) return;

    final exam = examMapping[index];

    // Only allow selection of active exams
    if (exam['active'] != true) return;

    selectedExam.value = index;
    selectedPrice.value = exam['price'].toString();
    calculateTotal();
  }

  /// Set phone number
  void setPhoneNumber(String value) {
    phoneNumber.value = value;
  }

  /// Set quantity
  void setQuantity(int value) {
    if (value < 1) {
      quantity.value = 1;
    } else if (value > 50) {
      quantity.value = 50;
    } else {
      quantity.value = value;
    }
    calculateTotal();
  }

  /// Increment quantity
  void incrementQuantity() {
    if (quantity.value < 50) {
      quantity.value++;
      calculateTotal();
    }
  }

  /// Decrement quantity
  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
      calculateTotal();
    }
  }

  /// Calculate total amount
  void calculateTotal() {
    if (selectedPrice.value.isNotEmpty) {
      final price = double.tryParse(selectedPrice.value) ?? 0;
      final total = price * quantity.value;
      totalAmount.value = total.toStringAsFixed(0);
    } else {
      totalAmount.value = '0';
    }
  }

  /// Check if all required information is complete
  RxBool get isInformationComplete {
    return (selectedExam.value >= 0 &&
            selectedPrice.value.isNotEmpty &&
            phoneNumber.value.isNotEmpty &&
            phoneNumber.value.length >= 11)
        .obs;
  }

  /// Validate inputs before purchase
  bool validateInputs() {
    if (selectedExam.value < 0) {
      Get.snackbar(
        'Error',
        'Please select an exam',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (phoneNumber.value.isEmpty || phoneNumber.value.length < 11) {
      Get.snackbar(
        'Error',
        'Please enter a valid phone number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  /// Buy exam pin
  Future<void> buyExamPin() async {
    if (!validateInputs()) return;

    final exam = examMapping[selectedExam.value];

    // TODO: Implement actual purchase logic
    // This should call the repository method
  }
}
