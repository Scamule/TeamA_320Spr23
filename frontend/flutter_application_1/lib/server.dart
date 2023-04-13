import 'dart:io';
import 'package:http/http.dart' as http;

//the address of the server would go here
String url = '';

//the specific endpoint for user-authentication would go here
String path = '';


Future authenticate(final loginInfo) async{
  final uri = Uri.http(url, path, loginInfo);
  final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
  final response = await http.get(uri, headers: headers);
  if(response.statusCode == 200){
    return response.body;
  } else{
    throw Exception("fetchdata failed on endpoint $url");
  }
}

