// import 'package:royal/core/widgets/auth_dialogs.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'dart:async';

// class TransactionAuthController extends GetxController {
//   final LocalAuthentication _localAuth = LocalAuthentication();
//   final FlutterSecureStorage _storage = const FlutterSecureStorage();
//   static const String _pinKey = 'transaction_pin';
//   static const String _useBiometricsKey = 'use_biometrics';

//   // Reactive state for dialogs (optional, used for error handling)
//   final RxBool isPinError = false.obs;

//   // Session timeout constants
//   static const String _lastLoginTimeKey = 'last_login_time';
//   static const int _sessionTimeout60Minutes =
//       60 * 60 * 1000; // 60 minutes in milliseconds
//   static const int _sessionTimeoutAlways =
//       0; // No timeout for password always mode

// // Track if user is currently logged in
//   final RxBool isUserLoggedIn = false.obs;
//   Timer? _sessionCheckTimer;

//   // Check if PIN is already set
//   Future<bool> isPinSet() async {
//     final pin = await _storage.read(key: _pinKey);
//     return pin != null;
//   }

//   // Reset PIN and biometric preference
//   Future<void> resetPin(BuildContext context) async {
//     await _storage.delete(key: _pinKey);
//     await _storage.delete(key: _useBiometricsKey);
//     await setupAuth(context);
//   }

//   // Check if device supports biometrics and user has enabled them
//   Future<bool> canUseBiometrics() async {
//     final useBiometricsStr = await _storage.read(key: _useBiometricsKey);
//     bool useBiometrics = useBiometricsStr == 'true';
//     print('canUseBiometrics: useBiometrics preference = $useBiometrics');

//     if (!useBiometrics) {
//       print('canUseBiometrics: Biometrics disabled by user');
//       return false;
//     }

//     bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
//     bool deviceSupportsBiometrics = await _localAuth.isDeviceSupported();
//     bool biometricsAvailable = canCheckBiometrics && deviceSupportsBiometrics;

//     return biometricsAvailable;
//   }

//   // Set PIN and biometric preference
//   // Future<void> setupAuth(BuildContext context) async {
//   //   await showModalBottomSheet(
//   //     context: context,
//   //     isDismissible: false,
//   //     enableDrag: true,
//   //     isScrollControlled: true,
//   //     builder: (context) => PinSetupModal(
//   //       onPinSet: (pin, useBiometrics) async {
//   //         await _storage.write(key: _pinKey, value: pin);
//   //         await _storage.write(
//   //             key: _useBiometricsKey, value: useBiometrics.toString());
//   //       },
//   //     ),
//   //   );
//   // }

