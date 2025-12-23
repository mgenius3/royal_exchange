import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:royal/core/theme/colors.dart';
import 'package:royal/features/flight/controllers/booking.dart';
import 'package:royal/features/flight/data/model/flight_booking_model.dart';
import 'package:royal/features/flight/presentation/screens/booking_screen.dart';

class BookingHistoryScreen extends StatefulWidget {
  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  // late FlightBookingController controller;

  // @override
  // void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // controller = Get.find();
  //     controller.fetchBookingHistory(); // <-- Now safe to run here
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final FlightBookingController controller = Get.put(FlightBookingController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Get.back(),
        // ),
        title: const Text(
          'My Flight Bookings',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child:
                CircularProgressIndicator(color: LightThemeColors.primaryColor),
          );
        }

        if (controller.bookingHistory.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.flight_takeoff,
                    size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No bookings yet',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Your flight bookings will appear here',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchBookingHistory,
          color: LightThemeColors.primaryColor,
          backgroundColor: Colors.white,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.bookingHistory.length,
            itemBuilder: (context, index) {
              final booking = controller.bookingHistory[index];
              return _buildBookingCard(context, booking, controller);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => FlightBookingScreen()),
        backgroundColor: LightThemeColors.primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Booking', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, FlightBooking booking, FlightBookingController controller) {
    return GestureDetector(
      onTap: () => _showBookingDetails(context, booking, controller),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking.bookingReference ?? 'N/A',
                  style: TextStyle(
                    color: LightThemeColors.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusChip(booking.status ?? 'pending'),
              ],
            ),
            SizedBox(height: 16),

            // Route
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.departureAirport,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        booking.departureCity,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward, color: LightThemeColors.primaryColor),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        booking.arrivalAirport,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        booking.arrivalCity,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Dates
            Row(
              children: [
                Icon(Icons.calendar_today,
                    color: Colors.grey.shade400, size: 16),
                SizedBox(width: 8),
                Text(
                  DateFormat('EEE, MMM d, yyyy').format(booking.departureDate),
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                ),
                if (booking.returnDate != null) ...[
                  Text(
                    ' - ',
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                  Text(
                    DateFormat('EEE, MMM d, yyyy').format(booking.returnDate!),
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ],
              ],
            ),
            SizedBox(height: 8),

            // Passengers and Class
            Row(
              children: [
                Icon(Icons.people, color: Colors.grey.shade400, size: 16),
                SizedBox(width: 8),
                Text(
                  '${booking.adults + booking.teens + booking.children + booking.infants} Passenger${(booking.adults + booking.teens + booking.children + booking.infants) > 1 ? 's' : ''}',
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                ),
                SizedBox(width: 16),
                Icon(Icons.airline_seat_recline_normal,
                    color: Colors.grey.shade400, size: 16),
                SizedBox(width: 8),
                Text(
                  booking.flightClass
                      .split('-')
                      .map((word) => word[0].toUpperCase() + word.substring(1))
                      .join(' '),
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ],
            ),

            // Amount if available
            if (booking.totalAmount != null) ...[
              SizedBox(height: 12),
              Divider(color: Colors.grey.shade200),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  Text(
                    '${booking.currency ?? 'NGN'} ${NumberFormat('#,##0.00').format(booking.totalAmount)}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'confirmed':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'processing':
        color = LightThemeColors.primaryColor;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      case 'completed':
        color = Colors.purple;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showBookingDetails(BuildContext context, FlightBooking booking, FlightBookingController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Booking Details',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildStatusChip(booking.status ?? 'pending'),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Reference: ${booking.bookingReference ?? 'N/A'}',
                style: TextStyle(
                    color: LightThemeColors.primaryColor, fontSize: 16),
              ),
              SizedBox(height: 24),

              // Flight Information
              _buildDetailSection(
                'Flight Information',
                [
                  _buildDetailRow('From',
                      '${booking.departureCity} (${booking.departureAirport})'),
                  _buildDetailRow('To',
                      '${booking.arrivalCity} (${booking.arrivalAirport})'),
                  _buildDetailRow(
                      'Departure',
                      DateFormat('EEE, MMM d, yyyy')
                          .format(booking.departureDate)),
                  if (booking.returnDate != null)
                    _buildDetailRow(
                        'Return',
                        DateFormat('EEE, MMM d, yyyy')
                            .format(booking.returnDate!)),
                  _buildDetailRow(
                      'Trip Type',
                      booking.tripType
                          .split('-')
                          .map((word) =>
                              word[0].toUpperCase() + word.substring(1))
                          .join(' ')),
                  _buildDetailRow(
                      'Class',
                      booking.flightClass
                          .split('-')
                          .map((word) =>
                              word[0].toUpperCase() + word.substring(1))
                          .join(' ')),
                ],
              ),
              SizedBox(height: 24),

              // Passengers
              _buildDetailSection(
                'Passengers',
                [
                  if (booking.adults > 0)
                    _buildDetailRow('Adults', '${booking.adults}'),
                  if (booking.teens > 0)
                    _buildDetailRow('Teens', '${booking.teens}'),
                  if (booking.children > 0)
                    _buildDetailRow('Children', '${booking.children}'),
                  if (booking.infants > 0)
                    _buildDetailRow('Infants', '${booking.infants}'),
                ],
              ),
              SizedBox(height: 24),

              // Passenger Details
              if (booking.passengers.isNotEmpty) ...[
                _buildDetailSection(
                  'Passenger Details',
                  booking.passengers.map((p) {
                    return _buildPassengerInfo(p);
                  }).toList(),
                ),
                SizedBox(height: 24),
              ],

              // Payment Information
              if (booking.totalAmount != null) ...[
                _buildDetailSection(
                  'Payment Information',
                  [
                    _buildDetailRow(
                      'Total Amount',
                      '${booking.currency ?? 'NGN'} ${NumberFormat('#,##0.00').format(booking.totalAmount)}',
                    ),
                  ],
                ),
                SizedBox(height: 24),
              ],

              // Actions
              if (booking.status?.toLowerCase() == 'pending') ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _confirmCancellation(context, booking, controller);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel Booking',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerInfo(FlightPassenger passenger) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                passenger.fullName,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              if (passenger.isPrimary)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: LightThemeColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: LightThemeColors.primaryColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    'PRIMARY',
                    style: TextStyle(
                        color: LightThemeColors.primaryColor, fontSize: 10),
                  ),
                ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            '${passenger.gender.toUpperCase()} • ${passenger.passengerType.toUpperCase()} • ${DateFormat('MMM d, yyyy').format(passenger.dateOfBirth)}',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          if (passenger.email != null || passenger.phone != null) ...[
            SizedBox(height: 4),
            if (passenger.email != null)
              Text(
                passenger.email!,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            if (passenger.phone != null)
              Text(
                passenger.phone!,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
          ],
        ],
      ),
    );
  }

  void _confirmCancellation(BuildContext context, FlightBooking booking, FlightBookingController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Cancel Booking', style: TextStyle(color: Colors.black)),
        content: Text(
          'Are you sure you want to cancel this booking? This action cannot be undone.',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('No', style: TextStyle(color: Colors.grey.shade600)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.cancelBooking(booking.id!);
            },
            child: Text('Yes, Cancel', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
