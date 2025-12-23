import 'package:royal/api/api_client.dart';
import 'package:royal/core/constants/api_url.dart';
import 'package:royal/core/errors/app_exception.dart';
import 'package:royal/core/errors/dio_error_handler.dart';
import 'package:dio/dio.dart';
import 'package:royal/features/flight/data/model/flight_booking_model.dart';

class FlightBookingRepository {
  final DioClient apiClient;

  FlightBookingRepository() : apiClient = DioClient();

  // Create a new flight booking
  Future<FlightBooking> createBooking(FlightBooking booking) async {
    try {
      final response = await apiClient.post(
        ApiUrl.flight_bookings,
        data: booking.toJson(),
      );

      return FlightBooking.fromJson(response.data['data']);
    } on DioException catch (e) {
      final responseData = e.response?.data;

      if (responseData != null &&
          responseData['message'].toString().isNotEmpty) {
        throw AppException(
            "Booking creation failed. ${responseData['message']}");
      }
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException(
          "An unexpected error occurred during booking creation.");
    }
  }

  // Get all bookings for the authenticated user
  Future<List<FlightBooking>> getBookings({int page = 1}) async {
    try {
      final response = await apiClient.get(
        '${ApiUrl.flight_bookings}?page=${page}',
      );

      final bookingsData = response.data['data']['data'] as List;
      return bookingsData.map((json) => FlightBooking.fromJson(json)).toList();
    } on DioException catch (e) {
      final responseData = e.response?.data;

      if (responseData != null &&
          responseData['message'].toString().isNotEmpty) {
        throw AppException(
            "Failed to fetch bookings. ${responseData['message']}");
      }
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException(
          "An unexpected error occurred while fetching bookings.");
    }
  }

  // Get a specific booking by ID
  Future<FlightBooking> getBooking(int bookingId) async {
    try {
      final response = await apiClient.get(
        '${ApiUrl.flight_bookings}/$bookingId',
      );

      return FlightBooking.fromJson(response.data['data']);
    } on DioException catch (e) {
      final responseData = e.response?.data;

      if (responseData != null &&
          responseData['message'].toString().isNotEmpty) {
        throw AppException(
            "Failed to fetch booking. ${responseData['message']}");
      }
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException(
          "An unexpected error occurred while fetching booking.");
    }
  }

  // Cancel a booking
  Future<FlightBooking> cancelBooking(int bookingId) async {
    try {
      final response = await apiClient.patch(
        '${ApiUrl.flight_bookings}/$bookingId/cancel',
      );

      return FlightBooking.fromJson(response.data['data']);
    } on DioException catch (e) {
      final responseData = e.response?.data;

      if (responseData != null &&
          responseData['message'].toString().isNotEmpty) {
        throw AppException(
            "Failed to cancel booking. ${responseData['message']}");
      }
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException(
          "An unexpected error occurred while cancelling booking.");
    }
  }

  // // Admin: Get all bookings
  // Future<List<FlightBooking>> getAdminBookings(
  //     {String? status, int page = 1}) async {
  //   try {
  //     final response = await apiClient.get(
  //       ApiUrl.flight_bookings,
  //       queryParameters: {
  //         'page': page,
  //         if (status != null) 'status': status,
  //       },
  //     );

  //     final bookingsData = response.data['data']['data'] as List;
  //     return bookingsData.map((json) => FlightBooking.fromJson(json)).toList();
  //   } on DioException catch (e) {
  //     final responseData = e.response?.data;

  //     if (responseData != null &&
  //         responseData['message'].toString().isNotEmpty) {
  //       throw AppException(
  //           "Failed to fetch admin bookings. ${responseData['message']}");
  //     }
  //     throw AppException(DioErrorHandler.handleDioError(e));
  //   } catch (e) {
  //     if (e is AppException) rethrow;
  //     throw AppException(
  //         "An unexpected error occurred while fetching admin bookings.");
  //   }
  // }

  // // Admin: Update booking status
  // Future<FlightBooking> updateBookingStatus({
  //   required int bookingId,
  //   required String status,
  //   double? totalAmount,
  //   String? adminNotes,
  // }) async {
  //   try {
  //     final data = {
  //       'status': status,
  //       if (totalAmount != null) 'total_amount': totalAmount,
  //       if (adminNotes != null) 'admin_notes': adminNotes,
  //     };

  //     final response = await apiClient.patch(
  //       '${ApiUrl.flight_admin_update_status}/$bookingId/status',
  //       data: data,
  //     );

  //     return FlightBooking.fromJson(response.data['data']);
  //   } on DioException catch (e) {
  //     final responseData = e.response?.data;

  //     if (responseData != null &&
  //         responseData['message'].toString().isNotEmpty) {
  //       throw AppException(
  //           "Failed to update booking status. ${responseData['message']}");
  //     }
  //     throw AppException(DioErrorHandler.handleDioError(e));
  //   } catch (e) {
  //     if (e is AppException) rethrow;
  //     throw AppException(
  //         "An unexpected error occurred while updating booking status.");
  //   }
  // }


}
