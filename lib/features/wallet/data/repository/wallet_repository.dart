import 'package:royal/core/errors/dio_error_handler.dart';
import 'package:royal/core/utils/snackbar.dart';
import 'package:royal/features/wallet/data/model/wallet_transaction.dart';
import 'package:dio/dio.dart';
import 'package:royal/api/api_client.dart';
import 'package:royal/core/constants/api_url.dart';
import 'package:royal/core/errors/app_exception.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio; // For MultipartFile

class WalletRepository {
  final DioClient apiClient;

  WalletRepository() : apiClient = DioClient();

  Future<List<WalletTransactionModel>> walletTransaction() async {
    try {
      final response = await apiClient.get(ApiUrl.wallet_transactions);
      // Validate the status
      if (response.data['status'] != 'success') {
        throw AppException(
            'Failed to wallet transaction data ${response.data['message'] ?? 'Unknown error'}');
      }

      final List<dynamic> walletTransaction =
          response.data['data']['data'] as List<dynamic>? ?? [];

      return walletTransaction
          .map((json) =>
              WalletTransactionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException(
          "An unexpected error occurred while fetching wallet transanction");
    }
  }

  Future<bool> withdrawFunds(String url, Map body) async {
    try {
      final response = await apiClient.post(url, data: body);
      if (response.data['status'] == 'success') {
        return true;
      }

      return false;
    } on DioException catch (e) {
      if (e.response?.data['message'] != null) {
        throw AppException(e.response?.data['message']);
      }
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      print(e);
      throw AppException(
          "An unexpected error occurred while withdrawing, try again later");
    }
  }
}
