
import 'package:path/path.dart';
import 'dart:async';
import 'package:async/async.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'dart:convert';
import '../services/utilities.dart' as utility;
Future uploadmultipleimage(List images,var uploadlistener) async {
  print('in upload');
  //var uri = Uri.parse("");
  //var ip;
  var uri =Uri.parse('http://${utility.getip()}:8085/fileupload');
  var httpClient= new HttpClient();
  final request = await httpClient.postUrl(uri);
  var byteCount = 0;
  //final request = await httpClient.postUrl(Uri.parse(uri));
  MultipartRequest requestMultipart  =  MultipartRequest("", uri);
//    request.headers[''] = '';
//    request.fields['user_id'] = '10';
//    request.fields['post_details'] = 'dfsfdsfsd';
  //multipartFile = new http.MultipartFile("imagefile", stream, length, filename: basename(imageFile.path));
  List<MultipartFile> newList = List<MultipartFile>();
  for (int i = 0; i < images.length; i++) {
    File imageFile = images[i];
    var stream =
    ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var multipartFile = MultipartFile("imagefile", stream, length,
        filename: basename(imageFile.path));
    newList.add(multipartFile);
  }


  requestMultipart .files.addAll(newList);
  var msStream = requestMultipart.finalize();

  var totalByteLength = requestMultipart.contentLength;

  request.contentLength = totalByteLength;
  request.headers.set(
      HttpHeaders.contentTypeHeader, requestMultipart.headers[HttpHeaders.contentTypeHeader]);

  Stream<List<int>> streamUpload = msStream.transform(
    new StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sink.add(data);

        byteCount += data.length;

        print('send bytes ${byteCount} total ${totalByteLength}');
        int a=100;
        uploadlistener((byteCount/totalByteLength)*a );

        // CALL STATUS CALLBACK;

      },
      handleError: (error, stack, sink) {
        throw error;
      },
      handleDone: (sink) {
        sink.close();
        // UPLOAD DONE;
      },
    ),
  );

  await request.addStream(streamUpload);

  final httpResponse = await request.close();
//
  var statusCode = httpResponse.statusCode;

  if (statusCode ~/ 100 != 2) {
    throw Exception('Error uploading file, Status code: ${httpResponse.statusCode}');
  } else {
    if(statusCode==200){
      print('image uploaded');
    }
    return await readResponseAsString(httpResponse);
  }

}
Future<String> readResponseAsString(HttpClientResponse response) {
var completer = new Completer<String>();
var contents = new StringBuffer();
response.transform(utf8.decoder).listen((String data) {
contents.write(data);
}, onDone: () => completer.complete(contents.toString()));
return completer.future;
}