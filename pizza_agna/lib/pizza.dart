class Pizza {
  final String pizzaName;
  final String description;
  final double price;

  Pizza({
    required this.pizzaName,
    required this.description,
    required this.price,
  });

  // Factory constructor untuk membuat objek Pizza dari JSON Map
  factory Pizza.fromJson(Map<String, dynamic> json) {
    return Pizza(
      pizzaName: json['pizzaName'] as String,
      description: json['description'] as String,
      // Pastikan price adalah double
      price: json['price'] is int 
          ? (json['price'] as int).toDouble() 
          : json['price'] as double,
    );
  }
}