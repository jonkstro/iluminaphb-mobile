// ignore_for_file: constant_identifier_names

class Constantes {
  // Essa URL vai servir para autenticar os users
  static const AUTH_URL = 'https://identitytoolkit.googleapis.com/v1/accounts:';
  // A URL que mais vai ser usada, pois é a URL que vai armazenar os dados no realtime db
  static const DATABASE_URL =
      'https://iluminaphb-76321-default-rtdb.firebaseio.com';
  // A chave do projeto vai ser preciso para algumas requisições http. Ex.: autenticar user
  static const CHAVE_PROJETO = 'AIzaSyC2aYWsVPYJ0PaxtgHFVEZrZSpB_g_Ca1E';

  // Keys do EmailJS
  static const EMAILJS_PUBLIC_KEY = 'QPhgrXuJngxyuo7-k';
  static const EMAILJS_PRIVATE_KEY = 'kjk9UNOw8kGcqjuRkooFr';
}
