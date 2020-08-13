import 'package:flutter/material.dart';
import 'package:rmol_network_app/core/models/category_model.dart';

class CategoryHorizontalItem extends StatelessWidget {
  const CategoryHorizontalItem({
    Key key,
    @required this.categorySelected,
    @required this.category,
  }) : super(key: key);

  final Category categorySelected;
  final Category category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: categorySelected.nameSlug == category.nameSlug ? Colors.red : Colors.transparent, width: 2))
      ),
      child: Text(
        category.name,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: categorySelected.id == category.id ? FontWeight.w700 : FontWeight.w400
        ),
      ),
    );
  }
}