//   Future<void> setupAuth(BuildContext context) async {
//     await showModalBottomSheet(
//       context: context,
//       isDismissible: true,
//       enableDrag: true, // 👈 allows swipe down
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return PinSetupModal(
//           onPinSet: (pin, useBiometrics) async {
//             await _storage.write(key: _pinKey, value: pin);
//             await _storage.write(
//               key: _useBiometricsKey,
//               value: useBiometrics.toString(),
//             );
//             Navigator.pop(context); // close modal
//           },
//         );
//       },
//     );
//   }

// // Authenticate transaction (returns true if successful)
//   Future<bool> authenticate(
//       BuildContext context, String transactionDescription) async {
//     if (!await isPinSet()) {
//       await setupAuth(context);
//       // return false; // Require setup before proceeding
//     }

//     if (await canUseBiometrics()) {
//       try {
//         bool didAuthenticate = await _localAuth.authenticate(
//           localizedReason: 'Authenticate to confirm $transactionDescription',
//           options: const AuthenticationOptions(
//               biometricOnly: true, stickyAuth: true),
//         );
//         if (didAuthenticate) return true;
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content:
//                   Text('Biometric authentication failed. Please use PIN.')),
//         );
//       }
//     } else {
//       print('authenticate: Biometrics not available, falling back to PIN');
//     }

//     // Show PIN dialog for authentication
//     bool? authenticated = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => PinAuthModal(
//         transactionDescription: transactionDescription,
//         onPinEntered: (pin) async {
//           final storedPin = await _storage.read(key: _pinKey);
//           bool isValid = pin == storedPin;
//           isPinError.value = !isValid; // Update reactive state
//           return isValid;
//         },
//       ),
//     );

//     return authenticated ?? false;
//   }

//   // Change PIN only (preserves biometric preference)
// // In TransactionAuthController
//   Future<bool> changePin(BuildContext context) async {
//     if (!await isPinSet()) {
//       await setupAuth(context);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Please set up a PIN first'),
//             backgroundColor: Colors.red),
//       );
//       return false;
//     }

//     bool isAuthenticated =
//         await authenticate(context, 'PIN change verification');
//     if (!isAuthenticated) {
//       print('changePin: Old PIN authentication failed');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Incorrect old PIN'), backgroundColor: Colors.red),
//       );
//       return false;
//     }

//     bool? pinChanged = await showModalBottomSheet<bool>(
//       context: context,
//       isDismissible: true,
//       enableDrag: true, // 👈 allows swipe down
//       isScrollControlled: true,
//       builder: (context) => PinSetupModal(
//         onPinSet: (pin, _) async {
//           await _storage.write(key: _pinKey, value: pin);
//         },
//         showBiometricsOption: false, // Hide biometric checkbox
//       ),
//     );

//     if (pinChanged == true) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('PIN changed successfully'),
//             backgroundColor: Color(0xFF00C853)),
//       );
//       return true;
//     } else {
//       print('changePin: PIN change cancelled');
//       return false;
//     }
//   }

// // 🆕 ADD THESE METHODS TO TransactionAuthController CLASS

// // Get current login security mode preference
//   Future<String> getLoginSecurityMode() async {
//     final mode = await _storage.read(key: 'login_security_mode');
//     return mode ?? 'password_always'; // Default to password always
//   }

// // Set login security mode preference
//   Future<void> setLoginSecurityMode(String mode) async {
//     await _storage.write(key: 'login_security_mode', value: mode);
//   }

// // Get biometric login enabled status
//   Future<bool> isBiometricLoginEnabled() async {
//     final mode = await getLoginSecurityMode();
//     return mode == 'biometric' || mode == 'password_free_60';
//   }

// // Enable biometric login (requires PIN setup first)
//   Future<bool> enableBiometricLogin(BuildContext context) async {
//     if (!await isPinSet()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please set up a PIN first'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return false;
//     }

//     // Verify device supports biometrics
//     bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
//     bool deviceSupportsBiometrics = await _localAuth.isDeviceSupported();

//     if (!canCheckBiometrics || !deviceSupportsBiometrics) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Biometrics not supported on this device'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return false;
//     }

//     // Test biometric authentication
//     try {
//       bool didAuthenticate = await _localAuth.authenticate(
//         localizedReason: 'Enable biometric login for faster access',
//         options: const AuthenticationOptions(biometricOnly: true),
//       );

//       if (didAuthenticate) {
//         await setLoginSecurityMode('biometric');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Biometric login enabled successfully'),
//             backgroundColor: Color(0xFF00C853),
//           ),
//         );
//         return true;
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Biometric setup failed. Please try again.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }

//     return false;
//   }

// // Disable biometric login
//   Future<void> disableBiometricLogin(BuildContext context) async {
//     await setLoginSecurityMode('password_always');
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Biometric login disabled'),
//         backgroundColor: Color(0xFF00C853),
//       ),
//     );
//   }

// // Authenticate for app login (uses biometric if enabled, falls back to PIN)
//   Future<bool> authenticateForLogin(BuildContext context) async {
//     if (!await isPinSet()) {
//       return false; // PIN required to use app
//     }

//     String loginMode = await getLoginSecurityMode();

//     // Try biometric first if enabled
//     if (loginMode == 'biometric' && await canUseBiometrics()) {
//       try {
//         bool didAuthenticate = await _localAuth.authenticate(
//           localizedReason: 'Authenticate to log in',
//           options: const AuthenticationOptions(
//             biometricOnly: true,
//             stickyAuth: true,
//           ),
//         );
//         if (didAuthenticate) return true;
//       } catch (e) {
//         print('Biometric auth failed: $e');
//       }
//     }

//     // Fall back to PIN dialog
//     bool? authenticated = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => PinAuthModal(
//         transactionDescription: 'app login',
//         onPinEntered: (pin) async {
//           final storedPin = await _storage.read(key: _pinKey);
//           bool isValid = pin == storedPin;
//           isPinError.value = !isValid;
//           return isValid;
//         },
//       ),
//     );

//     return authenticated ?? false;
//   }

// // Initialize session check when app starts
// void initializeSessionCheck() {
//   print('initializeSessionCheck: Starting session timer');
//   // Check session every 30 seconds
//   _sessionCheckTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
//     await _checkSessionValidity();
//   });
// }

