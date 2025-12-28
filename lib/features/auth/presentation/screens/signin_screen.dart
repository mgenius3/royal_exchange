// import 'package:royal/core/constants/images.dart';
// import 'package:royal/core/constants/routes.dart';
// import 'package:royal/core/theme/colors.dart';
// import 'package:royal/core/utils/spacing.dart';
// import 'package:royal/features/auth/controllers/signin_controller.dart';
// import 'package:royal/features/auth/data/models/input_field_model.dart';
// import 'package:royal/features/auth/presentation/widget/button_continue_with.dart';
// import 'package:royal/features/auth/presentation/widget/horizontal_line_widget.dart';
// import 'package:royal/features/auth/presentation/widget/input_field_widget.dart';
// import 'package:royal/core/controllers/primary_button_controller.dart';
// import 'package:royal/core/models/primary_button_model.dart';
// import 'package:royal/core/models/top_header_model.dart';
// import 'package:royal/core/widgets/primary_button_widget.dart';
// import 'package:royal/core/widgets/top_header_widget.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final LoginController controller = Get.put(LoginController());

//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             margin: Spacing.defaultMarginSpacing,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildHeader(),
//                 const SizedBox(height: 20),
//                 _buildLoginForm(controller),
//                 const SizedBox(height: 20),
//                 _buildSignInButton(controller),
//                 const SizedBox(height: 20),
//                 _buildFooter(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Column(
//       children: [
//         const TopHeaderWidget(data: TopHeaderModel(title: "Login")),
//         const SizedBox(height: 20),
//         Container(
//           width: double.infinity,
//           child: Column(
//             children: [
//               const SizedBox(height: 16),
//               Text(
//                 'Welcome Back',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w800,
//                   color: Colors.grey[800],
//                   letterSpacing: -0.5,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Sign in to your account to continue',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey[600],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildLoginForm(LoginController controller) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Form(
//         key: controller.formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(
//                     Icons.account_circle_outlined,
//                     size: 18,
//                     color: Colors.blue[700],
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 const Text(
//                   'Account Details',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFF1A1A1A),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             _buildInputSection(
//               'Email Address',
//               Icons.email_outlined,
//               authInputField(AuthInputFieldModel(
//                 inputcontroller: controller.emailController,
//                 name: "Email Address",
//               )),
//             ),
//             const SizedBox(height: 20),
//             _buildInputSection(
//               'Password',
//               Icons.lock_outline,
//               Obx(() => authInputField(AuthInputFieldModel(
//                     inputcontroller: controller.passwordController,
//                     name: "Password",
//                     obscureText: controller.obscurePassword.value,
//                     suffixIcon: SizedBox(
//                       width: 22,
//                       height: 22,
//                       child: IconButton(
//                         onPressed: () {
//                           HapticFeedback.lightImpact();
//                           controller.togglePasswordVisibility();
//                         },
//                         icon: Icon(
//                           controller.obscurePassword.value
//                               ? CupertinoIcons.eye
//                               : CupertinoIcons.eye_slash,
//                         ),
//                       ),
//                     ),
//                   ))),
//             ),
//             const SizedBox(height: 16),
//             Align(
//               alignment: Alignment.centerRight,
//               child: GestureDetector(
//                 onTap: () {
//                   HapticFeedback.lightImpact();
//                   Get.toNamed(RoutesConstant.forgotpassword);
//                 },
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: LightThemeColors.primaryColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.help_outline,
//                         size: 14,
//                         color: LightThemeColors.primaryColor,
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         'Forgot password?',
//                         style: TextStyle(
//                           color: LightThemeColors.primaryColor,
//                           fontSize: 13.39,
//                           fontWeight: FontWeight.w600,
//                           height: 1.43,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInputSection(String title, IconData icon, Widget inputField) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Icon(
//                 icon,
//                 size: 14,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey[700],
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         inputField,
//       ],
//     );
//   }

//   Widget _buildSignInButton(LoginController controller) {
//     return SizedBox(
//       child: Column(
//         children: [
//           Obx(() => controller.isLoading.value
//               ? Container(
//                   width: double.infinity,
//                   height: 56,
//                   decoration: BoxDecoration(
//                     color: LightThemeColors.primaryColor.withOpacity(0.7),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: const Center(
//                     child: SizedBox(
//                       width: 24,
//                       height: 24,
//                       child: CircularProgressIndicator(
//                         color: Colors.white,
//                         strokeWidth: 2,
//                       ),
//                     ),
//                   ),
//                 )
//               : Container(
//                   width: double.infinity,
//                   height: 56,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         LightThemeColors.primaryColor,
//                         LightThemeColors.primaryColor.withOpacity(0.8),
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: LightThemeColors.primaryColor.withOpacity(0.3),
//                         blurRadius: 12,
//                         offset: const Offset(0, 6),
//                       ),
//                     ],
//                   ),
//                   child: Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(16),
//                       onTap: () {
//                         HapticFeedback.lightImpact();
//                         controller.signIn();
//                       },
//                       child: const Center(
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               'Sign In',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 )),
//         ],
//       ),
//     );
//   }

