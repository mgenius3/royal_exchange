import 'package:royal/core/constants/routes.dart';
import 'package:royal/core/controllers/user_auth_details_controller.dart';
import 'package:royal/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:royal/core/states/mode.dart';

class HomeHeaderWidget extends StatelessWidget {
  HomeHeaderWidget({super.key});

  final LightningModeController lightningModeController =
      Get.find<LightningModeController>();
  final UserAuthDetailsController authController =
      Get.find<UserAuthDetailsController>();

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    if (hour < 20) return "Good Evening";
    return "Good Night";
  }

  IconData getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour < 12) return Icons.wb_sunny_rounded;
    if (hour < 17) return Icons.wb_sunny;
    if (hour < 20) return Icons.wb_twilight;
    return Icons.nights_stay;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.white, const Color(0xFFF9FAFB)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side - Profile and greeting
            Expanded(
              child: Row(
                children: [
                  // const SizedBox(width: 12),

                  Row(
                    children: [
                      // Settings button
                      GestureDetector(
                          onTap: () => Get.toNamed(RoutesConstant.profile),
                          child: CircleAvatar(
                            radius: 15, // Size of avatar
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage:
                                authController.user.value?.profilePictureUrl !=
                                        null
                                    ? NetworkImage(authController
                                        .user.value!.profilePictureUrl!)
                                    : null,
                            child: authController
                                        .user.value?.profilePictureUrl ==
                                    null
                                ? const Icon(Icons.person, color: Colors.white)
                                : null,
                          )),
                    ],
                  ),
                  const SizedBox(width: 10),

                  // Greeting Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Hi, ${authController.user.value?.name ?? "User"}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF111827),
                                  letterSpacing: -0.3,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '👋',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              getGreetingIcon(),
                              size: 14,
                              color: const Color(0xFF6B7280),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              getGreeting(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            GestureDetector(
                onTap: () => Get.toNamed(RoutesConstant.profileSecurity),
                child: const Icon(Icons.settings)),
          ],
        ),
      );
    });
  }
}
