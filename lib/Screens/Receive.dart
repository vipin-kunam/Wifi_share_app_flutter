import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../services/server.dart';
class ReceiveScreen extends StatefulWidget{
  @override
  _ReceiveScreenState createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> {
  dynamic percentage="0";
  var iscalled=false;
  onuploadprogress(percent){
    print(percent);
    setState(() {
      percentage=percent;
    });
  }
  @override
  void dispose() {
    iscalled=false;
    server.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(!iscalled){
      startserver(onuploadprogress);
      iscalled=true;
    }
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Receive'),

      ),
        body:Center(
         child: CircularPercentIndicator(
            radius: 200,
            lineWidth: 4.0,
            percent: int.parse(percentage.toString().split('.')[0])/100,
            center: Text(percentage.toString().split('.')[0]!='100'?percentage.toString().split('.')[0]+"%":'Done!'),
            progressColor: Colors.red,
          ),
        ),
    );
  }
}