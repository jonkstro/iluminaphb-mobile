import 'package:shared_preferences/shared_preferences.dart';

/*
 Essa classe vai ter os métodos responsáveis por salvar os dados localmente
 no dispositivo na área de persistencia
 */
class Storage {
  // Salvar o código de verificação de email
  static Future<bool> saveCodigo(String key, String codigo) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, codigo);
  }

  // Retornar o código de verificação de email
  static Future<String> getCodigo(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String codigo = prefs.getString(key) ?? '';
    return codigo;
  }
}
