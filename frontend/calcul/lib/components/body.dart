import 'package:flutter/material.dart';
import 'package:calcul/components/search_box.dart';
import 'package:calcul/components/category_list.dart';
import 'package:calcul/components/discount_card.dart';
import 'package:calcul/components/item_list.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SearchBox(
            onChanged: (value) {},
          ),
          CategoryList(),
          ItemList(),
          DiscountCard(),
        ],
      ),
    );
  }
}
