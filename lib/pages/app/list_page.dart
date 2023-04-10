// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:iotanic_app/model/wordpress.dart';

// Widget
import 'package:iotanic_app/widgets/formbuilder.dart';

import '../overview/article_overview.dart';

class ListItem extends StatefulWidget {
  const ListItem({Key? key}) : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  int _stateCategory = 22;
  bool _isLoading = false;

  void _setCategory(int id) {
    setState(() {
      _isLoading = true;
      _stateCategory = id;
    });
    Timer(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: formSearch(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                height: 50,
                child: FutureBuilder(
                  future: Category.getPostCategory(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            Map category = snapshot.data[index];
                            return Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: BorderSide(color: HexColor("#002D3B"))),
                                  primary: (_stateCategory != category['id']) ? Colors.white : HexColor("#002D3B"),
                                ),
                                child: Text(
                                  category['name'],
                                  style: (_stateCategory == category['id']) ? TextStyle(color: Colors.white) : TextStyle(color: HexColor("#002D3B")),
                                ),
                                onPressed: () {
                                  _setCategory(category['id']);
                                },
                              ),
                            );
                          });
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              child: SizedBox(
                height: 460,
                child: (_isLoading)
                    ? Center()
                    : FutureBuilder(
                        future: Post.getPosts(_stateCategory),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            return (_isLoading)
                                ? Center(child: CircularProgressIndicator())
                                : SizedBox(
                                    height: 134,
                                    width: 330,
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
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
                                              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                                                      child: FutureBuilder(
                                                        future: ImagePost.getImage(posts['featured_media']),
                                                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                                          if (snapshot.hasData) {
                                                            Map image = snapshot.data;
                                                            return SizedBox(
                                                              height: 134,
                                                              width: 350,
                                                              child: Image.network(
                                                                image['media_details']['sizes']['medium']['source_url'],
                                                                loadingBuilder: ((context, child, progress) {
                                                                  return progress == null ? child : LinearProgressIndicator();
                                                                }),
                                                                fit: BoxFit.fitWidth,
                                                              ),
                                                            );
                                                          } else {
                                                            return LinearProgressIndicator();
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 67,
                                                      width: 330,
                                                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                      child: Text(
                                                        posts['title']['rendered'],
                                                        style: const TextStyle(
                                                          fontSize: 19.0,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 330,
                                                      height: 15,
                                                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  );
                          }
                          return Center(child: CircularProgressIndicator());
                        }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
