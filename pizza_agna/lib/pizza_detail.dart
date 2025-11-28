import 'package:flutter/material.dart';
import 'pizza.dart';
import 'httphelper.dart';
import 'dart:convert';

class PizzaDetailScreen extends StatefulWidget {
  // ✅ Properti baru
  final Pizza pizza;
  final bool isNew;

  // ✅ Constructor baru
  const PizzaDetailScreen(
      {super.key, required this.pizza, required this.isNew}); 

  @override
  State<PizzaDetailScreen> createState() => _PizzaDetailScreenState();
}

class _PizzaDetailScreenState extends State<PizzaDetailScreen> {
  final TextEditingController txtId = TextEditingController();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtPrice = TextEditingController();
  final TextEditingController txtImageUrl = TextEditingController();
  
  bool isVegetarian = false; 
  String operationResult = '';

  // ✅ Override initState
  @override
  void initState() {
    if (!widget.isNew) {
      // Jika mode EDIT (PUT): isi field dengan data pizza lama
      txtId.text = widget.pizza.id?.toString() ?? '';
      txtName.text = widget.pizza.pizzaName;
      txtDescription.text = widget.pizza.description;
      txtPrice.text = widget.pizza.price?.toString() ?? '';
      txtImageUrl.text = widget.pizza.imageUrl ?? '';
      isVegetarian = widget.pizza.isVegetarian;
    } else {
      // Jika mode ADD NEW (POST): set nilai default
      txtId.text = '';
      isVegetarian = false;
    }
    super.initState();
  }
  
  @override
  void dispose() {
    txtId.dispose();
    txtName.dispose();
    txtDescription.dispose();
    txtPrice.dispose();
    txtImageUrl.dispose();
    super.dispose();
  }

  // ✅ savePizza() dengan logika kondisional
  Future savePizza() async {
    HttpHelper helper = HttpHelper();
    
    // 1. Buat objek Pizza dari input UI
    Pizza pizza = Pizza(
      id: int.tryParse(txtId.text), 
      pizzaName: txtName.text,
      description: txtDescription.text,
      price: double.tryParse(txtPrice.text),
      imageUrl: txtImageUrl.text,
      isVegetarian: isVegetarian, 
    );

    // 2. Tentukan apakah POST atau PUT
    final result = await (widget.isNew
        ? helper.postPizza(pizza) // POST jika isNew = true
        : helper.putPizza(pizza));  // PUT jika isNew = false
    
    // 3. Perbarui UI dengan hasil
    setState(() {
      try {
        final jsonResult = json.decode(result);
        operationResult = jsonResult['message'] ?? result;
      } catch (e) {
        operationResult = result;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNew ? 'New Pizza' : 'Edit Pizza'), 
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                operationResult,
                style: TextStyle(
                    backgroundColor: operationResult.contains('updated') || operationResult.contains('posted') ? Colors.green[200] : Colors.grey[200],
                    color: Colors.black),
              ),
              const SizedBox(height: 24),
              
              // Field ID: Penting untuk PUT
              TextField(
                controller: txtId,
                keyboardType: TextInputType.number,
                enabled: !widget.isNew, // ID biasanya tidak bisa diubah saat edit
                decoration: InputDecoration(
                  hintText: 'Insert ID',
                  labelText: 'ID (Wajib untuk Edit)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: txtName,
                decoration: const InputDecoration(hintText: 'Insert Pizza Name', labelText: 'Pizza Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: txtDescription,
                decoration: const InputDecoration(hintText: 'Insert Description', labelText: 'Description', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: txtPrice,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Insert Price', labelText: 'Price', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: txtImageUrl,
                decoration: const InputDecoration(hintText: 'Insert Image Url', labelText: 'Image URL', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Is Vegetarian?'),
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

              // Tombol yang memanggil savePizza()
              ElevatedButton(
                onPressed: savePizza,
                child: Text(widget.isNew ? 'Send Post' : 'Save Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}