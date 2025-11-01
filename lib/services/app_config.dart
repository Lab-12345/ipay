import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static late final String baseUrl;
  static const Duration connectionTimeout = Duration(seconds: 30);
  static late final String cyrusMemberId;
  static late final String cyrusPin;
  static late final String cyrusOperatorPassword;
  static late final String cyrusDthPassword;
  static late final String cyrusOfferPassword;
  static late final String cyrusBillPassword;
  static late final String cyrusCallbackUrl;

  static Future<void> initialize() async {
    if (kIsWeb) {
      // For web, use the Render backend URL.
      baseUrl = 'https://ipay-nvwy.onrender.com'; 
      cyrusMemberId = 'AP338160';
      cyrusPin = 'FFC8788E3C';
      cyrusOperatorPassword = 'qaweqw234sdfsdsd';
      cyrusDthPassword = 'GSHDGuywe3473';
      cyrusOfferPassword = 'sdf54f45dfh845dhut38';
      cyrusBillPassword = 'ssuy34mfjhgi88348jhd';
      cyrusCallbackUrl = 'https://ipay-nvwy.onrender.com';
    } else {
      // For mobile, load from .env file
      await dotenv.load(fileName: 'recharge-backend/.env');
      baseUrl = dotenv.env['BASE_URL'] ?? 'https://ipay-nvwy.onrender.com';
      cyrusMemberId = dotenv.env['CYRUS_MEMBER_ID'] ?? 'AP338160';
      cyrusPin = dotenv.env['CYRUS_PIN'] ?? 'FFC8788E3C';
      cyrusOperatorPassword = dotenv.env['CYRUS_OPERATOR_PASSWORD'] ?? 'qaweqw234sdfsdsd';
      cyrusDthPassword = dotenv.env['CYRUS_DTH_PASSWORD'] ?? 'GSHDGuywe3473';
      cyrusOfferPassword = dotenv.env['CYRUS_OFFER_PASSWORD'] ?? 'sdf54f45dfh845dhut38';
      cyrusBillPassword = dotenv.env['CYRUS_BILL_PASSWORD'] ?? 'ssuy34mfjhgi88348jhd';
      cyrusCallbackUrl = dotenv.env['CYRUS_CALLBACK_URL'] ?? '';
    }
  }
}
