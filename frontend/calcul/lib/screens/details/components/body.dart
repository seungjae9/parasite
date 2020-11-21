import 'package:flutter/material.dart';
import 'package:calcul/constants.dart';
import 'package:calcul/screens/details/components/item_image.dart';
import 'package:calcul/screens/details/components/title_price_rating.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ItemImage(
          imgSrc: "assets/images/burger.png",
        ),
        Expanded(
          child: ItemInfo(),
        ),
      ],
    );
  }
}

class ItemInfo extends StatelessWidget {
  const ItemInfo({
    Key key,
  }) : super(key: key);

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
            name: "탄저병",
            numOfReviews: 4,
            rating: 4,
            price: 10,
            onRatingChanged: (value) {},
          ),
          Text(
            "탄저병은 역병과 더불어 고추에 가장 큰 피해를 주는 병으로 열매가 맺히기 시작하는 6월 상·하순부터 발생하기 시작하여 장마기를 지나 8～9월 고온다습한 조건에서 급속히 증가한다. 탄저병에 의한 수량손실은 연평균 15～60%에 이르는 것으로 알려져 있다. 탄저병균은 빗물에 의해 전파되므로 여름철 잦은 강우와 태풍에 의해 많이 발생한다.",
            style: TextStyle(
              height: 1.5,
            ),
          ),
          SizedBox(height: size.height * 0.07),
          // Free space  10% of total height
          Expanded(
          child: ListView(
            children: <Widget>[
              Container(decoration: BoxDecoration(color: Colors.lightGreen)),
              ListTile(
                title: Center(child: Text('모스피란', style: TextStyle(color: Colors.black, fontSize: 21, fontWeight: FontWeight.bold,))),
                onTap: () => _showDialog(context, '모스피란'),
              ),
              ListTile(
              title: Center(child: Text('베노밀', style: TextStyle(color: Colors.black, fontSize: 21, fontWeight: FontWeight.bold,))),
              onTap: () => _showDialog(context, '베노밀'),
              ),
              ListTile(
                title: Center(child: Text('에이팜', style: TextStyle(color: Colors.black, fontSize: 21, fontWeight: FontWeight.bold,))),
                onTap: () => _showDialog(context, '에이팜'),
              ),
            ],
          ),
          )],
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
