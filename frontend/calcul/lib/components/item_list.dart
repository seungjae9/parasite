import 'package:flutter/material.dart';
import 'package:calcul/screens/details/details-screen.dart';
import 'package:calcul/components/item_card.dart';

class ItemList extends StatelessWidget {
  const ItemList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          ItemCard(
            svgSrc: "assets/icons/Following.svg",
            title: "탄저병",
            shopName: "",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DetailsScreen();
                  },
                ),
              );
            },
          ),
          ItemCard(
            svgSrc: "assets/icons/Following.svg",
            title: "갈색무늬병",
            shopName: "",
            press: () {},
          ),
          ItemCard(
            svgSrc: "assets/icons/Following.svg",
            title: "겹무늬썩음병",
            shopName: "",
            press: () {},
          ),
          ItemCard(
            svgSrc: "assets/icons/Following.svg",
            title: "고두병",
            shopName: "",
            press: () {},
          ),
          ItemCard(
            svgSrc: "assets/icons/Following.svg",
            title: "고접병",
            shopName: "",
            press: () {},
          ),
          ItemCard(
            svgSrc: "assets/icons/Following.svg",
            title: "과수화상병",
            shopName: "",
            press: () {},
          )
        ],
      ),
    );
  }
}
