import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pizza.dart'; 

class HttpHelper {
  final String authority = 'zvy8d.wiremockapi.cloud'; 
  final String path = 'pizzalist';

  // Implementasi Singleton
  static final HttpHelper _httpHelper = HttpHelper._internal();
  factory HttpHelper() {
    return _httpHelper;
  }
  HttpHelper._internal() {}

  // Metode GET
  Future<List<Pizza>> getPizzaList() async {
    final Uri url = Uri.https(authority, path);
    final http.Response result = await http.get(url);

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      List<Pizza> pizzas =
          jsonResponse.map<Pizza>((i) => Pizza.fromJson(i)).toList();
      return pizzas;
    } else {
      print('GET Request Failed with status: ${result.statusCode}');
      return [];
    }
  }

  // Metode POST
  Future<String> postPizza(Pizza pizza) async {
    const postPath = '/pizza';
    String post = json.encode(pizza.toJson()); 
    Uri url = Uri.https(authority, postPath);
    
    http.Response r = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: post,
    );
    return r.body; 
  }

  // Metode PUT
  Future<String> putPizza(Pizza pizza) async {
    const putPath = '/pizza';
    String put = json.encode(pizza.toJson());
    Uri url = Uri.https(authority, putPath);
    
    http.Response r = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: put,
    );
    return r.body;
  }
  
  // ✅ Metode DELETE (Praktikum 4)
  Future<String> deletePizza(int id) async {
    // Catatan: Dalam API REST nyata, path biasanya /pizza/{id}
    const deletePath = '/pizza'; 
    Uri url = Uri.https(authority, deletePath);
    
    http.Response r = await http.delete( // Menggunakan http.delete
      url,
    );
    return r.body;
  }
}