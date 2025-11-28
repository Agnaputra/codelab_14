import 'package:flutter/material.dart';
import 'httphelper.dart'; 
import 'pizza.dart'; 
import 'pizza_detail.dart'; // ✅ IMPORT FILE BARU

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
    HttpHelper helper = HttpHelper(); 
    List<Pizza> pizzas = await helper.getPizzaList();
    return pizzas;
  }

  @override
  Widget build(BuildContext context) {
    final Color appBarColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        // Q1: Ganti title dengan nickname Anda
        title: const Text('JSON by [Agna]'), 
        backgroundColor: appBarColor, 
      ),
      body: FutureBuilder<List<Pizza>>(
        future: callPizzas(),
        builder: (BuildContext context, AsyncSnapshot<List<Pizza>> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.length, 
            itemBuilder: (BuildContext context, int position) {
              final pizza = snapshot.data![position];
              return ListTile(
                title: Text(pizza.pizzaName),
                subtitle: Text(
                  '${pizza.description} - €${pizza.price?.toStringAsFixed(2)}',
                ),
              );
            },
          );
        },
      ),
      
      // ✅ FloatingActionButton untuk navigasi ke layar POST
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PizzaDetailScreen()),
          );
        },
      ),
    );
  }
}