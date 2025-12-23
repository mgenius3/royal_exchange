import 'package:royal/core/constants/routes.dart';
import 'package:royal/core/theme/colors.dart';
import 'package:royal/core/utils/spacing.dart';
import 'package:royal/core/controllers/primary_button_controller.dart';
import 'package:royal/core/models/primary_button_model.dart';
import 'package:royal/core/models/top_header_model.dart';
import 'package:royal/core/widgets/primary_button_widget.dart';
import 'package:royal/core/widgets/top_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class GsubzExamPinReceiptScreen extends StatelessWidget {
  const GsubzExamPinReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>;

    // Extract data with fallbacks
    final examName = data['exam_name']?.toString().toUpperCase() ??
        data['serviceID']?.toString().toUpperCase() ??
        'Exam PIN';
    final quantity = data['quantity'] ?? 1;
    final amount = data['amount']?.toString() ?? '0';
    final transactionID = data['transactionID']?.toString() ?? 'N/A';
    final phone = data['phone'] ?? 'N/A';

    // Parse PINs - handle both array and string formats
    List<Map<String, dynamic>> pinsList = [];

    if (data['pins'] != null) {
      final pinsData = data['pins'];

      if (pinsData is List && pinsData.isNotEmpty) {
        // Already a list of pin objects
        pinsList = pinsData
            .map((pin) {
              if (pin is Map) {
                return {
                  'pin': pin['pin']?.toString() ?? '',
                  'serial': pin['serial']?.toString(),
                };
              }
              return {'pin': pin.toString(), 'serial': null};
            })
            .toList()
            .cast<Map<String, dynamic>>();
      } else if (pinsData is String && pinsData.isNotEmpty) {
        // Single PIN as string
        pinsList = [
          {'pin': pinsData, 'serial': null}
        ];
      }
    }

    // If no pins in 'pins' field, check 'response.api_response'
    if (pinsList.isEmpty && data['response'] != null) {
      final response = data['response'] as Map<String, dynamic>?;
      if (response != null && response['api_response'] != null) {
        final apiResponse = response['api_response'];

        if (apiResponse is String && apiResponse.trim().isNotEmpty) {
          pinsList = [
            {'pin': apiResponse.trim(), 'serial': null}
          ];
        } else if (apiResponse is List) {
          pinsList = apiResponse
              .map((pin) {
                if (pin is Map) {
                  return {
                    'pin':
                        pin['pin']?.toString() ?? pin['PIN']?.toString() ?? '',
                    'serial':
                        pin['serial']?.toString() ?? pin['sn']?.toString(),
                  };
                }
                return {'pin': pin.toString(), 'serial': null};
              })
              .toList()
              .cast<Map<String, dynamic>>();
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: Spacing.defaultMarginSpacing,
          child: Column(
            children: [
              const TopHeaderWidget(
                data: TopHeaderModel(title: 'Exam PIN Receipt'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // _buildSuccessCard(),
                      // const SizedBox(height: 16),
                      _buildSummaryCard(examName, quantity, amount),
                      const SizedBox(height: 16),
                      _buildDetailsCard(data, amount, transactionID, phone),
                      const SizedBox(height: 16),
                      _buildPinsCard(pinsList, examName),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              CustomPrimaryButton(
                controller: CustomPrimaryButtonController(
                  model: const CustomPrimaryButtonModel(text: 'Done'),
                  onPressed: () {
                    Get.offAllNamed(RoutesConstant.home);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade400,
            Colors.green.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'PINs Generated Successfully!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Your exam PINs are ready to use',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String examName, int quantity, String amount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Exam Board',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                examName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          // const SizedBox(height: 12),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       'Quantity',
          //       style: TextStyle(
          //         fontSize: 14,
          //         color: Colors.grey[600],
          //       ),
          //     ),
          //     Container(
          //       padding:
          //           const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          //       decoration: BoxDecoration(
          //         color: Colors.green.shade50,
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //       child: Text(
          //         '$quantity PIN(s)',
          //         style: TextStyle(
          //           fontSize: 14,
          //           fontWeight: FontWeight.w600,
          //           color: Colors.green.shade700,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Amount Paid',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '₦$amount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: DarkThemeColors.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(Map<String, dynamic> data, String amount,
      String transactionID, String phone) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: DarkThemeColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: DarkThemeColors.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Transaction Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                _buildDetailRow(
                  'Transaction ID',
                  transactionID,
                  Icons.confirmation_number_outlined,
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Phone Number',
                  phone,
                  Icons.phone_outlined,
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Status',
                  'Successful',
                  Icons.check_circle_outline,
                  isStatus: true,
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Transaction Date',
                  _formatDate(DateTime.parse(data['timestamp'])),
                  Icons.calendar_today_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinsCard(List<Map<String, dynamic>> pins, String examName) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: DarkThemeColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.pin_outlined,
                      color: DarkThemeColors.primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    pins.length > 1 ? 'Exam PINs' : 'Exam PIN',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (pins.isNotEmpty)
                InkWell(
                  onTap: () => _copyAllPins(pins),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: DarkThemeColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.copy_all,
                          size: 16,
                          color: DarkThemeColors.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          pins.length > 1 ? 'Copy All' : 'Copy',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: DarkThemeColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          if (pins.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'PIN not available in response',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...pins.asMap().entries.map((entry) {
              int index = entry.key;
              var pin = entry.value;
              return Column(
                children: [
                  _buildPinCard(
                    index + 1,
                    pin['pin']?.toString() ?? 'N/A',
                    pin['serial']?.toString(),
                    examName,
                  ),
                  if (index < pins.length - 1) const SizedBox(height: 12),
                ],
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildPinCard(
      int pinNumber, String pin, String? serial, String examName) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DarkThemeColors.primaryColor.withOpacity(0.1),
            DarkThemeColors.primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DarkThemeColors.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                serial != null ? 'PIN $pinNumber' : 'PIN',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: DarkThemeColors.primaryColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: DarkThemeColors.primaryColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  examName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildPinRow('PIN', pin),
          if (serial != null && serial.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildPinRow('Serial', serial),
          ],
        ],
      ),
    );
  }

  Widget _buildPinRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'monospace',
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () => _copyToClipboard(value, label),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: DarkThemeColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.copy,
              size: 16,
              color: DarkThemeColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon,
      {bool isStatus = false}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isStatus ? Colors.green : Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isStatus ? Colors.green : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Copied',
      '$label copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  void _copyAllPins(List<Map<String, dynamic>> pins) {
    String allPins = pins.asMap().entries.map((entry) {
      int index = entry.key;
      var pin = entry.value;
      String result = pins.length > 1
          ? 'PIN ${index + 1}: ${pin['pin']}'
          : 'PIN: ${pin['pin']}';

      if (pin['serial'] != null && pin['serial'].toString().isNotEmpty) {
        result += '\nSerial: ${pin['serial']}';
      }
      return result;
    }).join('\n\n');

    Clipboard.setData(ClipboardData(text: allPins));
    Get.snackbar(
      'Copied',
      pins.length > 1
          ? 'All PINs copied to clipboard'
          : 'PIN copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
