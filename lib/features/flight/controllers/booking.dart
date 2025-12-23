import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:royal/core/constants/routes.dart';
import 'package:royal/core/errors/error_mapper.dart';
import 'package:royal/core/errors/failure.dart';
import 'package:royal/core/utils/snackbar.dart';
import 'package:royal/features/flight/data/model/flight_booking_model.dart';
import 'package:royal/features/flight/data/repository/index.dart';
import 'package:royal/features/flight/presentation/screens/booking_history_screen.dart';

class FlightBookingController extends GetxController {
  // Trip type
  final RxString tripType = 'round-trip'.obs;

  // Airports
  final Rx<Airport?> departureAirport = Rx<Airport?>(null);
  final Rx<Airport?> arrivalAirport = Rx<Airport?>(null);

  // Dates
  final Rx<DateTime?> departureDate =
      Rx<DateTime?>(DateTime.now().add(Duration(days: 1)));
  final Rx<DateTime?> returnDate =
      Rx<DateTime?>(DateTime.now().add(Duration(days: 2)));

  // Passengers
  final RxInt adults = 1.obs;
  final RxInt teens = 0.obs;
  final RxInt children = 0.obs;
  final RxInt infants = 0.obs;

  // Flight preferences
  final RxString flightClass = 'economy'.obs;
  final RxString preferredAirline = ''.obs;
  final RxBool flexibleDates = false.obs;

  // Passenger details
  final RxList<PassengerDetails> passengers = <PassengerDetails>[].obs;

  // Loading and error states
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final errorMessage = ''.obs;

  // Booking history
  final RxList<FlightBooking> bookingHistory = <FlightBooking>[].obs;

  final FlightBookingRepository bookingRepository = FlightBookingRepository();

  @override
  void onInit() {
    super.onInit();

    // Initialize with 1 adult passenger
    _initializeDefaultPassenger();
    fetchBookingHistory();

    // Initialize first passenger
    ever(adults, (_) => updatePassengersList());
    ever(teens, (_) => updatePassengersList());
    ever(children, (_) => updatePassengersList());
    ever(infants, (_) => updatePassengersList());
  }

  void setTripType(String type) {
    tripType.value = type;
    if (type == 'one-way') {
      returnDate.value = null;
    } else if (returnDate.value == null) {
      returnDate.value = departureDate.value?.add(Duration(days: 1));
    }
  }

  void _initializeDefaultPassenger() {
    passengers.add(
      PassengerDetails(
        passengerType: 'adult',
        isPrimary: true, // first passenger is always primary/contact
      ),
    );
  }

  void setDepartureAirport(Airport airport) {
    departureAirport.value = airport;
  }

  void setArrivalAirport(Airport airport) {
    arrivalAirport.value = airport;
  }

  void swapAirports() {
    final temp = departureAirport.value;
    departureAirport.value = arrivalAirport.value;
    arrivalAirport.value = temp;
  }

  void setDepartureDate(DateTime date) {
    departureDate.value = date;
    // Auto-adjust return date if needed
    if (returnDate.value != null && returnDate.value!.isBefore(date)) {
      returnDate.value = date.add(const Duration(days: 1));
    }
  }

  void setReturnDate(DateTime date) {
    returnDate.value = date;
  }

  void incrementPassenger(String type) {
    switch (type) {
      case 'adults':
        if (adults.value < 9) adults.value++;
        break;
      case 'teens':
        if (teens.value < 9) teens.value++;
        break;
      case 'children':
        if (children.value < 9) children.value++;
        break;
      case 'infants':
        if (infants.value < 9 && infants.value < adults.value) infants.value++;
        break;
    }
  }

  void decrementPassenger(String type) {
    switch (type) {
      case 'adults':
        if (adults.value > 1) adults.value--;
        // Adjust infants if needed
        if (infants.value > adults.value) infants.value = adults.value;
        break;
      case 'teens':
        if (teens.value > 0) teens.value--;
        break;
      case 'children':
        if (children.value > 0) children.value--;
        break;
      case 'infants':
        if (infants.value > 0) infants.value--;
        break;
    }
  }

