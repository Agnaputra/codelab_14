class Pizza {
  // Fields diperluas untuk kebutuhan POST
  int? id;
  String pizzaName;
  String description;
  double? price;
  String? imageUrl;
  
  // 🔥 FIELD BARU UNTUK PERTANYAAN 2
  bool isVegetarian; 

  Pizza({
    this.id,
    required this.pizzaName,
    required this.description,
    this.price,
    this.imageUrl,
    this.isVegetarian = false, // Default value
  });

  // Digunakan untuk mengubah respons JSON (dari GET) menjadi objek Dart
  factory Pizza.fromJson(Map<String, dynamic> json) {
    return Pizza(
      id: json['id'] as int?,
      pizzaName: json['pizzaName'] as String,
      description: json['description'] as String,
      // Handle kasus di mana price mungkin berupa int dari JSON
      price: json['price'] is int 
          ? (json['price'] as int).toDouble() 
          : json['price'] as double?,
      imageUrl: json['imageUrl'] as String?,
      isVegetarian: json['isVegetarian'] as bool? ?? false,
    );
  }

  // 🛠️ Metode ini penting untuk POST, mengubah objek Dart menjadi Map JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'pizzaName': pizzaName,
    'description': description,
    'price': price,
    'imageUrl': imageUrl,
    'isVegetarian': isVegetarian, // Field baru
  };
}