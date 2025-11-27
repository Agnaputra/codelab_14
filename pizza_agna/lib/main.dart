import 'package:flutter/material.dart';
// Sesuaikan import ini dengan nama file Anda jika berbeda
import 'httphelper.dart'; 
import 'pizza.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Q1: Set tema aplikasi (contoh: deep purple)
    return MaterialApp(
      title: 'Pizza List Fetcher',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Ubah warna ini
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'JSON'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Method 8: Memanggil HttpHelper.getPizzaList()
  Future<List<Pizza>> callPizzas() async {
    // Menggunakan Singleton HttpHelper yang didefinisikan di httphelper.dart
    HttpHelper helper = HttpHelper(); 
    List<Pizza> pizzas = await helper.getPizzaList();
    return pizzas;
  }

  // Method 9: Implementasi FutureBuilder di build
  @override
  Widget build(BuildContext context) {
    // Mengambil warna primer dari tema yang telah disetel di MyApp
    final Color appBarColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        // Q1: Ganti title dengan nickname Anda
        title: const Text('JSON by [Agna]'), 
        // Q1: Mengubah application color
        backgroundColor: appBarColor, 
      ),
      body: FutureBuilder<List<Pizza>>(
        future: callPizzas(),
        builder: (BuildContext context, AsyncSnapshot<List<Pizza>> snapshot) {
          // Cek error
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          // Cek loading (data belum tersedia)
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Data berhasil dimuat
          return ListView.builder(
            // itemCound: (snapshot.data == null) ? 0 : snapshot.data!.length,
            // Karena kita sudah memastikan hasData, kita bisa langsung menggunakan panjang data
            itemCount: snapshot.data!.length, 
            itemBuilder: (BuildContext context, int position) {
              final pizza = snapshot.data![position];
              return ListTile(
                // title: pizzaName
                title: Text(pizza.pizzaName),
                // subtitle: description + ' - €' + price
                subtitle: Text(
                  '${pizza.description} - €${pizza.price.toStringAsFixed(2)}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}