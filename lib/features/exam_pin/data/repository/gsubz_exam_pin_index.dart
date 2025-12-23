// import 'dart:convert';
// import 'package:royal/core/constants/api_url.dart';
// import 'package:royal/core/errors/app_exception.dart';
// import 'package:royal/core/errors/dio_error_handler.dart';
// import 'package:dio/dio.dart';
// import 'package:royal/api/api_client.dart';

// class GsubzExamPinRepository {
//   final DioClient apiClient;

//   GsubzExamPinRepository() : apiClient = DioClient();

//   /// Purchase exam pin via Gsubz API
//   Future<Map?> buyExamPin({
//     required String userId,
//     required double amount,
//     required int examName,
//     required int quantity,
//     required String requestId,
//   }) async {
//     try {
//       final response = await apiClient.post(
//         '${ApiUrl.gsubz_transaction}/buy-exam-pin',
//         data: jsonEncode({
//           'user_id': userId,
//           'amount': amount,
//           'exam_name': examName,
//           'quantity': quantity,
//           'request_id': requestId,
//         }),
//       );

//       if (response.data['status'] == "success") {
//         return response.data['data'];
//       }
//     } on DioException catch (e) {
//       if (e.response?.data['message'] != null) {
//         throw AppException(e.response?.data['message']);
//       }
//       throw AppException(DioErrorHandler.handleDioError(e));
//     } catch (e) {
//       throw AppException(e.toString());
//     }
//     return null;
//   }

//   /// Verify transaction status
//   Future<Map<String, dynamic>> verifyTransaction(String transactionId) async {
//     try {
//       final response = await apiClient.get(
//         '${ApiUrl.gsubz_transaction}/verify-transaction?transaction_id=$transactionId',
//       );

//       if (response.data['status'] == "success") {
//         return response.data['data'];
//       } else {
//         throw Exception(
//             'Failed to verify transaction: ${response.data['message']}');
//       }
//     } on DioException catch (e) {
//       throw AppException(DioErrorHandler.handleDioError(e));
//     } catch (e) {
//       throw AppException(e.toString());
//     }
//   }
// }
import 'dart:convert';
import 'package:royal/core/constants/api_url.dart';
import 'package:royal/core/errors/app_exception.dart';
import 'package:royal/core/errors/dio_error_handler.dart';
import 'package:dio/dio.dart';
import 'package:royal/api/api_client.dart';

class GsubzExamPinRepository {
  final DioClient apiClient;

  GsubzExamPinRepository() : apiClient = DioClient();

  /// Get exam pin plans for a specific service (waec, neco, nabteb)
  Future<Map<String, dynamic>> getExamPinPlans(String service) async {
    try {
      final response = await apiClient
          .get('${ApiUrl.gsubz_transaction}/exam-pin/plans?service=$service');

      return response.data;
    } on DioException catch (e) {
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  /// Purchase exam pin via Gsubz API
  Future<Map?> buyExamPin({
    required String userId,
    required double amount,
    required String serviceID,
    required String plan,
    required String phone,
    required String requestID,
  }) async {
    try {
      final response = await apiClient.post(
        '${ApiUrl.gsubz_transaction}/exam-pin/buy',
        data: jsonEncode({
          'user_id': userId,
          'amount': amount,
          'serviceID': serviceID,
          'plan': plan,
          'phone': phone,
          'requestID': requestID,
        }),
      );

      if (response.data['status'] == "success") {
        return response.data['data'];
      }
    } on DioException catch (e) {
      if (e.response?.data['message'] != null) {
        throw AppException(e.response?.data['message']);
      }
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException(e.toString());
    }
    return null;
  }

  /// Verify transaction status
  Future<Map<String, dynamic>> verifyTransaction(String transactionId) async {
    try {
      final response = await apiClient.get(
        '${ApiUrl.gsubz_transaction}/verify-transaction?transaction_id=$transactionId',
      );

      if (response.data['status'] == "success") {
        return response.data['data'];
      } else {
        throw Exception(
            'Failed to verify transaction: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
