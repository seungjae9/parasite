import 'package:calcul/top_drawer.dart';
import 'package:flutter/material.dart';
import 'package:calcul/constants.dart';
import 'package:calcul/screens/details/components/app_bar.dart';
import 'package:calcul/screens/details/components/body.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: detailsAppBar(),
      resizeToAvoidBottomInset : false,
      body: Body(),
      endDrawer: MyDrawer(),
    );
  }
}
