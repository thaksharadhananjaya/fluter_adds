import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test/models/model.dart';

import '../config.dart';

class AddsRepo {
  Future<List<Adds>> getAdds(int page) async {

    try {
      String path = "$url/php/getAdds.php";

      var response = await http.post(Uri.parse(path), body: {
        "key": accessKey,
        "page": "$page",
      });



      List<dynamic> list = jsonDecode(response.body);
      List<Adds> postList = [];
      list.map((data) => postList.add(Adds.fromJson(data))).toList();
      print("data $postList");
      return postList.length == 0 ? null : postList;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