// // Dispose session timer
// void disposeSessionCheck() {
//   _sessionCheckTimer?.cancel();
//   print('disposeSessionCheck: Session timer cancelled');
// }

// // Record login time when user logs in
// Future<void> recordLoginTime() async {
//   final now = DateTime.now().millisecondsSinceEpoch.toString();
//   await _storage.write(key: _lastLoginTimeKey, value: now);
//   isUserLoggedIn.value = true;
//   print('recordLoginTime: Login recorded at $now');
// }

// // Check if current session is still valid
// Future<bool> isSessionValid() async {
//   if (!isUserLoggedIn.value) {
//     return false;
//   }

//   String loginMode = await getLoginSecurityMode();

//   // If password always needed, session is always valid (no timeout)
//   if (loginMode == 'password_always') {
//     return true;
//   }

//   // If password-free (no timeout), session is always valid
//   if (loginMode == 'password_free') {
//     return true;
//   }

//   // If 60-minute password-free, check the timeout
//   if (loginMode == 'password_free_60') {
//     final lastLoginStr = await _storage.read(key: _lastLoginTimeKey);
//     if (lastLoginStr == null) {
//       return false;
//     }

//     final lastLoginTime = int.parse(lastLoginStr);
//     final currentTime = DateTime.now().millisecondsSinceEpoch;
//     final elapsedTime = currentTime - lastLoginTime;

//     bool isValid = elapsedTime < _sessionTimeout60Minutes;
//     print('isSessionValid: Mode=60min, Elapsed=${elapsedTime}ms, Valid=$isValid');
//     return isValid;
//   }

//   return false;
// }

// // Check session validity and logout if expired
// Future<void> _checkSessionValidity() async {
//   bool valid = await isSessionValid();

//   if (!valid && isUserLoggedIn.value) {
//     print('_checkSessionValidity: Session expired, logging out');
//     await forceLogout();
//   }
// }

// // Get remaining session time in seconds (for 60-minute mode)
// Future<int> getRemainingSessionTime() async {
//   String loginMode = await getLoginSecurityMode();

//   if (loginMode != 'password_free_60') {
//     return -1; // Not applicable
//   }

//   final lastLoginStr = await _storage.read(key: _lastLoginTimeKey);
//   if (lastLoginStr == null) {
//     return 0;
//   }

//   final lastLoginTime = int.parse(lastLoginStr);
//   final currentTime = DateTime.now().millisecondsSinceEpoch;
//   final elapsedMs = currentTime - lastLoginTime;
//   final remainingMs = _sessionTimeout60Minutes - elapsedMs;
//   final remainingSeconds = (remainingMs / 1000).ceil();

//   return remainingSeconds > 0 ? remainingSeconds : 0;
// }

// // Format remaining time for display (e.g., "45 min 30 sec")
// Future<String> getFormattedRemainingTime() async {
//   int seconds = await getRemainingSessionTime();
//   if (seconds < 0) return '';

//   int minutes = seconds ~/ 60;
//   int secs = seconds % 60;

//   if (minutes > 0) {
//     return '$minutes min ${secs}s remaining';
//   } else {
//     return '${secs}s remaining';
//   }
// }

// // Extend session (call when user interacts with app in 60-min mode)
// Future<void> extendSession() async {
//   String loginMode = await getLoginSecurityMode();

//   if (loginMode == 'password_free_60') {
//     await recordLoginTime();
//     print('extendSession: Session extended');
//   }
// }

// // Force logout (clear session data)
// Future<void> forceLogout() async {
//   await _storage.delete(key: _lastLoginTimeKey);
//   isUserLoggedIn.value = false;
//   print('forceLogout: User logged out due to session expiry');

//   // Navigate to login screen
//   // Get.offAllNamed(RoutesConstant.signin);
// }

// // Clear session on manual logout
// Future<void> clearSession() async {
//   await _storage.delete(key: _lastLoginTimeKey);
//   isUserLoggedIn.value = false;
//   print('clearSession: Session cleared');
// }
// }

// 🆕 COMPLETE UPDATED TransactionAuthController

import 'package:royal/core/widgets/auth_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:royal/core/services/secure_storage_service.dart';

class TransactionAuthController extends GetxController {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final storageService = SecureStorageService();

  // Storage keys
  static const String _pinKey = 'transaction_pin';
  static const String _useBiometricsKey = 'use_biometrics';
  static const String _loginSecurityModeKey = 'login_security_mode';
  static const String _lastLoginTimeKey = 'last_login_time';
  static const String _lastAppPauseTimeKey = 'last_app_pause_time';

