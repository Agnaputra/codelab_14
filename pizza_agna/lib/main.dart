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
  
  // Fungsi untuk memuat ulang data dari server
  Future<List<Pizza>> callPizzas() async {
    List<Pizza> pizzas = await helper.getPizzaList();
    return pizzas;
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
              final Pizza currentPizza = snapshot.data![position];
              return ListTile(
                title: Text(currentPizza.pizzaName),
                subtitle: Text(
                  '${currentPizza.description} - €${currentPizza.price?.toStringAsFixed(2) ?? 'N/A'}',
                ),
                // ✅ onTap untuk EDIT (PUT)
                onTap: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                         builder: (context) => PizzaDetailScreen(
                            pizza: currentPizza, // Teruskan objek pizza yang ada
                            isNew: false)),      // Set isNew = false
                    );
                },
              );
            },
          );
        },
      ),
      
      // ✅ FloatingActionButton untuk TAMBAH BARU (POST)
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,............................



























































































































































































































































            
            MaterialPageRoute(
                builder: (context) => PizzaDetailScreen(
                      pizza: Pizza(
                        pizzaName: '', 
                        description: '',
                      ), 
                      isNew: true, // Set isNew = true
                    )),
          );
        },
      ),
    );
  }
}