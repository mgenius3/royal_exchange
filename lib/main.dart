// import 'package:royal/core/constants/routes.dart';
// import 'package:royal/core/controllers/admin_bank_details_controller.dart';
// import 'package:royal/core/controllers/currency_rate_controller.dart';
// import 'package:royal/core/controllers/transaction_auth_controller.dart';
// import 'package:royal/core/controllers/user_auth_details_controller.dart';
// import 'package:royal/core/services/secure_storage_service.dart';
// import 'package:royal/core/states/mode.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:royal/features/flight/controllers/booking.dart';
// import 'dart:async';
// import 'routes.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   // Dependency Injection
// //   Get.put(LightningModeController()); // Controller
// //   Get.put(UserAuthDetailsController());
// //   Get.put(AdminBankDetailsController());
// //   Get.put(CurrencyRateController());
// //   Get.put(TransactionAuthController());

// //   runApp(const MyApp());
// // }

// // class MyApp extends StatefulWidget {
// //   const MyApp({super.key});
// //   @override
// //   _MyAppState createState() => _MyAppState();
// // }

// // class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
// //   final LightningModeController controller = Get.put(LightningModeController());
// //   final UserAuthDetailsController authController =
// //       Get.find<UserAuthDetailsController>();

// //   Brightness? _currentBrightness;
// //   Timer? _timer;
// //   String? _initialRoutes; // Changed from late String to String?

// //   @override
// //   void initState() {
// //     super.initState();
// //     // Register as an observer to listen for system changes.
// //     WidgetsBinding.instance.addObserver(this);
// //     // Initial system brightness check
// //     _currentBrightness =
// //         WidgetsBinding.instance.platformDispatcher.platformBrightness;

// //     _checkToken();
// //   }

// //   void _checkToken() async {
// //     String? user_has = await SecureStorageService().getData('user_has');
// //     if (user_has != null) {
// //       if (user_has == "log_out") {
// //         setState(() {
// //           _initialRoutes = RoutesConstant.signin;
// //         });
// //       } else {
// //         setState(() {
// //           _initialRoutes = RoutesConstant.home;
// //         });
// //       }
// //     } else {
// //       setState(() {
// //         _initialRoutes = RoutesConstant.splash;
// //       });
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     // Remove observer when the widget is disposed of
// //     WidgetsBinding.instance.removeObserver(this);
// //     _timer?.cancel();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     // Wait for route to be determined before building
// //     if (_initialRoutes == null) {
// //       return const MaterialApp(
// //         home: Scaffold(
// //           body: Center(child: CircularProgressIndicator()),
// //         ),
// //       );
// //     }

// //     return GetMaterialApp(
// //         title: 'Royal Exchange',
// //         debugShowCheckedModeBanner: false,
// //         initialRoute: _initialRoutes!,
// //         theme: ThemeData(fontFamily: "Urbanist"),
// //         getPages: AppRoutes.routes);
// //   }
// // }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // Dependency Injection
//   Get.put(LightningModeController()); // Controller
//   Get.put(UserAuthDetailsController());
//   Get.put(AdminBankDetailsController());
//   Get.put(CurrencyRateController());
//   Get.put(TransactionAuthController());

//   // 🆕 Initialize session timeout check
//   final transactionAuthController = Get.find<TransactionAuthController>();
//   transactionAuthController.initializeSessionCheck();

//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   final LightningModeController controller = Get.put(LightningModeController());
//   final UserAuthDetailsController authController =
//       Get.find<UserAuthDetailsController>();
//   // 🆕 Get transaction auth controller
//   late TransactionAuthController transactionAuthController;

//   Brightness? _currentBrightness;
//   Timer? _timer;
//   String? _initialRoutes;

//   @override
//   void initState() {
//     super.initState();
//     // 🆕 Get the controller
//     transactionAuthController = Get.find<TransactionAuthController>();

//     // Register as an observer to listen for system changes and app lifecycle
//     WidgetsBinding.instance.addObserver(this);

//     // Initial system brightness check
//     _currentBrightness =
//         WidgetsBinding.instance.platformDispatcher.platformBrightness;

//     _checkToken();
//   }

//   // 🆕 NEW: Listen for app lifecycle changes
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);

//     print('App lifecycle state: $state');

//     if (state == AppLifecycleState.resumed) {
//       // App came to foreground - check if session is still valid
//       print('App resumed - checking session validity');
//       _checkSessionOnResume();
//     } else if (state == AppLifecycleState.paused ||
//                state == AppLifecycleState.detached) {
//       // App went to background or was closed
//       print('App paused/detached');
//     }
//   }

//   // 🆕 NEW: Check session when app resumes
//   Future<void> _checkSessionOnResume() async {
//     bool isValid = await transactionAuthController.isSessionValid();

//     if (!isValid && transactionAuthController.isUserLoggedIn.value) {
//       print('Session expired - forcing logout');
//       // Show snackbar and redirect to login
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Your session has expired. Please log in again.'),
//           backgroundColor: Colors.red,
//           duration: Duration(seconds: 3),
//         ),
//       );

//       await transactionAuthController.forceLogout();
//       // Navigate to login screen
//       // Get.offAllNamed(RoutesConstant.signin);
//     }
//   }

