import 'dart:convert';

class Product {
  Product({
    required this.categoryProd,
    required this.descp,
    required this.idEntrepreneurship,
    required this.image,
    required this.nameProd,
    required this.price,
    required this.stock,
    this.id,
    this.isFavourite = false,
  });

  String? categoryProd;
  String descp;
  String idEntrepreneurship;
  String image;
  String nameProd;
  int price;
  int stock;
  String? id;
  bool isFavourite;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
      id: json["_id"],
      categoryProd: json["cat"],
      descp: json["descp"],
      idEntrepreneurship: json["id_emprendimiento"],
      image: json["image"] ?? '',
      nameProd: json["name_prod"],
      price: int.parse(json["price"]),
      stock: int.parse(json["stock"]),
      isFavourite: json["is_favourite"] == "true");

  Map<String, dynamic> toMap() => {
        "category_prod": categoryProd,
        "descp": descp,
        "id_entrepreneurship": idEntrepreneurship,
        "image": image,
        "name_prod": nameProd,
        "price": price,
        "is_favourite": isFavourite,
        "stock": stock,
      };

  Product copy() => Product(
      categoryProd: this.categoryProd,
      descp: this.descp,
      idEntrepreneurship: this.idEntrepreneurship,
      image: this.image,
      nameProd: this.nameProd,
      price: this.price,
      stock: this.stock,
      id: this.id,
      isFavourite: this.isFavourite);
}
