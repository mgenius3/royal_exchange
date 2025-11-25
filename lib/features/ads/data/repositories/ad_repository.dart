import 'package:royal/core/errors/dio_error_handler.dart';
import 'package:royal/features/ads/data/models/ad_model.dart';
import 'package:dio/dio.dart';
import 'package:royal/api/api_client.dart';
import 'package:royal/core/constants/api_url.dart';
import 'package:royal/core/errors/app_exception.dart';
// import 'package:royal/features/auth/data/models/otp_response.dart';
// import 'package:royal/features/auth/data/models/reset_password_request.dart';

class AdRepository {
  final DioClient apiClient;

  AdRepository() : apiClient = DioClient();

  Future<List<Ad>> fetchAds() async {
    List<Ad> ads = [];

    try {
      final response = await apiClient.get(ApiUrl.get_ads);
      ads = (response.data['data'] as List)
          .map((json) => Ad.fromJson(json))
          .toList()
          .where((ad) => ad.isActive)
          .toList();
      return ads;
    } on DioException catch (e) {
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException("An unexpected error occurred during fetching data.");
    }
  }
}
