import 'package:flutter/material.dart';
var files;
var uploaddirectory;
var ip;
setip(address){
  ip=address;
}
getip(){
  return ip;
}
setfiles(datafiles){
  files=datafiles;
}
getfiles(){
  return files;
}
setdirectorypath(path){
  uploaddirectory=path;
}
getdirectorypath(){
  return uploaddirectory;
}
void showalertDialog(context,message) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Alert"),
        content: new Text(message),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}