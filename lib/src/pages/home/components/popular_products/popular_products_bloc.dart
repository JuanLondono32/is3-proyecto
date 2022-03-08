import 'dart:io';

import 'package:flutter_ecoshops/repositories/product_repository.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class PopularProductsBloc {
  final ProductRepository _productRepository = ProductRepository();

  Future<List<dynamic>> getProductos() async {
    final productos = await _productRepository.getProducts();
    print(productos[0].runtimeType);
    print(productos.runtimeType);
    return productos;
  }
}
