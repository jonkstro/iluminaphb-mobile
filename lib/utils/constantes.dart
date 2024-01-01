// ignore_for_file: constant_identifier_names

class Constantes {
  // A chave do projeto vai ser preciso para algumas requisições http. Ex.: autenticar user
  static const CHAVE_PROJETO = 'AIzaSyAzKZ2kDnwCUeFHK3eEIaRZhkLoGTkxw10';
  // Essa URL vai servir para autenticar os users
  static const AUTH_URL = 'https://identitytoolkit.googleapis.com/v1/accounts:';
  // A URL que mais vai ser usada, pois é a URL que vai armazenar os dados no realtime db
  static const DATABASE_URL =
      'https://iluminaphb-de98d-default-rtdb.firebaseio.com';
}
