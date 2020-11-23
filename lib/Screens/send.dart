import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../services/utilities.dart'as utility;
import '../services/uploadservice.dart'as upload;
import 'package:http/http.dart' as http;
class SendScreen extends StatefulWidget{
  @override
  _SendScreenState createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  var ip;
var url ='http://${utility.getip()}:8085/sample';
  dynamic percentage=0;
  var iscalled=false;
  onuploadprogress(percent) async{
    setState(() {
      print(percent);
      percentage=percent;
    });
    var response = await http.post(url+'/?percent=${percent}').then((value) => print(value.body)).catchError((err){
      print('in error');
    });
  }
  @override
  void dispose() {
    iscalled=false;
    super.dispose();
  }
  @override
  void initState() {

  }
  @override
  Widget build(BuildContext context) {
    if(!iscalled){
     upload.uploadmultipleimage(utility.getfiles(), onuploadprogress);
      iscalled=true;
    }


    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Send'),

      ),
      body:Center(
        child: CircularPercentIndicator(
          radius: 200,
          lineWidth: 4.0,
          percent: percentage/100,
          center: Text(percentage.toString().split('.')[0]!='100'?percentage.toString().split('.')[0]+"%":'Done!'),
          progressColor: Colors.red,
        ),
      ),
    );
  }
}