import 'dart:async';

import 'package:calcul/pest-details-screen.dart';
import 'package:calcul/pest_detail.dart';
import 'package:calcul/top_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:calcul/bloc/crop_pest_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:calcul/model/pest_model.dart';
import 'dart:convert';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
   WebviewScaffold webview = WebviewScaffold(
    url: ' http://k02c1021.p.ssafy.io/pages/map',
    geolocationEnabled: true,
//    withZoom: true,
    useWideViewPort: true,
//    displayZoomControls: true,
    withOverviewMode: true,
    resizeToAvoidBottomInset: true,
  );

  final unescape =new HtmlUnescape();
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  final cropPestBloc = CropPestBloc();
  var buttonColor = Colors.green;
  var buttonText = "상세 정보";
  @override
  Widget build(BuildContext context) {
//    flutterWebviewPlugin.onDestroy.listen((event) {
//      print('webview destroyed!');
//      if(Navigator.canPop(context)){
//        Navigator.of(context).pop();
//      }
//    });
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            // appBar 밑에 탭이 붙기 누에 bottom에 TabBar 위젯을 추가해서 사용
            title: Text('병해충 예측 지도'),
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton.icon(
                      onPressed: () async {
                        String doc = await flutterWebviewPlugin.evalJavascript('document.documentElement.innerHTML');
                        doc = unescape.convert(doc);
                        doc = doc.replaceAll('\\u003C', '<').replaceAll('\\"', '"').replaceAll('\\n', '\n');
                        var dom = parse(doc);
                        var cropPest = dom.getElementById('cropPest').innerHtml;
                        var arr = cropPest.split(',');
                        if (arr.length==1) {
                          arr = cropPest.split('의 ');
                        }
                        var crop = arr[0];
                        var pest = arr[1];
                        var response = await http.get('http://k02c1021.p.ssafy.io/pages/$crop/crop/$pest/sicksearch/');
                        if (response.statusCode == 200){
                          Pest pest = Pest.fromJson(json.decode(utf8.decode(response.bodyBytes)));
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PestDetailScreen(pest)));
//                          Navigator.pushNamed(context,'/pest_detail', arguments: <String,Pest>{
//                            'pest': pest
//                          });
                          flutterWebviewPlugin.hide();
                        }
                        else {
//                          print("정보없음!");
                          setState(() {
                            buttonColor = Colors.red;
                            buttonText = "정보 없음!";
                          });
                          Future.delayed(Duration(seconds: 2), (){
                            setState(() {
                              buttonColor = Colors.green;
                              buttonText = "상세 정보";
                            });
                          });

                        }
                      },
                      color: this.buttonColor,
                      icon: const Icon(Icons.assignment),
                      label: Text(this.buttonText))) //
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: webview,
          ),
          endDrawer: MyDrawer(),
        ));
  }
}
