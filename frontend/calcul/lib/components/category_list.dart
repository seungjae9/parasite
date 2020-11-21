import 'package:flutter/material.dart';
import 'package:calcul/components/category_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({Key key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CategoryItem(
            title: "사과",
            isActive: true,
            press: () {server.getReq();},
          ),
          CategoryItem(
            title: "고추",
            press: () {},
          ),
          CategoryItem(
            title: "배",
            press: () {},
          ),
        ],
      ),
    );
  }
}

class Server {
  Future<void> getReq() async {
    Response response;
    Dio dio = new Dio();
    response = await dio.get('http://k02c1021.p.ssafy.io/pages/datas3');
    print(response.data[0]['crop_name']);
  }
  Future<void> getReqWzQuery() async {
    Response response;
    Dio dio = new Dio();
    response = await dio.get('http://k02c1021.p.ssafy.io/pages/datas3', queryParameters: {
      "crop_name" : 1
    });
    print(response.data.toString());
  }
}

Server server = Server();