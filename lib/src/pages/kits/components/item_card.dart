import 'package:flutter/material.dart';

import 'package:flutter_ecoshops/src/pages/details/details_screen.dart';
import 'package:flutter_ecoshops/models/product.dart';
import 'package:flutter_ecoshops/constants.dart';

class ItemCard extends StatelessWidget {
  final Product product;
  //final void Function() press;
  const ItemCard({
    Key? key,
    required this.product,
    //required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        'details',
        arguments: ProductDetailsArguments(product: product),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              // For  demo we use fixed height  and width
              // Now we dont need them
              // height: 180,
              // width: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Hero(
                tag: "${product.id}",
                child: Image.network(
                  "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
            child: Text(
              // products is out demo list
              product.nameProd,
              style: TextStyle(color: kTextLightColor),
            ),
          ),
          Column(
            children: [
              Text(
                "\$${product.price}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.lineThrough),
              ),
            ],
          ),
          Text(
            "\$${(product.price * 0.9).toInt()}",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
