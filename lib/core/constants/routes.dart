class RoutesConstant {
  static const String splash = '/splash';
  static const String splash1 = '/splash1';
  static const String onboarding = '/onboarding';

  //auth
  static const String signin = '/auth_signin';
  static const String signup = '/auth_signup';
  static const String otpverify = '/auth_verify_otp';
  static const String forgotpassword = '/auth_resetpassword_forgot';
  static const String setnewpassword = '/auth_resetpassword_setnew';
  static const String emailVerification = '/email-verification';

  //home
  static const String home = '/';
  static const String notification = '/notifications';
  static const String airtime = '/airtime';
  static const String airtime_details = '/airtime/details';
  static const String airtime_receipt = '/airtime/receipt';
  static const String wallet = '/wallet';

  static const String education = '/education';
  static const String epin = '/epin';

  // In routes.dart
  static const gsubz_recharge_card = '/gsubz-recharge-card';
  static const gsubz_recharge_card_details = '/gsubz-recharge-card-details';
  static const gsubz_recharge_card_receipt = '/gsubz-recharge-card-receipt';

  static const String data = '/data';
  static const String data_details = '/data/details';
  static const String data_receipt = '/data/receipt';

  static const String electricity = '/electricity';
  static const String electricity_details = '/electricity/details';
  static const String electricity_receipt = '/electricity/receipt';

  static const String betting = '/betting';
  static const String betting_details = '/betting/details';
  static const String betting_receipt = '/betting/receipt';

  static const String tv = '/tv';
  static const String tv_details = '/tv/details';
  static const String tv_receipt = '/tv/receipt';

  static const String recent_transaction = '/recent_transactions';

  //profile
  static const String profile = '/profile';
  static const String editprofile = '/profile/edit';
  static const String helpAndFaq = '/profile/helpandfaq';
  static const String withdrawalBank = '/profile/withdrawalbank';

  //profile - security
  static const String profileSecurity = '/profile/secuity';
  static const String profileSecurityChangePin = '/profile/security/changepin';
  static const String profileloginSecurity = '/profile/security/login';

  static const String profileSecurityTermsAndCondition =
      '/profile/security/termsandcondition';

  //giftcard
  static const String giftcard = '/giftcard';
  static const String buy_giftcard = '/giftcard/buy';
  static const String buy_giftcard_field = '/giftcard/buy/inputfield';
  static const String buy_giftcard_field_details =
      '/giftcard/buy/inputfield_details';
  static const String giftCardTransactionDetails =
      '/giftcard/giftcard_transaction_details';

  static const String sell_giftcard = '/giftcard/sell';
  static const String sell_giftcard_field = '/giftcard/sell/inputfield';
  static const String sell_giftcard_field_details =
      '/giftcard/sell/inputfield_details';

  //crypto
  static const String crypto = '/crypto';
  static const String buy_crypto = '/crypto/buy';
  static const String buy_crypto_field = '/crypto/buy/inputfield';
  static const String buy_crypto_field_details =
      '/crypto/buy/inputfield_details';
  static const String cryptoTransactionDetails =
      '/crypto/crypto_transaction_details';

  static const String sell_crypto = '/crypto/sell';
  static const String sell_crypto_field = '/crypto/sell/inputfield';
  static const String sell_crypto_field_details =
      '/giftcard/sell/inputfield_details';

  //wallet
  static const String withdraw = '/withdraw';
  static const String wallet_transaction_details =
      '/wallet-transaction-details';

  //deposit
  static const String deposit = '/deposit';

  //flight
  static const String flight_booking = '/flight_booking';
  static const String flight_booking_history = '/flight_booking_history';

  // Gsubz Data routes
  static const String gsubz_data = '/gsubz-data';
  static const String gsubz_data_details = '/gsubz-data-details';
  static const String gsubz_data_receipt = '/gsubz-data-receipt';

  // Gsubz Exam Pin routes
  static const String gsubz_exam_pin = '/gsubz-exam-pin';
  static const String gsubz_exam_pin_details = '/gsubz-exam-pin-details';
  static const String gsubz_exam_pin_receipt = '/gsubz-exam-pin-receipt';
}
