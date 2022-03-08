import 'package:flutter/material.dart';
import 'package:flutter_ecoshops/models/models.dart';

import 'product.dart';

class Cart {
  final Product product;
  final int numOfItem;

  Cart({required this.product, required this.numOfItem});
}
