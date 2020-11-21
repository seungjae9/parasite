import 'package:calcul/model/pest_model.dart';
import 'package:flutter/material.dart';
import 'package:calcul/constants.dart';
import 'package:calcul/screens/details/components/item_image.dart';
import 'package:calcul/screens/details/components/title_price_rating.dart';
import 'dart:convert';

class Pest_Detail extends StatelessWidget {
  Pest pest;

  Pest_Detail(this.pest);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ItemImage(
          imgSrc: pest.sickImg,
        ),
        Expanded(
          child: ItemInfo(pest),
        ),
      ]
    );
  }
}

class ItemInfo extends StatelessWidget {

  Pest pest;

  ItemInfo(this.pest);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: <Widget>[
          shopeName(name: "병해충 세부 정보"),
          TitlePriceRating(
            name: pest.sickName,
            numOfReviews: 4,
            rating: 4,
            price: 10,
            onRatingChanged: (value) {},
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Text(
                pest.preventMethod.replaceAll('<br/>', ''),

              ),
            ),
          ),
          if (pest.pestiDatas.length >=1)    Expanded(
            child: ListView(
                children: <Widget>[
                  for (var pesti in pest.pestiDatas)
                    ListTile(
                      title: Center(child: Text(pesti.pestiName, style: TextStyle(color: Colors.black, fontSize: 21, fontWeight: FontWeight.bold,))),
                      onTap: () => _showDialog(context, '${pesti.pestiName}을 준비하세요'),
                    )
                ]
            ),
          )
       ],
      ),
    );
  }

  void _showDialog(BuildContext context, String text) {
    // 경고창을 보여주는 가장 흔한 방법.
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('선택 완료!'),
            content: Text('$text 항목을 선택했습니다.'),
            // 주석으로 막아놓은 actions 매개변수도 확인해 볼 것.
            // actions: <Widget>[
            //     FlatButton(child: Text('확인'), onPressed: () => Navigator.pop(context)),
            // ],
          );
        }
    );
  }

  Row shopeName({String name}) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.location_on,
          color: ksecondaryColor,
        ),
        SizedBox(width: 10),
        Text(name),
      ],
    );
  }
}