//   Widget _buildFooter() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             'New Here? ',
//             style: TextStyle(
//               color: Color(0xFF484C58),
//               fontSize: 13.39,
//               fontWeight: FontWeight.w400,
//               height: 1.43,
//             ),
//           ),
//           const SizedBox(width: 3.83),
//           GestureDetector(
//             onTap: () {
//               HapticFeedback.lightImpact();
//               Get.toNamed(RoutesConstant.signup);
//             },
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: LightThemeColors.primaryColor.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.person_add_outlined,
//                     size: 14,
//                     color: LightThemeColors.primaryColor,
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     'Create an account',
//                     style: TextStyle(
//                       color: LightThemeColors.primaryColor,
//                       fontSize: 13.39,
//                       fontWeight: FontWeight.w600,
//                       height: 1.43,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// 🆕 UPDATED LoginScreen with biometric button

import 'package:royal/core/constants/images.dart';
import 'package:royal/core/constants/routes.dart';
import 'package:royal/core/theme/colors.dart';
import 'package:royal/core/utils/spacing.dart';
import 'package:royal/features/auth/controllers/signin_controller.dart';
import 'package:royal/features/auth/data/models/input_field_model.dart';
import 'package:royal/features/auth/presentation/widget/button_continue_with.dart';
import 'package:royal/features/auth/presentation/widget/horizontal_line_widget.dart';
import 'package:royal/features/auth/presentation/widget/input_field_widget.dart';
import 'package:royal/core/controllers/primary_button_controller.dart';
import 'package:royal/core/models/primary_button_model.dart';
import 'package:royal/core/models/top_header_model.dart';
import 'package:royal/core/widgets/primary_button_widget.dart';
import 'package:royal/core/widgets/top_header_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: Spacing.defaultMarginSpacing,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(controller), // 🆕 UPDATED to pass controller
                const SizedBox(height: 20),
                _buildLoginForm(controller),
                const SizedBox(height: 20),
                _buildSignInButton(controller),
                const SizedBox(height: 12), // 🆕 REDUCED spacing
                // 🆕 NEW: Biometric login button (if available)
                Obx(() => controller.isBiometricAvailable.value
                    ? _buildBiometricLoginButton(controller)
                    : const SizedBox.shrink()),
                const SizedBox(height: 20),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🆕 UPDATED: Header with session expired message
  Widget _buildHeader(LoginController controller) {
    return Column(
      children: [
        const TopHeaderWidget(
            data: TopHeaderModel(title: "Login"), showBackButton: false),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 16),
              // 🆕 NEW: Show session expired warning if applicable
              Obx(() => controller.isSessionExpired.value
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.red[700],
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Your session has expired. Please log in again.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFD32F2F),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink()),
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey[800],
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to your account to continue',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(LoginController controller) {
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
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.account_circle_outlined,
                    size: 18,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Account Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildInputSection(
              'Email Address',
              Icons.email_outlined,
              authInputField(AuthInputFieldModel(
                inputcontroller: controller.emailController,
                name: "Email Address",
              )),
            ),
            const SizedBox(height: 20),
            _buildInputSection(
              'Password',
              Icons.lock_outline,
              Obx(() => authInputField(AuthInputFieldModel(
                    inputcontroller: controller.passwordController,
                    name: "Password",
                    obscureText: controller.obscurePassword.value,
                    suffixIcon: SizedBox(
                      width: 22,
                      height: 22,
                      child: IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          controller.togglePasswordVisibility();
                        },
                        icon: Icon(
                          controller.obscurePassword.value
                              ? CupertinoIcons.eye
                              : CupertinoIcons.eye_slash,
                        ),
                      ),
                    ),
                  ))),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Get.toNamed(RoutesConstant.forgotpassword);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: LightThemeColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.help_outline,
                        size: 14,
                        color: LightThemeColors.primaryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: LightThemeColors.primaryColor,
                          fontSize: 13.39,
                          fontWeight: FontWeight.w600,
                          height: 1.43,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(String title, IconData icon, Widget inputField) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
                size: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        inputField,
      ],
    );
  }

  Widget _buildSignInButton(LoginController controller) {
    return SizedBox(
      child: Column(
        children: [
          Obx(() => controller.isLoading.value
              ? Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: LightThemeColors.primaryColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                )
              : Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        LightThemeColors.primaryColor,
                        LightThemeColors.primaryColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: LightThemeColors.primaryColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        controller.signIn();
                      },
                      child: const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  // 🆕 NEW: Biometric login button
  Widget _buildBiometricLoginButton(LoginController controller) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(
          color: LightThemeColors.primaryColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
        color: LightThemeColors.primaryColor.withOpacity(0.05),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            HapticFeedback.lightImpact();
            controller.biometricLogin();
          },
          child: Center(
            child: Obx(
              () => controller.isLoading.value
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: LightThemeColors.primaryColor,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.fingerprint,
                          color: LightThemeColors.primaryColor,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Sign In with Biometric',
                          style: TextStyle(
                            color: LightThemeColors.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'New Here? ',
            style: TextStyle(
              color: Color(0xFF484C58),
              fontSize: 13.39,
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
          const SizedBox(width: 3.83),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Get.toNamed(RoutesConstant.signup);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: LightThemeColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_add_outlined,
                    size: 14,
                    color: LightThemeColors.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Create an account',
                    style: TextStyle(
                      color: LightThemeColors.primaryColor,
                      fontSize: 13.39,
                      fontWeight: FontWeight.w600,
                      height: 1.43,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
