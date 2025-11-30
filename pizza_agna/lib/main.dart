import 'package:flutter/material.dart';
import 'httphelper.dart'; 
import 'pizza.dart'; 
import 'pizza_detail.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza List Fetcher',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), 
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
  HttpHelper helper = HttpHelper(); 
  // ✅ State untuk menyimpan Future agar dapat dimuat ulang
  late Future<List<Pizza>> _pizzasFuture;

  @override
  void initState() {
    super.initState();
    _pizzasFuture = helper.getPizzaList(); // Inisialisasi Future
  }

  // Metode untuk memuat ulang data (dipanggil setelah DELETE)
  void _refreshList() {
    setState(() {
      _pizzasFuture = helper.getPizzaList(); // Muat ulang Future
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color appBarColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON by [Agna]'), 
        backgroundColor: appBarColor, 
      ),
      body: FutureBuilder<List<Pizza>>(
        // ✅ Gunakan Future dari state
        future: _pizzasFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Pizza>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
             return const Center(child: Text('No pizzas found.'));
          }
          
          // Data yang akan dimanipulasi secara visual
          final List<Pizza> pizzas = snapshot.data!;

          return ListView.builder(
            itemCount: pizzas.length, 
            itemBuilder: (BuildContext context, int position) {
              final Pizza currentPizza = pizzas[position];
              
              // ✅ Implementasi Dismissible (Praktikum 4)
              return Dismissible(
                // Gunakan ID unik sebagai Key
                key: Key(currentPizza.id?.toString() ?? currentPizza.pizzaName), 
                direction: DismissDirection.startToEnd, // Contoh: geser dari kiri ke kanan
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) async {
                  // 1. Panggil service DELETE ke server Mock
                  HttpHelper helper = HttpHelper();
                  if (currentPizza.id != null) {
                    await helper.deletePizza(currentPizza.id!);
                  }
                  
                  // 2. Hapus item dari list lokal secara visual (diperlukan untuk Dismissible)
                  // Note: Ini dilakukan di tingkat UI. List nyata akan di-refresh.
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${currentPizza.pizzaName} dismissed (API DELETE called)')));
                  
                  // 3. Muat ulang daftar setelah item di-dismiss
                  _refreshList(); 
                },
                
                // Child: ListTile yang sudah ada
                child: ListTile(
                  title: Text(currentPizza.pizzaName),
                  subtitle: Text(
                    '${currentPizza.description} - €${currentPizza.price?.toStringAsFixed(2) ?? 'N/A'}',
                  ),
                  onTap: () {
                     Navigator.push(
                        context,
                        MaterialPageRoute(
                           builder: (context) => PizzaDetailScreen(
                              pizza: currentPizza, 
                              isNew: false)),      
                      ).then((_) => _refreshList()); // Refresh list setelah kembali dari detail
                  },
                ),
              );
            },
          );
        },
      ),
      
      // FloatingActionButton untuk Tambah Baru
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PizzaDetailScreen(
                      pizza: Pizza(
                        pizzaName: '', 
                        description: '',
                      ), 
                      isNew: true,
                    )),
          ).then((_) => _refreshList()); // Refresh list setelah kembali dari detail
        },
      ),
    );
  }
}