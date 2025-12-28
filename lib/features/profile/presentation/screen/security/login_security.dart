// 🆕 NEW FILE: login_security_screen.dart

import 'package:royal/core/controllers/transaction_auth_controller.dart';
import 'package:royal/core/theme/colors.dart';
import 'package:royal/features/profile/data/model/templates_model.dart';
import 'package:royal/features/profile/presentation/widget/templates_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginSecurityScreen extends StatefulWidget {
  const LoginSecurityScreen({super.key});

  @override
  State<LoginSecurityScreen> createState() => _LoginSecurityScreenState();
}

class _LoginSecurityScreenState extends State<LoginSecurityScreen> {
  late TransactionAuthController transactionAuthController;
  late RxString selectedMode;

  @override
  void initState() {
    super.initState();
    transactionAuthController = Get.find<TransactionAuthController>();
    selectedMode = RxString('password_always');
    _loadCurrentMode();
  }

  Future<void> _loadCurrentMode() async {
    String mode = await transactionAuthController.getLoginSecurityMode();
    selectedMode.value = mode;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Security"),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select your preferred login method',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
              ),
              const SizedBox(height: 20),
              // Password-Free Login Option
              _buildLoginOptionCard(
                context,
                title: 'Password-Free Login',
                subtitle:
                    'You can log into Royal Exchange without entering the password.',
                optionValue: 'password_free',
                isSelected: selectedMode.value == 'password_free',
                onTap: () => _handleModeSelection('password_free'),
              ),
              const SizedBox(height: 16),
              // 60-Minute Password-Free Option
              _buildLoginOptionCard(
                context,
                title: '60-Minute Password-Free Login',
                subtitle:
                    'You can log into Royal Exchange without entering the password, in the next 60 mins',
                optionValue: 'password_free_60',
                isSelected: selectedMode.value == 'password_free_60',
                onTap: () => _handleModeSelection('password_free_60'),
              ),
              const SizedBox(height: 16),
              // Password Always Needed Option
              _buildLoginOptionCard(
                context,
                title: 'Password Always Needed Login',
                subtitle:
                    'You need to enter password everytime you log into Royal Exchange',
                optionValue: 'password_always',
                isSelected: selectedMode.value == 'password_always',
                onTap: () => _handleModeSelection('password_always'),
              ),
              const SizedBox(height: 40),
              // Biometric Login Section Header
              Text(
                'Biometric Login Option',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),
              // Biometric Toggle Option
              FutureBuilder<bool>(
                future: transactionAuthController.isBiometricLoginEnabled(),
                builder: (context, snapshot) {
                  bool isBiometricEnabled = snapshot.data ?? false;
                  return _buildBiometricToggleCard(
                    context,
                    title: 'Log in with Fingerprint',
                    isEnabled: isBiometricEnabled,
                    onToggle: (value) => _handleBiometricToggle(context, value),
                  );
                },
              ),

              const SizedBox(height: 20),
              // Info text
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Biometric login requires a PIN to be set first. You can enable biometric for faster access to your account.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginOptionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String optionValue,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected ? LightThemeColors.borderColor : Colors.grey[800]!,
            width: isSelected ? 1 : .5,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.white : Colors.white60,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                          fontSize: 12,
                          height: 1.4,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? LightThemeColors.primaryColor
                      : Colors.grey[600]!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Icon(
                        Icons.check,
                        size: 14,
                        color: LightThemeColors.primaryColor,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiometricToggleCard(
    BuildContext context, {
    required String title,
    required bool isEnabled,
    required Function(bool) onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: LightThemeColors.borderColor, width: 1),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: isEnabled,
              onChanged: onToggle,
              activeColor: LightThemeColors.primaryColor,
              inactiveThumbColor: Colors.grey[600],
              inactiveTrackColor: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleModeSelection(String mode) async {
    await transactionAuthController.setLoginSecurityMode(mode);
    setState(() {
      selectedMode.value = mode;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login security mode updated'),
        backgroundColor: Color(0xFF00C853),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleBiometricToggle(BuildContext context, bool value) async {
    if (value) {
      bool success =
          await transactionAuthController.enableBiometricLogin(context);
      if (success) {
        setState(() {});
      }
    } else {
      await transactionAuthController.disableBiometricLogin(context);
      setState(() {});
    }
  }
}
