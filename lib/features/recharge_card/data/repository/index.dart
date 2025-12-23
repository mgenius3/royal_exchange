import 'dart:convert';
import 'package:royal/api/api_client.dart';
import 'package:royal/core/constants/api_url.dart';
import 'package:dio/dio.dart';
import 'package:royal/core/constants/api_url.dart';
import 'package:royal/core/errors/app_exception.dart';
import 'package:royal/core/errors/dio_error_handler.dart';

class GsubzRechargeCardRepository {
  final DioClient apiClient;

  GsubzRechargeCardRepository() : apiClient = DioClient();

  /// Get available card denominations from Gsubz API
  Future<Map<String, dynamic>> getCardDenominations() async {
    try {
      final response = await apiClient.get(
        '${ApiUrl.gsubz_transaction}/recharge-card/denominations',
      );

      if (response.data['status'] == "success") {
        return response.data['data'];
      } else {
        throw Exception(
            'Failed to fetch card denominations: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  /// Generate recharge card pins via Gsubz API
  Future<Map?> generateRechargeCard({
    required String userId,
    required double amount,
    required String network,
    required String value,
    required int number,
    required String requestID,
  }) async {
    try {
      final response = await apiClient.post(
        '${ApiUrl.gsubz_transaction}/recharge-card/generate',
        data: jsonEncode({
          'user_id': userId,
          'amount': amount,
          'network': network,
          'value': value,
          'number': number,
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
}
