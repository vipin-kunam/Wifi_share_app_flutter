import 'package:flutter/material.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/utilities.dart'as utility;
import 'package:wifi_info_plugin/wifi_info_plugin.dart';
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<File> files;
  var internalstoragepath;
   Map params = new Map();
  //static const platform = const MethodChannel('flutter.native/helper');
  final Permission _permission=Permission.storage;

  Future<bool> checkstoragepermissionstatus() async{
    var status=await _permission.status;
    return status==PermissionStatus.granted?true:false;
  }
  Future<bool> askpermissionforstorage() async{
    var status = await _permission.request();
    if(status==PermissionStatus.denied){
print('denied');
return false;
    }
    if(status==PermissionStatus.granted){
      print('granted');
      return true;
    }
}


  Future<bool> getip() async{
    try{
  var wifiObject = await WifiInfoPlugin.wifiDetails;
  print(wifiObject);
  utility.setip(wifiObject.routerIp.toString());
    return true;}
  catch(e){
   utility.showalertDialog(context,"Please connect to receiver's hotspot and click send button");
  }

}

void getinternalstoragepath()async{
  getExternalStorageDirectories(type: StorageDirectory.music).then((value){
    var a=value[0].path.toString();
    internalstoragepath=a.substring(0,a.indexOf('A'));
    print(internalstoragepath);
    utility.setdirectorypath(internalstoragepath);
  });

}
void getfilepathsfromstorage()async{
//  Navigator.pushNamed(context, '/send');
  FilePickerResult result = await FilePicker.platform.pickFiles(allowMultiple: true);

  if(result != null) {
    files = result.paths.map((path) => File(path)).toList();
    print(files);
    try{
      utility.setfiles(files);
      print('caling send');
      print(context);
      getip().then((val){
        print('val');
        print(val);
        if(val!=null)
        Navigator.pushNamed(context, '/send');
      });

     // uploadmultipleimage(files);
    }
    catch(e){
      print(e);
    }

  } else {
    // User canceled the picker
  }
}
  @override
  void initState() {
    print('in init');
    //getip();
    getinternalstoragepath();
    askpermissionforstorage();
    checkstoragepermissionstatus().then((value){
      print('status ${value}');
    });
  }
  @override
  Widget build(BuildContext context) {
//    void methodinvoking() async {
//      String response = "";
//      try {
//        final String result =
//        await platform.invokeMethod('helloFromNativeCode');
//        response = result;
//        print("response " + response);
//      } on PlatformException catch (e) {
//        response = "Failed to Invoke: '${e.message}'.";
//      }
//    }
//
//    print('method');
//    methodinvoking();

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Row(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Padding(
                    child: Container(child:  RaisedButton(
                      onPressed: ()async {
                        checkstoragepermissionstatus().then((value){
                          if(!value){
                            askpermissionforstorage().then((val) {

                              if(!val){
                                utility.showalertDialog(context, 'Please give Storage Permission');
                              }
                              else{
                                getfilepathsfromstorage();
                              }
                            });
                          }
                          else{
                            getfilepathsfromstorage();
                          }

                        });


                      },
                      child: const Text('Send', style: TextStyle(fontSize: 20)),
                      color: Colors.red,
                      textColor: Colors.white,
                    )
                    ),
                    padding: EdgeInsets.all(10.0))),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Padding(
                    child: Container(child:  RaisedButton(
                      onPressed: () {
                        checkstoragepermissionstatus().then((value){
                          if(!value){
                            askpermissionforstorage().then((val) {

                              if(!val){
                                utility.showalertDialog(context, 'Please give Storage Permission');
                              }
                              else{
                                Navigator.pushNamed(context, '/receive');
                              }
                            });
                          }
                          else{
                            Navigator.pushNamed(context, '/receive');
                          }

                        });

                        //
                      },
                      child: const Text('Receive', style: TextStyle(fontSize: 20)),
                      color: Colors.blue,
                      textColor: Colors.white,
                    )
                    ),
                    padding: EdgeInsets.all(10.0)))
          ],
        ),
      ),
    );
  }
}
