// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../model/wordpress.dart';

class ArticleOverview extends StatefulWidget {
  const ArticleOverview({super.key, required this.data});
  final Map data;

  @override
  State<ArticleOverview> createState() => _ArticleOverviewState();
}

class _ArticleOverviewState extends State<ArticleOverview> {
  dynamic user;
  @override
  Widget build(BuildContext context) {
    String html = widget.data['content']['rendered'];
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: HexColor("#002D3B"),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: HexColor("#FAFAFA"),
          toolbarHeight: 80,
          elevation: 0.0,
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: HexColor("#CFE5DD"),
                    ),
                    child: const Text(
                      'Artikel',
                      style: TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 350,
                      // color: Colors.amber,
                      // height: 100,
                      // margin: EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        widget.data['title']['rendered'],
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                      child: SizedBox(
                        // height: 200,
                        width: 320,
                        child: (widget.data['_embedded'] != null)
                            ? Image.network(
                                widget.data['_embedded']['wp:featuredmedia'][0]['media_details']['sizes']['medium']['source_url'],
                                loadingBuilder: ((context, child, progress) {
                                  return progress == null ? child : LinearProgressIndicator();
                                }),
                                fit: BoxFit.fitWidth,
                              )
                            : FutureBuilder(
                                future: ImagePost.getImage(widget.data['featured_media']),
                                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.hasData) {
                                    Map image = snapshot.data;
                                    return SizedBox(
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
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 320,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: HtmlWidget(
                        html,
                        textStyle: TextStyle(),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}

Widget Profile(label, value) {
  return TextFormField(
    initialValue: value,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      filled: true,
      labelText: label,
      contentPadding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 10,
      ),
    ),
  );
}