//   void _checkToken() async {
//     String? user_has = await SecureStorageService().getData('user_has');
//     if (user_has != null) {
//       if (user_has == "log_out") {
//         setState(() {
//           _initialRoutes = RoutesConstant.signin;
//         });
//       } else {
//         setState(() {
//           _initialRoutes = RoutesConstant.home;
//         });
//         // 🆕 Record login time when user is already logged in
//         await transactionAuthController.recordLoginTime();
//       }
//     } else {
//       setState(() {
//         _initialRoutes = RoutesConstant.splash;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     // 🆕 Dispose session timer
//     transactionAuthController.disposeSessionCheck();

//     // Remove observer when the widget is disposed of
//     WidgetsBinding.instance.removeObserver(this);
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Wait for route to be determined before building
//     if (_initialRoutes == null) {
//       return const MaterialApp(
//         home: Scaffold(
//           body: Center(child: CircularProgressIndicator()),
//         ),
//       );
//     }

//     return GetMaterialApp(
//         title: 'Royal Exchange',
//         debugShowCheckedModeBanner: false,
//         initialRoute: _initialRoutes!,
//         theme: ThemeData(fontFamily: "Urbanist"),
//         getPages: AppRoutes.routes);
//   }
// }

// 🆕 COMPLETE UPDATED main.dart

import 'package:royal/core/constants/routes.dart';
import 'package:royal/core/controllers/admin_bank_details_controller.dart';
import 'package:royal/core/controllers/currency_rate_controller.dart';
import 'package:royal/core/controllers/transaction_auth_controller.dart';
import 'package:royal/core/controllers/user_auth_details_controller.dart';
import 'package:royal/core/services/secure_storage_service.dart';
import 'package:royal/core/states/mode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:royal/features/flight/controllers/booking.dart';
import 'dart:async';
import 'routes.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Dependency Injection
  Get.put(LightningModeController()); // Controller
  Get.put(UserAuthDetailsController());
  Get.put(AdminBankDetailsController());
  Get.put(CurrencyRateController());
  Get.put(TransactionAuthController());

  // 🆕 Initialize session timeout check
  final transactionAuthController = Get.find<TransactionAuthController>();
  transactionAuthController.initializeSessionCheck();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final LightningModeController controller = Get.put(LightningModeController());
  final UserAuthDetailsController authController =
      Get.find<UserAuthDetailsController>();
  // 🆕 Get transaction auth controller
  late TransactionAuthController transactionAuthController;

  Brightness? _currentBrightness;
  Timer? _timer;
  String? _initialRoutes;

  @override
  void initState() {
    super.initState();
    // 🆕 Get the controller
    transactionAuthController = Get.find<TransactionAuthController>();

    // Register as an observer to listen for app lifecycle changes
    WidgetsBinding.instance.addObserver(this);

    // Initial system brightness check
    _currentBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;

    _checkToken();
  }

  // 🆕 NEW: Listen for app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    print('===== APP LIFECYCLE: $state =====');

    if (state == AppLifecycleState.resumed) {
      // App came to foreground - check session based on login mode
      print('App resumed - checking session validity');
      _checkSessionOnAppResume();
    } else if (state == AppLifecycleState.paused) {
      // App went to background (user left the app)
      print('App paused - recording pause time');
      _recordAppPause();
    } else if (state == AppLifecycleState.detached) {
      // App is being closed
      print('App detached/closed');
    }
  }

  // 🆕 NEW: Record when app goes to background
  Future<void> _recordAppPause() async {
    String loginMode = await transactionAuthController.getLoginSecurityMode();
    print('_recordAppPause: Login mode is $loginMode');

    // Only record pause time for 60-minute and password-always modes
    if (loginMode == 'password_free_60' || loginMode == 'password_always') {
      await transactionAuthController.recordAppPauseTime();
    }

    // PASSWORD-FREE mode doesn't track pause time (no logout ever)
  }

  // 🆕 NEW: Check session when app comes to foreground
  Future<void> _checkSessionOnAppResume() async {
    bool isSessionValid =
        await transactionAuthController.checkSessionOnAppResume();

    if (!isSessionValid) {
      print('_checkSessionOnAppResume: Session expired, navigating to login');
      // Show snackbar indicating session expired
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your session has expired. Please log in again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );

      // Navigate to login screen with biometric option if enabled
      bool isBiometricEnabled =
          await transactionAuthController.canUseBiometrics();

      Get.offAllNamed(
        RoutesConstant.signin,
        arguments: {
          'showBiometric': isBiometricEnabled,
          'sessionExpired': true,
        },
      );
    }
  }

  void _checkToken() async {
    String? user_has = await SecureStorageService().getData('user_has');

    print("where to naviage to $user_has");
    if (user_has != null) {
      if (user_has == "log_out") {
        setState(() {
          _initialRoutes = RoutesConstant.signin;
        });
      } else {
        setState(() {
          _initialRoutes = RoutesConstant.home;
        });
        // 🆕 Record login time when user is already logged in (app restart)
        await transactionAuthController.recordLoginTime();
      }
    } else {
      print("going to splash");
      setState(() {
        _initialRoutes = RoutesConstant.splash;
      });
    }
  }

  @override
  void dispose() {
    // 🆕 Dispose session timer
    transactionAuthController.disposeSessionCheck();

    // Remove observer when the widget is disposed of
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Wait for route to be determined before building
    if (_initialRoutes == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return GetMaterialApp(
        title: 'Royal Exchange',
        debugShowCheckedModeBanner: false,
        initialRoute: _initialRoutes!,
        theme: ThemeData(fontFamily: "Urbanist"),
        getPages: AppRoutes.routes);
  }
}
