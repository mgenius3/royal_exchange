import 'dart:convert';
import 'package:royal/core/constants/api_url.dart';
import 'package:royal/core/errors/app_exception.dart';
import 'package:royal/core/errors/dio_error_handler.dart';
import 'package:dio/dio.dart';
import 'package:royal/api/api_client.dart';

class GsubzDataRepository {
  final DioClient apiClient;

  GsubzDataRepository() : apiClient = DioClient();

  /// Get available data plans from Gsubz API
  Future<Map<String, dynamic>> getDataPlans(String serviceId) async {
    try {
      final response = await apiClient.get(
        '${ApiUrl.gsubz_transaction}/data-plans?service=$serviceId',
      );

      if (response.data['status'] == "success") {
        return response.data['data'];
      } else {
        throw Exception(
            'Failed to fetch data plans: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  /// Purchase data bundle via Gsubz API
  Future<Map?> buyData({
    required String userId,
    required double amount,
    required String mobileNumber,
    required String serviceID,
    required String plan,
    required String requestId,
  }) async {
    try {
      print("data");
      final response = await apiClient.post(
        '${ApiUrl.gsubz_transaction}/buy-data',
        data: jsonEncode({
          'user_id': userId,
          'amount': amount,
          'phone': mobileNumber,
          'serviceID': serviceID,
          'plan': plan,
          'requestID': requestId,
        }),
      );

      if (response.data['status'] == "success") {
        return response.data['data'];
      }
    } on DioException catch (e) {
      print(e.message);
      if (e.response?.data['message'] != null) {
        throw AppException(e.response?.data['message']);
      }
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      print(e.toString());
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
