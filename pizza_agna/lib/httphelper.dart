import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pizza.dart'; 

class HttpHelper {
  // ✅ AUTHORITY YANG BENAR
  final String authority = 'zvy8d.wiremockapi.cloud'; 
  final String path = 'pizzalist';

  // Implementasi Singleton
  static final HttpHelper _httpHelper = HttpHelper._internal();
  factory HttpHelper() {
    return _httpHelper;
  }
  HttpHelper._internal() {}
  
  // Metode GET (dari Praktikum 1)
  Future<List<Pizza>> getPizzaList() async {
    final Uri url = Uri.https(authority, path);
    final http.Response result = await http.get(url);

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      List<Pizza> pizzas =
          jsonResponse.map<Pizza>((i) => Pizza.fromJson(i)).toList();
      return pizzas;
    } else {
      // Perluas agar bisa log error di console jika diperlukan
      print('GET Request Failed with status: ${result.statusCode}');
      return [];
    }
  }

  // Metode POST (Praktikum 2)
  Future<String> postPizza(Pizza pizza) async {
    const postPath = '/pizza';
    
    // Konversi objek Pizza (termasuk field baru) menjadi JSON String
    String post = json.encode(pizza.toJson()); 
    
    Uri url = Uri.https(authority, postPath);
    
    http.Response r = await http.post(
      url,
      // Penting: Memberi tahu server bahwa kita mengirim JSON
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: post,
    );
    
    // Mengembalikan respons server (yaitu: '{"message": "The pizza was posted"}')
    return r.body;
  }
}