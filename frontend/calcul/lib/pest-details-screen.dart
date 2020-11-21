import 'package:calcul/model/pest_model.dart';
import 'package:calcul/pest_detail.dart';
import 'package:calcul/top_drawer.dart';
import 'package:flutter/material.dart';
import 'package:calcul/constants.dart';
import 'package:calcul/screens/details/components/app_bar.dart';
import 'package:calcul/screens/details/components/body.dart';

class PestDetailScreen extends StatelessWidget {
  Pest pest;
  PestDetailScreen(this.pest);
  @override
  Widget build(BuildContext context) {

//    Map map = ModalRoute.of(context).settings.arguments as Map;
//    Pest pest = map['pest'];
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: (){
//            Navigator.pop(context);
            Navigator.pushNamed(context, '/bug_map');
          },
        ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    ),
      resizeToAvoidBottomInset : false,
      body: Pest_Detail(pest),
      endDrawer: MyDrawer(),
    );
  }
}
