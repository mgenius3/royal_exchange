import 'package:royal/core/theme/colors.dart';
import 'package:royal/core/states/mode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:royal/features/exam_pin/controller/gsubz_exam_pin_index_controller.dart';

class GsubzExamTypeWidget extends StatelessWidget {
  const GsubzExamTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GsubzExamPinIndexController controller =
        Get.find<GsubzExamPinIndexController>();

    return Obx(() => Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.setExam(1),
                    child: ExamCard(
                      examName: 'WAEC',
                      price: controller.availableExams[1]!,
                      isSelected: controller.selectedExam.value == 1,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.setExam(2),
                    child: ExamCard(
                      examName: 'NECO',
                      price: controller.availableExams[2]!,
                      isSelected: controller.selectedExam.value == 2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.setExam(3),
                    child: ExamCard(
                      examName: 'NABTEB',
                      price: controller.availableExams[3]!,
                      isSelected: controller.selectedExam.value == 3,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.setExam(4),
                    child: ExamCard(
                      examName: 'JAMB',
                      price: controller.availableExams[4]!,
                      isSelected: controller.selectedExam.value == 4,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

class ExamCard extends StatelessWidget {
  final String examName;
  final double price;
  final bool isSelected;

  const ExamCard({
    super.key,
    required this.examName,
    required this.price,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final LightningModeController lightningModeController =
        Get.find<LightningModeController>();

    return Obx(() {
      final isLight =
          lightningModeController.currentMode.value.mode == "light";

      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    DarkThemeColors.primaryColor.withOpacity(0.15),
                    DarkThemeColors.primaryColor.withOpacity(0.08),
                  ],
                )
              : null,
          color: isSelected
              ? null
              : (isLight ? Colors.white : const Color(0xFF1F2937)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? DarkThemeColors.primaryColor
                : (isLight
                    ? const Color(0xFFE5E7EB)
                    : Colors.white.withOpacity(0.1)),
            width: isSelected ? 2.5 : 1.0,
          ),
          boxShadow: [
            if (isSelected)
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
        child: Column(
          children: [
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: DarkThemeColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            if (isSelected) const SizedBox(height: 8),
            Icon(
              Icons.school_rounded,
              size: 36,
              color: isSelected
                  ? DarkThemeColors.primaryColor
                  : (isLight ? Colors.grey[600] : Colors.grey[400]),
            ),
            const SizedBox(height: 10),
            Text(
              examName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? DarkThemeColors.primaryColor
                    : (isLight
                        ? const Color(0xFF111827)
                        : Colors.white),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '₦${price.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isLight
                    ? const Color(0xFF6B7280)
                    : Colors.grey[400],
              ),
            ),
          ],
        ),
      );
    });
  }
}