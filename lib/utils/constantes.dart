// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constantes {
  // Essa URL vai servir para autenticar os users
  // static const AUTH_URL = 'https://identitytoolkit.googleapis.com/v1/accounts:';
  static String AUTH_URL = dotenv.env['AUTH_URL'] ?? '';
  static String AUTH_REFRESH_URL = dotenv.env['AUTH_REFRESH_URL'] ?? '';
  // A URL que mais vai ser usada, pois é a URL que vai armazenar os dados no realtime db
  static String DATABASE_URL = dotenv.env['DATABASE_URL'] ?? '';
  // A chave do projeto vai ser preciso para algumas requisições http. Ex.: autenticar user
  static String CHAVE_PROJETO = dotenv.env['CHAVE_PROJETO'] ?? '';

  // Keys do EmailJS
  static String EMAILJS_PUBLIC_KEY = dotenv.env['EMAILJS_PUBLIC_KEY'] ?? '';
  static String EMAILJS_PRIVATE_KEY = dotenv.env['EMAILJS_PRIVATE_KEY'] ?? '';
}
