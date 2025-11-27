import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pizza.dart'; // Asumsi model Pizza ada di sini

class HttpHelper {
  // PERHATIKAN: Ganti '0222g.mocklab.io' dengan authority
  // dari mock service Anda di WireMock Cloud!
  final String authority = 'zvy8d.wiremockapi.cloud'; 
  final String path = 'pizzalist';

  Future<List<Pizza>> getPizzaList() async {
    final Uri url = Uri.https(authority, path);
    final http.Response result = await http.get(url);

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      // provide a type argument to the map method to avoid type error
      List<Pizza> pizzas = jsonResponse.map<Pizza>((i) => 
        Pizza.fromJson(i)).toList();
      return pizzas;
    } else {
      return [];
    }
  }

  // Implementasi Singleton (Opsional, ada di Gambar 3)
  static final HttpHelper _httpHelper = HttpHelper._internal();
  factory HttpHelper() {
    return _httpHelper;
  }
  HttpHelper._internal() {}
}