import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:royal/core/theme/colors.dart';
import 'package:royal/features/flight/controllers/booking.dart';

class PassengerDetailsScreen extends StatelessWidget {
  final FlightBookingController controller = Get.find();

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
          'Passenger Details',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.passengers.length,
                  itemBuilder: (context, index) {
                    return _buildPassengerForm(context, index);
                  },
                )),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildPassengerForm(BuildContext context, int index) {
    final passenger = controller.passengers[index];
    final passengerNumber = index + 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LightThemeColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromARGB(255, 241, 237, 237)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Passenger $passengerNumber',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: LightThemeColors.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  passenger.passengerType.toUpperCase(),
                  style: TextStyle(
                    color: LightThemeColors.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (passenger.isPrimary)
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Primary Passenger',
                style: TextStyle(
                    color: LightThemeColors.primaryColor, fontSize: 12),
              ),
            ),
          SizedBox(height: 16),

          // Full Name
          _buildTextField(
            label: 'Full Name (as on passport/ID)',
            initialValue: passenger.fullName,
            onChanged: (value) {
              passenger.fullName = value;
              controller.updatePassenger(index, passenger);
            },
          ),
          const SizedBox(height: 16),

          // Gender
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Gender',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildGenderButton(
                      'Male',
                      passenger.gender == 'male',
                      () {
                        passenger.gender = 'male';
                        controller.updatePassenger(index, passenger);
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildGenderButton(
                      'Female',
                      passenger.gender == 'female',
                      () {
                        passenger.gender = 'female';
                        controller.updatePassenger(index, passenger);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Date of Birth
          _buildDateOfBirthField(context, passenger, index),
          const SizedBox(height: 16),
          // Nationality
          _buildTextField(
            label: 'Nationality (Optional)',
            initialValue: passenger.nationality,
            onChanged: (value) {
              passenger.nationality = value;
              controller.updatePassenger(index, passenger);
            },
          ),

          // Contact fields for primary passenger
          if (passenger.isPrimary) ...[
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Email Address',
              initialValue: passenger.email,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                passenger.email = value;
                controller.updatePassenger(index, passenger);
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Phone Number',
              initialValue: passenger.phone,
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                passenger.phone = value;
                controller.updatePassenger(index, passenger);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.black, fontSize: 16),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade800),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade800),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: LightThemeColors.primaryColor),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildGenderButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? LightThemeColors.primaryColor.withOpacity(0.2)
              : Colors.grey[200],
          border: Border.all(
            color: isSelected
                ? LightThemeColors.primaryColor
                : const Color.fromARGB(255, 226, 224, 224),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? LightThemeColors.primaryColor
                  : Colors.grey.shade400,
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateOfBirthField(
      BuildContext context, PassengerDetails passenger, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date of Birth',
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final maxDate = DateTime.now();
            final minDate = DateTime.now().subtract(Duration(days: 365 * 100));
            final initialDate = passenger.dateOfBirth ??
                DateTime.now().subtract(const Duration(days: 365 * 25));
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: minDate,
              lastDate: maxDate,
              builder: (context, child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: ColorScheme.light(
                        primary: LightThemeColors.primaryColor,
                        onPrimary: Colors.black,
                        surface: Colors.white,
                        onSurface: Colors.black),
                  ),
                  child: child!,
                );
              },
            );

            if (pickedDate != null) {
              passenger.dateOfBirth = pickedDate;
              controller.updatePassenger(index, passenger);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: const Color.fromARGB(255, 130, 129, 129)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    passenger.dateOfBirth != null
                        ? DateFormat('MMM dd, yyyy')
                            .format(passenger.dateOfBirth!)
                        : 'Select date of birth',
                    style: TextStyle(
                      color: passenger.dateOfBirth != null
                          ? Colors.black
                          : Colors.grey.shade600,
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

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            top: BorderSide(color: const Color.fromARGB(255, 230, 227, 227))),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Flight Preferences (Optional)
            ExpansionTile(
              title: Text(
                'Flight Preferences (Optional)',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              iconColor: Colors.black,
              collapsedIconColor: Colors.black,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      _buildTextField(
                        label: 'Preferred Airline',
                        initialValue: controller.preferredAirline.value,
                        onChanged: (value) =>
                            controller.preferredAirline.value = value,
                      ),
                      SizedBox(height: 16),
                      Obx(() => CheckboxListTile(
                            title: const Text(
                              'My travel dates are flexible',
                              style: TextStyle(color: Colors.black),
                            ),
                            value: controller.flexibleDates.value,
                            onChanged: (value) =>
                                controller.flexibleDates.value = value ?? false,
                            activeColor: LightThemeColors.primaryColor,
                            checkColor: Colors.white,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Submit Button
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : controller.submitBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LightThemeColors.primaryColor,
                      disabledBackgroundColor: Colors.grey.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: controller.isSubmitting.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Submit Booking',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
