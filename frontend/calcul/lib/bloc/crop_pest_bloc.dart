import 'package:calcul/model/pest_model.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';

class CropPestBloc{

  final _cropPestSubject = BehaviorSubject<Pest>();
  final unescape =new HtmlUnescape();
  CropPestBloc();
  Future<Map<String, String>> getCropPestFromWebview(FlutterWebviewPlugin webviewPlugin) async{
    String doc = await webviewPlugin.evalJavascript('document.documentElement.innerHTML');
    doc = unescape.convert(doc);
    doc = doc.replaceAll('\\u003C', '<').replaceAll('\\"', '"').replaceAll('\\n', '\n');
    var dom = parse(doc);
    var cropPest = dom.getElementById('cropPest').innerHtml;
    var arr = cropPest.split(',');
    return {
      'crop': arr[0],
      'pest': arr[1],
    };
  }

  Future<Pest> fetchData(Map<String,String> cropPest) async {
//    webview.onScrollYChanged.listen((temp) async {
//      String doc = await webview.evalJavascript('document.documentElement.innerHTML');
//      doc = unescape.convert(doc);
//      doc = doc.replaceAll('\\u003C', '<').replaceAll('\\"', '"').replaceAll('\\n', '\n');
//      var dom = parse(doc);
//      var cropPest = dom.getElementById('cropPest').innerHtml;
//      _cropPestSubject.add();
//    });
    var crop = cropPest['crop'];
    var pest = cropPest['pest'];
    var response = await http.get('http://k02c1021.p.ssafy.io/pages/$crop/crop/$pest/sicksearch/');
    if (response.statusCode == 200){
      Pest pest = Pest.fromJson(json.decode(response.body));
      return pest;
    }
  }

  void getCropPest(FlutterWebviewPlugin webviewPlugin) async{
    var checkPest = await getCropPestFromWebview(webviewPlugin);
    var cropPest = await fetchData(checkPest);
    _cropPestSubject.add(cropPest);
  }
  Stream<Pest> get cropPestResult$ => _cropPestSubject.stream;

}