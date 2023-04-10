import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:iotanic_app/model/wordpress.dart';
import 'package:intl/intl.dart';
import 'package:iotanic_app/pages/overview/article_overview.dart';

class Article extends StatefulWidget {
  const Article({Key? key}) : super(key: key);

  @override
  State createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Wordpress.getPosts(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 5) {
            snapshot.data.length = 5;
          }
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Map posts = snapshot.data[index];
                DateTime date = DateTime.parse(posts['date'].replaceAll('T', ' ') + '.000000');
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleOverview(data: posts),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    shadowColor: HexColor("#E4E4E4"),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 134,
                            width: 350,
                            child: Image.network(
                              posts['_embedded']['wp:featuredmedia'][0]['media_details']['sizes']['medium']['source_url'],
                              loadingBuilder: ((context, child, progress) {
                                return progress == null ? child : LinearProgressIndicator();
                              }),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          Container(
                            height: 67,
                            width: 330,
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Text(
                              posts['title']['rendered'],
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            width: 330,
                            height: 15,
                            margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                            child: Row(
                              children: [
                                // Text(DateTime.now().toString()),
                                // Text(posts['date'].replaceAll('T', ' ')),
                                const Icon(Icons.calendar_month_rounded, size: 14.0),
                                const SizedBox(width: 5),
                                Text(
                                  DateFormat("EEEE, d MMMM yyyy", "id_ID").format(date),
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

// dateFormatter(var date) {
//   DateTime dateTime = DateTime.parse(date);
//   var dateformat = DateFormat("dd MMMM yyyy").format(dateTime);
//   return dateformat;
// }
