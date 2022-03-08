import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecoshops/components/product_card.dart';
import 'package:flutter_ecoshops/models/product.dart';

import 'package:flutter_ecoshops/size_config.dart';
import 'package:flutter_ecoshops/src/pages/home/components/popular_products/popular_products_bloc.dart';
import '../section_title.dart';

class PopularProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = PopularProductsBloc();
    return FutureBuilder<List<dynamic>>(
      future: bloc.getProductos(),
      builder: (context, snapshot) {
        print(snapshot.data);
        if (!snapshot.hasData) {
          return Text(
            'No products yet...',
          );
        } else {
          final List data = snapshot.data!;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child:
                    SectionTitle(title: "Productos Destacados", press: () {}),
              ),
              SizedBox(height: getProportionateScreenWidth(20)),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: data.map((doc) {
                    var newProduct = new Product.fromMap((doc as dynamic));
                    print(doc);
                    newProduct.id = doc["_id"];
                    return ProductCard(product: newProduct);
                  }).toList(),
                ),
              )
            ],
          );
        }
      },
    );
  }
}
