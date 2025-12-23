import 'package:royal/core/theme/colors.dart';
import 'package:royal/core/states/mode.dart';
import 'package:royal/features/exam_pin/controller/gsubz_exam_pin_index_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExamPinSelectorWidget extends StatelessWidget {
  const ExamPinSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GsubzExamPinIndexController controller =
        Get.find<GsubzExamPinIndexController>();

    return Obx(() {
      // If all exams are still loading on first load
      final allLoading =
          controller.examMapping.every((exam) => exam['loading'] == true);

      if (allLoading && controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        );
      }

      return Column(
        children: controller.examMapping.asMap().entries.map((entry) {
          int index = entry.key;
          var exam = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < controller.examMapping.length - 1 ? 12 : 0,
            ),
            child: GestureDetector(
              onTap: () {
                if (exam['active'] == true) {
                  controller.setExam(index);
                }
              },
              child: ExamCard(
                examName: exam['name'],
                colorHex: exam['color'],
                price: exam['price'].toString(),
                isActive: exam['active'] as bool,
                isLoading: exam['loading'] as bool,
                isSelected: controller.selectedExam.value == index,
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}

class ExamCard extends StatelessWidget {
  final String examName;
  final String colorHex;
  final String price;
  final bool isActive;
  final bool isLoading;
  final bool isSelected;

  const ExamCard({
    super.key,
    required this.examName,
    required this.colorHex,
    required this.price,
    required this.isActive,
    required this.isLoading,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final LightningModeController lightningModeController =
        Get.find<LightningModeController>();
    final isLight = lightningModeController.currentMode.value.mode == "light";

    // Parse color from hex string
    final color = Color(int.parse(colorHex.replaceFirst('0x', '0xff')));

    // Calculate opacity for inactive state
    final double opacity = isActive ? 1.0 : 0.4;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isSelected && isActive
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  DarkThemeColors.primaryColor.withOpacity(0.15),
                  DarkThemeColors.primaryColor.withOpacity(0.08),
                ],
              )
            : null,
        color: isSelected && isActive
            ? null
            : (isLight ? Colors.white : const Color(0xFF1F2937))
                .withOpacity(opacity),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected && isActive
              ? DarkThemeColors.primaryColor
              : (isLight
                      ? const Color(0xFFE5E7EB)
                      : Colors.white.withOpacity(0.1))
                  .withOpacity(opacity),
          width: isSelected && isActive ? 2.5 : 1.0,
        ),
        boxShadow: [
          if (isSelected && isActive)
            BoxShadow(
              color: DarkThemeColors.primaryColor.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          else
            BoxShadow(
              color: Colors.black.withOpacity(isLight ? 0.06 : 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        children: [
          // Exam icon/badge
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(isActive ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: color,
                      ),
                    )
                  : Text(
                      examName.substring(0, 1),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: color.withOpacity(opacity),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          // Exam details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  examName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: (isSelected && isActive
                            ? DarkThemeColors.primaryColor
                            : (isLight
                                ? const Color(0xFF111827)
                                : Colors.white))
                        .withOpacity(opacity),
                  ),
                ),
                const SizedBox(height: 4),
                if (isLoading)
                  Text(
                    'Loading price...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  )
                else if (!isActive)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Currently Unavailable',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade700,
                      ),
                    ),
                  )
                else
                  Row(
                    children: [
                      Text(
                        '₦$price',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: (isSelected
                                  ? DarkThemeColors.primaryColor
                                  : color)
                              .withOpacity(opacity),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'per PIN',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Selection indicator
          if (isSelected && isActive)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: DarkThemeColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 20,
              ),
            )
          else if (!isActive)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline,
                color: Colors.grey.shade600,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}
