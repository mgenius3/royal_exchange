class FlightBooking {
  final int? id;
  final String? bookingReference;
  final String tripType;
  final String departureAirport;
  final String departureCity;
  final String arrivalAirport;
  final String arrivalCity;
  final DateTime departureDate;
  final DateTime? returnDate;
  final int adults;
  final int teens;
  final int children;
  final int infants;
  final String? preferredAirline;
  final String flightClass;
  final bool flexibleDates;
  final double? totalAmount;
  final String? currency;
  final String? status;
  final List<FlightPassenger> passengers;
  final DateTime? createdAt;

  FlightBooking({
    this.id,
    this.bookingReference,
    required this.tripType,
    required this.departureAirport,
    required this.departureCity,
    required this.arrivalAirport,
    required this.arrivalCity,
    required this.departureDate,
    this.returnDate,
    required this.adults,
    this.teens = 0,
    this.children = 0,
    this.infants = 0,
    this.preferredAirline,
    required this.flightClass,
    this.flexibleDates = false,
    this.totalAmount,
    this.currency,
    this.status,
    this.passengers = const [],
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'trip_type': tripType,
      'departure_airport': departureAirport,
      'departure_city': departureCity,
      'arrival_airport': arrivalAirport,
      'arrival_city': arrivalCity,
      'departure_date': departureDate.toIso8601String().split('T')[0],
      'return_date': returnDate?.toIso8601String().split('T')[0],
      'adults': adults,
      'teens': teens,
      'children': children,
      'infants': infants,
      'preferred_airline': preferredAirline,
      'class': flightClass,
      'flexible_dates': flexibleDates,
      'passengers': passengers.map((p) => p.toJson()).toList(),
    };
  }

  factory FlightBooking.fromJson(Map<String, dynamic> json) {
    return FlightBooking(
      id: json['id'],
      bookingReference: json['booking_reference'],
      tripType: json['trip_type'],
      departureAirport: json['departure_airport'],
      departureCity: json['departure_city'],
      arrivalAirport: json['arrival_airport'],
      arrivalCity: json['arrival_city'],
      departureDate: DateTime.parse(json['departure_date']),
      returnDate: json['return_date'] != null ? DateTime.parse(json['return_date']) : null,
      adults: json['adults'],
      teens: json['teens'] ?? 0,
      children: json['children'] ?? 0,
      infants: json['infants'] ?? 0,
      preferredAirline: json['preferred_airline'],
      flightClass: json['class'],
      flexibleDates: json['flexible_dates'] ?? false,
      totalAmount: json['total_amount'] != null ? double.parse(json['total_amount'].toString()) : null,
      currency: json['currency'],
      status: json['status'],
      passengers: (json['passengers'] as List?)
              ?.map((p) => FlightPassenger.fromJson(p))
              .toList() ??
          [],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }
}

class FlightPassenger {
  final int? id;
  final String fullName;
  final String gender;
  final DateTime dateOfBirth;
  final String? nationality;
  final String passengerType;
  final String? email;
  final String? phone;
  final bool isPrimary;

  FlightPassenger({
    this.id,
    required this.fullName,
    required this.gender,
    required this.dateOfBirth,
    this.nationality,
    required this.passengerType,
    this.email,
    this.phone,
    this.isPrimary = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'gender': gender,
      'date_of_birth': dateOfBirth.toIso8601String().split('T')[0],
      'nationality': nationality,
      'passenger_type': passengerType,
      'email': email,
      'phone': phone,
      'is_primary': isPrimary,
    };
  }

  factory FlightPassenger.fromJson(Map<String, dynamic> json) {
    return FlightPassenger(
      id: json['id'],
      fullName: json['full_name'],
      gender: json['gender'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      nationality: json['nationality'],
      passengerType: json['passenger_type'],
      email: json['email'],
      phone: json['phone'],
      isPrimary: json['is_primary'] ?? false,
    );
  }
}

class Airport {
  final String code;
  final String city;
  final String country;

  Airport({
    required this.code,
    required this.city,
    required this.country,
  });
}