  int get totalPassengers =>
      adults.value + teens.value + children.value + infants.value;

  void setFlightClass(String classType) {
    flightClass.value = classType;
  }

  void updatePassengersList() {
    final totalNeeded =
        adults.value + teens.value + children.value + infants.value;

    if (passengers.length < totalNeeded) {
      // Add more passengers
      for (int i = passengers.length; i < totalNeeded; i++) {
        String type;
        if (i < adults.value) {
          type = 'adult';
        } else if (i < adults.value + teens.value) {
          type = 'teen';
        } else if (i < adults.value + teens.value + children.value) {
          type = 'child';
        } else {
          type = 'infant';
        }

        passengers.add(PassengerDetails(
          passengerType: type,
          isPrimary: i == 0,
        ));
      }
    } else if (passengers.length > totalNeeded) {
      // Remove extra passengers
      passengers.value = passengers.sublist(0, totalNeeded);
    }
  }

  void updatePassenger(int index, PassengerDetails details) {
    if (index < passengers.length) {
      passengers[index] = details;
    }
  }

  // Validate booking details
  bool validateBookingDetails() {
    if (departureAirport.value == null) {
      showSnackbar("Error", "Please select departure airport");
      return false;
    }

    if (arrivalAirport.value == null) {
      showSnackbar("Error", "Please select arrival airport");
      return false;
    }

    if (departureDate.value == null) {
      showSnackbar("Error", "Please select departure date");
      return false;
    }

    if (tripType.value == 'round-trip' && returnDate.value == null) {
      showSnackbar("Error", "Please select return date");
      return false;
    }

    return true;
  }

  // Validate passenger details
  bool validatePassengerDetails() {
    for (int i = 0; i < passengers.length; i++) {
      final passenger = passengers[i];

      if (passenger.fullName.isEmpty) {
        showSnackbar("Error", "Please enter full name for passenger ${i + 1}");
        return false;
      }

      if (passenger.dateOfBirth == null) {
        showSnackbar(
            "Error", "Please select date of birth for passenger ${i + 1}");
        return false;
      }

      if (passenger.isPrimary && passenger.email.isEmpty) {
        showSnackbar("Error", "Please enter email for primary passenger");
        return false;
      }

      if (passenger.isPrimary && passenger.phone.isEmpty) {
        showSnackbar("Error", "Please enter phone for primary passenger");
        return false;
      }
    }
    return true;
  }

  // Submit flight booking
  Future<void> submitBooking() async {
    if (!validateBookingDetails() || !validatePassengerDetails()) return;

    isSubmitting.value = true;
    errorMessage.value = '';

    try {
      final booking = FlightBooking(
        tripType: tripType.value,
        departureAirport: departureAirport.value!.code,
        departureCity: departureAirport.value!.city,
        arrivalAirport: arrivalAirport.value!.code,
        arrivalCity: arrivalAirport.value!.city,
        departureDate: departureDate.value!,
        returnDate: returnDate.value,
        adults: adults.value,
        teens: teens.value,
        children: children.value,
        infants: infants.value,
        preferredAirline:
            preferredAirline.value.isNotEmpty ? preferredAirline.value : null,
        flightClass: flightClass.value,
        flexibleDates: flexibleDates.value,
        passengers: passengers
            .map((p) => FlightPassenger(
                fullName: p.fullName,
                gender: p.gender,
                dateOfBirth: p.dateOfBirth!,
                nationality: p.nationality,
                passengerType: p.passengerType,
                email: p.email.isNotEmpty ? p.email : null,
                phone: p.phone.isNotEmpty ? p.phone : null,
                isPrimary: p.isPrimary))
            .toList(),
      );

      // Call repository
      final response = await bookingRepository.createBooking(booking);

      showSnackbar("Success",
          "Flight booking submitted successfully! Reference: ${response.bookingReference}",
          isError: false);

      // Reset form
      resetForm();

      await fetchBookingHistory();

      // Navigate to booking details
      // Get.off(() => BookingDe(booking: response));
      Get.offNamed(RoutesConstant.flight_booking_history);
    } catch (e) {
      // Handle error
      Failure failure = ErrorMapper.map(e as Exception);
      errorMessage.value = failure.message;
      showSnackbar("Error", failure.message);
    } finally {
      isSubmitting.value = false;
    }
  }

