import 'package:flutter/material.dart';
import 'pizza.dart';
import 'httphelper.dart';
import 'dart:convert'; // Untuk mengurai respons POST

class PizzaDetailScreen extends StatefulWidget {
  const PizzaDetailScreen({super.key});

  @override
  State<PizzaDetailScreen> createState() => _PizzaDetailScreenState();
}

class _PizzaDetailScreenState extends State<PizzaDetailScreen> {
  // Controllers untuk 5 fields
  final TextEditingController txtId = TextEditingController();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtPrice = TextEditingController();
  final TextEditingController txtImageUrl = TextEditingController();
  
  // State untuk field baru (Pertanyaan 2)
  bool isVegetarian = false; 

  String operationResult = '';

  @override
  void dispose() {
    // Disposal controller untuk mencegah memory leaks
    txtId.dispose();
    txtName.dispose();
    txtDescription.dispose();
    txtPrice.dispose();
    txtImageUrl.dispose();
    super.dispose();
  }

  // Metode POST
  Future postPizza() async {
    HttpHelper helper = HttpHelper();
    
    // 1. Membuat objek Pizza dari input UI
    Pizza pizza = Pizza(
      id: int.tryParse(txtId.text),
      pizzaName: txtName.text,
      description: txtDescription.text,
      price: double.tryParse(txtPrice.text),
      imageUrl: txtImageUrl.text,
      isVegetarian: isVegetarian, // Memasukkan data field baru
    );

    // 2. Memanggil metode postPizza dari HttpHelper
    String result = await helper.postPizza(pizza);
    
    // 3. Memperbarui UI dengan hasil POST
    setState(() {
      try {
        // Mencoba mengurai respons JSON untuk mendapatkan pesan yang bersih
        final jsonResult = json.decode(result);
        operationResult = jsonResult['message'] ?? result;
      } catch (e) {
        // Fallback jika respons bukan JSON
        operationResult = result; 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizza Detail'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Tampilkan hasil POST (misalnya: "The pizza was posted")
              Text(
                operationResult,
                style: TextStyle(
                    backgroundColor: Colors.green[200],
                    color: Colors.black),
              ),
              const SizedBox(height: 24),

              // TextFields untuk input
              TextField(
                controller: txtId,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Insert ID'),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: txtName,
                decoration: const InputDecoration(hintText: 'Insert Pizza Name'),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: txtDescription,
                decoration: const InputDecoration(hintText: 'Insert Description'),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: txtPrice,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Insert Price'),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: txtImageUrl,
                decoration: const InputDecoration(hintText: 'Insert Image Url'),
              ),
              const SizedBox(height: 24),
              
              // 🔥 UI untuk field baru (isVegetarian)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Is Vegetarian? (Q2)'),
                  Switch(
                    value: isVegetarian,
                    onChanged: (bool value) {
                      setState(() {
                        isVegetarian = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Button POST
              ElevatedButton(
                onPressed: postPizza,
                child: const Text('Send Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}