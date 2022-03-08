import 'package:flutter/material.dart';
import 'package:flutter_ecoshops/categories.dart';
import 'package:flutter_ecoshops/services/categories_services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_ecoshops/size_config.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
              CategoryController.categories.length,
              (index) => CategoryCard(
                  icon: "assets/icons/" + 'Lock' + ".svg",
                  text: CategoryController.categories[index],
                  press: () {
                    CategoryController.selectedCategory =
                        CategoryController.categories[index];
                    print(CategoryController.selectedCategory);
                    setState(() {});
                  })),
        ));
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String? icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: getProportionateScreenWidth(55),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(15)),
              height: getProportionateScreenWidth(45),
              width: getProportionateScreenWidth(45),
              decoration: BoxDecoration(
                color: CategoryController.selectedCategory == text
                    ? Color.fromARGB(255, 80, 172, 26)
                    : Color.fromARGB(255, 182, 228, 130),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(icon!),
            ),
            SizedBox(height: 5),
            Text(text!, textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}