  // Fetch booking history
  Future<void> fetchBookingHistory() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final bookings = await bookingRepository.getBookings();
      bookingHistory.value = bookings;
    } catch (e) {
      // Handle error
      Failure failure = ErrorMapper.map(e as Exception);
      errorMessage.value = failure.message;
      // showSnackbar("Error", failure.message);
    } finally {
      isLoading.value = false;
    }
  }

  // Get specific booking
  Future<FlightBooking?> getBooking(int bookingId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final booking = await bookingRepository.getBooking(bookingId);
      return booking;
    } catch (e) {
      // Handle error
      Failure failure = ErrorMapper.map(e as Exception);
      errorMessage.value = failure.message;
      showSnackbar("Error", failure.message);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Cancel booking
  Future<void> cancelBooking(int bookingId) async {
    isSubmitting.value = true;
    errorMessage.value = '';

    try {
      await bookingRepository.cancelBooking(bookingId);

      showSnackbar(
        "Success",
        "Booking cancelled successfully",
        isError: false,
      );

      // Refresh booking history
      await fetchBookingHistory();
    } catch (e) {
      // Handle error
      Failure failure = ErrorMapper.map(e as Exception);
      errorMessage.value = failure.message;
      showSnackbar("Error", failure.message);
    } finally {
      isSubmitting.value = false;
    }
  }

  // Get admin bookings
  // Future<void> fetchAdminBookings({String? status}) async {
  //   isLoading.value = true;
  //   errorMessage.value = '';

  //   try {
  //     final bookings =
  //         await bookingRepository.getAdminBookings(status: status);
  //     bookingHistory.value = bookings;
  //   } catch (e) {
  //     // Handle error
  //     Failure failure = ErrorMapper.map(e as Exception);
  //     errorMessage.value = failure.message;
  //     showSnackbar("Error", failure.message);
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // // Update booking status (admin)
  // Future<void> updateBookingStatus({
  //   required int bookingId,
  //   required String status,
  //   double? totalAmount,
  //   String? adminNotes,
  // }) async {
  //   isSubmitting.value = true;
  //   errorMessage.value = '';

  //   try {
  //     await bookingRepository.updateBookingStatus(
  //       bookingId: bookingId,
  //       status: status,
  //       totalAmount: totalAmount,
  //       adminNotes: adminNotes,
  //     );

  //     showSnackbar(
  //       "Success",
  //       "Booking status updated successfully",
  //       isError: false,
  //     );

  //     // Refresh booking history
  //     await fetchAdminBookings();
  //   } catch (e) {
  //     // Handle error
  //     Failure failure = ErrorMapper.map(e as Exception);
  //     errorMessage.value = failure.message;
  //     showSnackbar("Error", failure.message);
  //   } finally {
  //     isSubmitting.value = false;
  //   }
  // }

  // Reset form
  void resetForm() {
    tripType.value = 'round-trip';
    departureAirport.value = null;
    arrivalAirport.value = null;
    departureDate.value = DateTime.now().add(Duration(days: 1));
    returnDate.value = DateTime.now().add(Duration(days: 2));
    adults.value = 1;
    teens.value = 0;
    children.value = 0;
    infants.value = 0;
    flightClass.value = 'economy';
    preferredAirline.value = '';
    flexibleDates.value = false;
    passengers.clear();
    updatePassengersList();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class PassengerDetails {
  String fullName;
  String gender;
  DateTime? dateOfBirth;
  String nationality;
  String passengerType;
  String email;
  String phone;
  bool isPrimary;

  PassengerDetails({
    this.fullName = '',
    this.gender = 'male',
    this.dateOfBirth,
    this.nationality = '',
    required this.passengerType,
    this.email = '',
    this.phone = '',
    this.isPrimary = false,
  });
}
