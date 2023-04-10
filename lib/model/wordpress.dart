import 'dart:convert';

import 'package:http/http.dart' as http;

var wordpressAPI = "https://iotanic.id/wp-json/wp/v2";

class Wordpress {
  static getPosts() async {
    var response = await http.get(
      Uri.parse("$wordpressAPI/posts?_embed"),
      headers: {
        "Accept": "application/json",
      },
    );
    print(response.statusCode);
    return jsonDecode(response.body);
  }
}

class Category {
  static getPostCategory() async {
    var response = await http.get(
      Uri.parse("$wordpressAPI/categories?parent=11"),
      headers: {
        "Accept": "application/json",
      },
    );
    return jsonDecode(response.body);
  }
}

class Post {
  static getPosts(int id) async {
    var response = await http.get(
      Uri.parse("$wordpressAPI/posts?categories=$id"),
      headers: {
        "Accept": "application/json",
      },
    );
    print(id);

    return jsonDecode(response.body);
  }
}

class ImagePost {
  static getImage(int id) async {
    var response = await http.get(
      Uri.parse("https://iotanic.id/wp-json/wp/v2/media/$id"),
      headers: {
        "Accept": "application/json",
      },
    );
    return jsonDecode(response.body);
  }
}
