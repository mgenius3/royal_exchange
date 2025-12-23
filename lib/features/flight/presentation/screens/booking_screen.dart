import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:royal/core/theme/colors.dart';
import 'package:royal/features/flight/controllers/booking.dart';
import 'package:royal/features/flight/data/model/flight_booking_model.dart';
import 'package:royal/features/flight/presentation/screens/passenger_details_screen.dart';

class FlightBookingScreen extends StatelessWidget {
  final FlightBookingController controller = Get.put(FlightBookingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Flight',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trip Type Selector
              _buildTripTypeSelector(),
              const SizedBox(height: 24),

              // From Airport
              _buildAirportField(
                label: 'From',
                selectedAirport: controller.departureAirport,
                onTap: () => _showAirportPicker(context, isFrom: true),
              ),
              const SizedBox(height: 16),
              // Swap Button
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: controller.swapAirports,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: LightThemeColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.swap_vert,
                          color: Colors.white, size: 28),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // To Airport
              _buildAirportField(
                label: 'To',
                selectedAirport: controller.arrivalAirport,
                onTap: () => _showAirportPicker(context, isFrom: false),
              ),
              const SizedBox(height: 24),

              // Dates
              Obx(() {
                if (controller.tripType.value == 'round-trip') {
                  return Row(
                    children: [
                      Expanded(
                        child: _buildDateField(
                          label: 'Leaving Date',
                          date: controller.departureDate.value,
                          onTap: () => _selectDate(context, true),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildDateField(
                          label: 'Return Date',
                          date: controller.returnDate.value,
                          onTap: () => _selectDate(context, false),
                        ),
                      ),
                    ],
                  );
                } else {
                  return _buildDateField(
                    label: 'Leaving Date',
                    date: controller.departureDate.value,
                    onTap: () => _selectDate(context, true),
                  );
                }
              }),
              
              const SizedBox(height: 24),

              // Class and Passengers
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      label: 'Select Class',
                      value: controller.flightClass,
                      items: [
                        {'value': 'economy', 'label': 'Economy'},
                        {
                          'value': 'premium-economy',
                          'label': 'Premium Economy'
                        },
                        {'value': 'business', 'label': 'Business'},
                        {'value': 'first-class', 'label': 'First Class'},
                      ],
                      onChanged: controller.setFlightClass,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildPassengersField(context),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.validateBookingDetails()) {
                      Get.to(() => PassengerDetailsScreen());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LightThemeColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripTypeSelector() {
    return Obx(() => Row(
          children: [
            Expanded(
              child: _buildTripTypeButton(
                'One way',
                'one-way',
                controller.tripType.value == 'one-way',
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildTripTypeButton(
                'Round Trip',
                'round-trip',
                controller.tripType.value == 'round-trip',
              ),
            ),
          ],
        ));
  }

  Widget _buildTripTypeButton(String label, String value, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.setTripType(value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? LightThemeColors.primaryColor.withOpacity(0.2)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? LightThemeColors.primaryColor
                : const Color.fromARGB(255, 214, 211, 211),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? LightThemeColors.primaryColor : Colors.black,
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAirportField({
    required String label,
    required Rx<Airport?> selectedAirport,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        SizedBox(height: 8),
        Obx(() => GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: LightThemeColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade800),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedAirport.value != null
                            ? '${selectedAirport.value!.city} (${selectedAirport.value!.code})'
                            : 'Select airport',
                        style: TextStyle(
                          color: selectedAirport.value != null
                              ? Colors.black
                              : Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: LightThemeColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date != null
                        ? DateFormat('EEE, d MMM').format(date)
                        : 'Select date',
                    style: TextStyle(
                      color: date != null ? Colors.black : Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(Icons.calendar_today,
                    color: Colors.grey.shade600, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required RxString value,
    required List<Map<String, String>> items,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        SizedBox(height: 8),
        Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: LightThemeColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value.value,
                  isExpanded: true,
                  dropdownColor: LightThemeColors.background,
                  icon:
                      Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  items: items.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['value'],
                      child: Text(item['label']!),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) onChanged(newValue);
                  },
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildPassengersField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Passengers',
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        SizedBox(height: 8),
        Obx(() => GestureDetector(
              onTap: () => _showPassengerPicker(context),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: LightThemeColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade800),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${controller.totalPassengers}',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  void _showAirportPicker(BuildContext context, {required bool isFrom}) {
    // Sample airports - replace with your actual data
    final airports = [
      Airport(code: 'LOS', city: 'Lagos', country: 'Nigeria'),
      Airport(code: 'ABV', city: 'Abuja', country: 'Nigeria'),
      Airport(code: 'BNI', city: 'Benin', country: 'Nigeria'),
      Airport(code: 'PHC', city: 'Port Harcourt', country: 'Nigeria'),
      Airport(code: 'KAN', city: 'Kano', country: 'Nigeria'),
      Airport(code: 'DXB', city: 'Dubai', country: 'UAE'),
      Airport(code: 'LHR', city: 'London', country: 'UK'),
      Airport(code: 'JFK', city: 'New York', country: 'USA'),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: LightThemeColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 16),
            Text(
              isFrom ? 'Select Departure Airport' : 'Select Arrival Airport',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: airports.length,
                itemBuilder: (context, index) {
                  final airport = airports[index];
                  return ListTile(
                    title: Text(
                      '${airport.city} (${airport.code})',
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      airport.country,
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                    onTap: () {
                      if (isFrom) {
                        controller.setDepartureAirport(airport);
                      } else {
                        controller.setArrivalAirport(airport);
                      }
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate(BuildContext context, bool isDeparture) async {
    final initialDate = isDeparture
        ? (controller.departureDate.value ??
            DateTime.now().add(Duration(days: 1)))
        : (controller.returnDate.value ??
            DateTime.now().add(Duration(days: 2)));

    final firstDate = isDeparture
        ? DateTime.now()
        : (controller.departureDate.value ?? DateTime.now())
            .add(Duration(days: 1));

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: LightThemeColors.primaryColor,
              onPrimary: LightThemeColors.background,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (isDeparture) {
        controller.setDepartureDate(pickedDate);
      } else {
        controller.setReturnDate(pickedDate);
      }
    }
  }

  void _showPassengerPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: LightThemeColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 16),
            const Text(
              'Passengers',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            _buildPassengerCounter('Adults', 'adults', '12+ years'),
            _buildPassengerCounter('Teens', 'teens', '12-17 years'),
            _buildPassengerCounter('Children', 'children', '2-11 years'),
            _buildPassengerCounter('Infants', 'infants', 'Under 2 years'),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: LightThemeColors.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerCounter(String label, String type, String subtitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => controller.decrementPassenger(type),
                icon: Icon(Icons.remove_circle_outline,
                    color: LightThemeColors.primaryColor),
              ),
              Obx(() {
                int count;
                switch (type) {
                  case 'adults':
                    count = controller.adults.value;
                    break;
                  case 'teens':
                    count = controller.teens.value;
                    break;
                  case 'children':
                    count = controller.children.value;
                    break;
                  case 'infants':
                    count = controller.infants.value;
                    break;
                  default:
                    count = 0;
                }
                return Container(
                  width: 40,
                  child: Center(
                    child: Text(
                      '$count',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                );
              }),
              IconButton(
                onPressed: () => controller.incrementPassenger(type),
                icon: Icon(Icons.add_circle_outline,
                    color: LightThemeColors.primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
