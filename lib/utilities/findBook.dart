import 'dart:convert';
import 'package:http/http.dart' as http;

findBookUrl(String title) async {
  title.toLowerCase().trim();
  String startURL = "https://www.googleapis.com/books/v1/volumes?q=";
  http.Response response = await http.get(startURL + title);
  var data = await jsonDecode(response.body);
  String url;

  url = await data['items'][0]["volumeInfo"]["imageLinks"]["thumbnail"];

  return await url;
}
