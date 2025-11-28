class Pizza {
  int? id;
  String pizzaName;
  String description;
  double? price;
  String? imageUrl;
  
  // Field untuk Pertanyaan 2
  bool isVegetarian; 

  Pizza({
    this.id,
    required this.pizzaName,
    required this.description,
    this.price,
    this.imageUrl,
    this.isVegetarian = false,
  });

  factory Pizza.fromJson(Map<String, dynamic> json) {
    return Pizza(
      id: json['id'] as int?,
      pizzaName: json['pizzaName'] as String,
      description: json['description'] as String,
      price: json['price'] is int 
          ? (json['price'] as int).toDouble() 
          : json['price'] as double?,
      imageUrl: json['imageUrl'] as String?,
      isVegetarian: json['isVegetarian'] as bool? ?? false, 
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'pizzaName': pizzaName,
    'description': description,
    'price': price,
    'imageUrl': imageUrl,
    'isVegetarian': isVegetarian,
  };
}