  // Session timeout constants
  static const int _sessionTimeout60Minutes =
      60 * 60 * 1000; // 60 minutes in milliseconds

  // Reactive states
  final RxBool isPinError = false.obs;
  final RxBool isUserLoggedIn = false.obs;

  // Session timer
  Timer? _sessionCheckTimer;

  // ════════════════════════════════════════════════════════════════════
  // INITIALIZATION & SETUP
  // ════════════════════════════════════════════════════════════════════

  // Initialize session check when app starts
  void initializeSessionCheck() {
    print('initializeSessionCheck: Starting session timer');
    // Check session every 30 seconds in background
    _sessionCheckTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      await _checkSessionValidityBackground();
    });
  }

  // Dispose session timer
  void disposeSessionCheck() {
    _sessionCheckTimer?.cancel();
    print('disposeSessionCheck: Session timer cancelled');
  }

  // ════════════════════════════════════════════════════════════════════
  // LOGIN SECURITY MODE MANAGEMENT
  // ════════════════════════════════════════════════════════════════════

  // Get current login security mode preference
  Future<String> getLoginSecurityMode() async {
    final mode = await _storage.read(key: _loginSecurityModeKey);
    return mode ?? 'password_always'; // Default to password always
  }

  // Set login security mode preference
  Future<void> setLoginSecurityMode(String mode) async {
    await _storage.write(key: _loginSecurityModeKey, value: mode);
    print('setLoginSecurityMode: Mode set to $mode');
  }

  // ════════════════════════════════════════════════════════════════════
  // SESSION MANAGEMENT
  // ════════════════════════════════════════════════════════════════════

  // Record login time when user logs in successfully
  Future<void> recordLoginTime() async {
    final now = DateTime.now().millisecondsSinceEpoch.toString();
    await _storage.write(key: _lastLoginTimeKey, value: now);
    isUserLoggedIn.value = true;
    print('recordLoginTime: Login recorded at $now');
  }

  // Record when app goes to background (user leaves app)
  Future<void> recordAppPauseTime() async {
    final now = DateTime.now().millisecondsSinceEpoch.toString();
    await _storage.write(key: _lastAppPauseTimeKey, value: now);
    print('recordAppPauseTime: App paused at $now');
  }

  // Check if session is valid based on login mode and timing
  Future<bool> isSessionValid() async {
    if (!isUserLoggedIn.value) {
      return false;
    }

    String loginMode = await getLoginSecurityMode();

    // MODE 1: Password-Free Login (no timeout, always valid)
    if (loginMode == 'password_free') {
      print('isSessionValid: password_free mode - session always valid');
      return true;
    }

    // MODE 2: Password Always Needed (no session, should logout on app resume)
    if (loginMode == 'password_always') {
      print('isSessionValid: password_always mode - session invalid');
      return false; // Always invalid, forces re-login on app resume
    }

    // MODE 3: 60-Minute Password-Free Login (timeout after 60 minutes of leaving app)
    if (loginMode == 'password_free_60') {
      return await _checkSession60MinuteMode();
    }

    return false;
  }

  // Check 60-minute timeout specifically
  Future<bool> _checkSession60MinuteMode() async {
    final appPauseStr = await _storage.read(key: _lastAppPauseTimeKey);

    if (appPauseStr == null) {
      // If no pause time recorded, session is still valid
      return true;
    }

    final appPauseTime = int.parse(appPauseStr);
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final elapsedTime = currentTime - appPauseTime;

    bool isValid = elapsedTime < _sessionTimeout60Minutes;
    print(
        '_checkSession60MinuteMode: Elapsed=${elapsedTime}ms, Timeout=${_sessionTimeout60Minutes}ms, Valid=$isValid');

    return isValid;
  }

  // Background session validity check (runs every 30 seconds)
  Future<void> _checkSessionValidityBackground() async {
    if (!isUserLoggedIn.value) return;

    bool valid = await isSessionValid();

    if (!valid) {
      print('_checkSessionValidityBackground: Session expired, forcing logout');
      await forceLogout();
    }
  }

  // Check session when app comes to foreground
  Future<bool> checkSessionOnAppResume() async {
    print('checkSessionOnAppResume: Checking session validity');

    if (!isUserLoggedIn.value) {
      return false;
    }

    String loginMode = await getLoginSecurityMode();

    // PASSWORD-FREE: Session always valid, no logout
    if (loginMode == 'password_free') {
      print(
          'checkSessionOnAppResume: password_free mode - session valid, no logout needed');
      return true;
    }

    // PASSWORD ALWAYS NEEDED: Always logout when app resumes
    if (loginMode == 'password_always') {
      print('checkSessionOnAppResume: password_always mode - forcing logout');
      await forceLogout();
      return false;
    }

    // 60-MINUTE MODE: Check if 60 minutes passed since leaving app
    if (loginMode == 'password_free_60') {
      bool isValid = await _checkSession60MinuteMode();
      if (!isValid) {
        print(
            'checkSessionOnAppResume: 60-minute timeout exceeded, forcing logout');
        await forceLogout();
        return false;
      }
      print('checkSessionOnAppResume: 60-minute session still valid');
      return true;
    }

    return false;
  }

  // Get remaining session time in seconds (for 60-minute mode)
  Future<int> getRemainingSessionTime() async {
    String loginMode = await getLoginSecurityMode();

    if (loginMode != 'password_free_60') {
      return -1; // Not applicable
    }

    final appPauseStr = await _storage.read(key: _lastAppPauseTimeKey);
    if (appPauseStr == null) {
      return _sessionTimeout60Minutes ~/ 1000; // Full 60 minutes
    }

    final appPauseTime = int.parse(appPauseStr);
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final elapsedMs = currentTime - appPauseTime;
    final remainingMs = _sessionTimeout60Minutes - elapsedMs;
    final remainingSeconds = (remainingMs / 1000).ceil();

    return remainingSeconds > 0 ? remainingSeconds : 0;
  }

  // Format remaining time for display
  Future<String> getFormattedRemainingTime() async {
    int seconds = await getRemainingSessionTime();
    if (seconds < 0) return '';

    int minutes = seconds ~/ 60;
    int secs = seconds % 60;

    if (minutes > 0) {
      return '$minutes min ${secs}s remaining';
    } else {
      return '${secs}s remaining';
    }
  }

  // Extend session (for 60-minute mode on user interaction)
  Future<void> extendSession() async {
    String loginMode = await getLoginSecurityMode();

    if (loginMode == 'password_free_60') {
      // Reset the pause time to extend the session
      await recordAppPauseTime();
      print('extendSession: Session extended in 60-minute mode');
    }
  }

  // Force logout (clear all session data)
  Future<void> forceLogout() async {
    print('forceLogout: User logged out');

    await _storage.delete(key: _lastLoginTimeKey);
    await _storage.delete(key: _lastAppPauseTimeKey);
    await storageService.saveData("user_has", "log_out");

    isUserLoggedIn.value = false;
  }

  // Clear session on manual logout
  Future<void> clearSession() async {
    await _storage.delete(key: _lastLoginTimeKey);
    await _storage.delete(key: _lastAppPauseTimeKey);
    isUserLoggedIn.value = false;
    print('clearSession: Session cleared by user');
  }

  // ════════════════════════════════════════════════════════════════════
  // PIN SETUP & MANAGEMENT
  // ════════════════════════════════════════════════════════════════════

  // Check if PIN is already set
  Future<bool> isPinSet() async {
    final pin = await _storage.read(key: _pinKey);
    return pin != null;
  }

  // Setup PIN and biometric preference
  Future<void> setupAuth(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return PinSetupModal(
          onPinSet: (pin, useBiometrics) async {
            await _storage.write(key: _pinKey, value: pin);
            await _storage.write(
              key: _useBiometricsKey,
              value: useBiometrics.toString(),
            );
            Navigator.pop(context);
          },
        );
      },
    );
  }

  // Reset PIN and biometric preference
  Future<void> resetPin(BuildContext context) async {
    await _storage.delete(key: _pinKey);
    await _storage.delete(key: _useBiometricsKey);
    await setupAuth(context);
  }

  // ════════════════════════════════════════════════════════════════════
  // BIOMETRIC LOGIN MANAGEMENT
  // ════════════════════════════════════════════════════════════════════

  // Check if device supports biometrics and user has enabled them
  Future<bool> canUseBiometrics() async {
    final useBiometricsStr = await _storage.read(key: _useBiometricsKey);
    bool useBiometrics = useBiometricsStr == 'true';

    if (!useBiometrics) {
      print('canUseBiometrics: Biometrics disabled by user');
      return false;
    }

    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    bool deviceSupportsBiometrics = await _localAuth.isDeviceSupported();
    bool biometricsAvailable = canCheckBiometrics && deviceSupportsBiometrics;

    print('canUseBiometrics: Available=$biometricsAvailable');
    return biometricsAvailable;
  }

  // Get biometric login enabled status
  Future<bool> isBiometricLoginEnabled() async {
    return await canUseBiometrics();
  }

  // Enable biometric login (requires PIN setup first)
  Future<bool> enableBiometricLogin(BuildContext context) async {
    if (!await isPinSet()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please set up a PIN first'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    bool deviceSupportsBiometrics = await _localAuth.isDeviceSupported();

    if (!canCheckBiometrics || !deviceSupportsBiometrics) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Biometrics not supported on this device'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    try {
      bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Enable biometric login for faster access',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (didAuthenticate) {
        await _storage.write(key: _useBiometricsKey, value: 'true');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometric login enabled successfully'),
            backgroundColor: Color(0xFF00C853),
          ),
        );
        return true;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Biometric setup failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }

    return false;
  }

  // Disable biometric login
  Future<void> disableBiometricLogin(BuildContext context) async {
    await _storage.write(key: _useBiometricsKey, value: 'false');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Biometric login disabled'),
        backgroundColor: Color(0xFF00C853),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // TRANSACTION AUTHENTICATION
  // ════════════════════════════════════════════════════════════════════

  // Authenticate for transaction (tries biometric, falls back to PIN)
  Future<bool> authenticate(
      BuildContext context, String transactionDescription) async {
    if (!await isPinSet()) {
      await setupAuth(context);
    }

    // Try biometric first if enabled
    if (await canUseBiometrics()) {
      try {
        bool didAuthenticate = await _localAuth.authenticate(
          localizedReason: 'Authenticate to confirm $transactionDescription',
          options: const AuthenticationOptions(
              biometricOnly: true, stickyAuth: true),
        );
        if (didAuthenticate) return true;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Biometric authentication failed. Please use PIN.')),
        );
      }
    } else {
      print('authenticate: Biometrics not available, falling back to PIN');
    }

    // Fall back to PIN dialog
    bool? authenticated = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PinAuthModal(
        transactionDescription: transactionDescription,
        onPinEntered: (pin) async {
          final storedPin = await _storage.read(key: _pinKey);
          bool isValid = pin == storedPin;
          isPinError.value = !isValid;
          return isValid;
        },
      ),
    );

    return authenticated ?? false;
  }

  // Change PIN (only, preserves biometric preference)
  Future<bool> changePin(BuildContext context) async {
    if (!await isPinSet()) {
      await setupAuth(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please set up a PIN first'),
            backgroundColor: Colors.red),
      );
      return false;
    }

    bool isAuthenticated =
        await authenticate(context, 'PIN change verification');
    if (!isAuthenticated) {
      print('changePin: Old PIN authentication failed');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Incorrect old PIN'), backgroundColor: Colors.red),
      );
      return false;
    }

    bool? pinChanged = await showModalBottomSheet<bool>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      builder: (context) => PinSetupModal(
        onPinSet: (pin, _) async {
          await _storage.write(key: _pinKey, value: pin);
        },
        showBiometricsOption: false,
      ),
    );

    if (pinChanged == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('PIN changed successfully'),
            backgroundColor: Color(0xFF00C853)),
      );
      return true;
    } else {
      print('changePin: PIN change cancelled');
      return false;
    }
  }

  // ════════════════════════════════════════════════════════════════════
  // LOGIN SCREEN AUTHENTICATION
  // ════════════════════════════════════════════════════════════════════

  // Main app login method (used on login screen)
  // Tries biometric first, falls back to PIN
  Future<bool> authenticateForAppLogin(BuildContext context) async {
    if (!await isPinSet()) {
      return false; // PIN required
    }

    // Try biometric if enabled
    if (await canUseBiometrics()) {
      try {
        bool didAuthenticate = await _localAuth.authenticate(
          localizedReason: 'Authenticate to log in',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ),
        );
        if (didAuthenticate) {
          await recordLoginTime();
          isUserLoggedIn.value = true;
          return true;
        }
      } catch (e) {
        print('authenticateForAppLogin: Biometric failed: $e');
      }
    }

    // Fall back to PIN dialog
    bool? authenticated = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PinAuthModal(
        transactionDescription: 'app login',
        onPinEntered: (pin) async {
          final storedPin = await _storage.read(key: _pinKey);
          bool isValid = pin == storedPin;
          isPinError.value = !isValid;
          return isValid;
        },
      ),
    );

    if (authenticated == true) {
      await recordLoginTime();
      isUserLoggedIn.value = true;
      return true;
    }

    return false;
  }
}
