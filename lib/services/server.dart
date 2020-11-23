import 'dart:io';

import 'package:mime/mime.dart';
import '../services/utilities.dart' as utility;
var server;
startserver(progresshandler) async {
  try{
  server = await HttpServer.bind(InternetAddress.anyIPv4, 8085);
print('started server');
  server.listen((request) async {
    if (request.uri.path != '/fileupload') {
      print('in sample');
      var percent = request.uri.queryParameters['percent'];
      progresshandler(percent);
      request.response
      // ..headers.contentType =
      // new ContentType("text", "plain", charset: "utf-8")
        ..write('Hello World');
      await request.response.close();
      return;
    }
    if (request.uri.path != '/fileupload') {
      //print('in fileupload');
      request.response
        ..headers.contentType = ContentType.html
        ..write('''
          <html>
          <head>
            <title>Image Upload Server</title>
          </head>
          <body>
            <form method="post" action="/fileupload" enctype="multipart/form-data">
              <input type="file" name="fileupload" /><br /><br />
              <input type="file" name="fileupload" /><br /><br />
              <input type="file" name="fileupload" /><br /><br />
              <input type="file" name="fileupload" /><br /><br />
              <button type="submit">Upload to server</button>
            </form>
          </body>
          </html>
        ''');
    } else {
      // accessing /fileupload endpoint
      print('in fileuploading');
      List<int> dataBytes = [];

      await for (var data in request) {
        dataBytes.addAll(data);
      }

      String boundary = request.headers.contentType.parameters['boundary'];
      final transformer = MimeMultipartTransformer(boundary);
      print(utility.getdirectorypath());
      final uploadDirectory =utility.getdirectorypath()+ 'ShareApp';

      final bodyStream = Stream.fromIterable([dataBytes]);
      final parts = await transformer.bind(bodyStream).toList();

      for (var part in parts) {
        print(part.headers);
        final contentDisposition = part.headers['content-disposition'];
        final filename = RegExp(r'filename="([^"]*)"')
            .firstMatch(contentDisposition)
            .group(1);
        final content = await part.toList();

        if (!Directory(uploadDirectory).existsSync()) {
          await Directory(uploadDirectory).create();
        }

        await File('$uploadDirectory/$filename').writeAsBytes(content[0]);
      }
    }

    await request.response.close();
  });
}
  catch(e){
print('error in server');
  }

}
