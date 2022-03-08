import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecoshops/models/models.dart';
import 'package:flutter_ecoshops/repositories/product_repository.dart';
import 'package:image_picker/image_picker.dart';

class ProductsService extends ChangeNotifier {
  final List<Product> products = [];
  final ProductRepository _productRepository = ProductRepository();
  //late Product selectedProduct;

  bool isLoading = true;
  bool isSaving = false;

  ProductsService();

  Future insertProduct(Map prod) async {
    await _productRepository.registerProduct(prod);
  }

  Future uploadPhoto(XFile photo) {
    final resp = _productRepository.uploadPhoto(photo);
    return resp;
  }

  Future<List<Product>> getMyProducts(String entID) async {
    try {
      final productos = await _productRepository.getMyProducts(entID);
      print('productos $productos');
      return productos
          .map<Product>((doc) => Product.fromMap(doc as dynamic))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Product>> getProductsOfCategory(String category) async {
    try {
      final productos =
          await _productRepository.getProductsOfCategory(category);
      print('productos $productos');
      return productos
          .map<Product>((doc) => Product.fromMap(doc as dynamic))
          .toList();
    } catch (e) {
      print('e $e');
      return [];
    }
  }
}
