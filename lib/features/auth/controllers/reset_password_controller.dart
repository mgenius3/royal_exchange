import 'package:royal/core/constants/routes.dart';
import 'package:royal/core/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:royal/features/auth/data/repositories/auth_repository.dart';

final isLoading = false.obs;

class ResetPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var obscurePassword = true.obs;
  final isLoading = false.obs;

  final AuthRepository authRepository = AuthRepository();

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> resetPassword() async {
    isLoading.value = true;
    try {
      if (emailController.text.isNotEmpty) {
        await authRepository.forgotPassword(emailController.text);
        Get.toNamed(RoutesConstant.otpverify,
            arguments: {"email": emailController.text});
      } else {
        showSnackbar("Error", "please enter your email to proceed");
      }
    } catch (err) {
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
