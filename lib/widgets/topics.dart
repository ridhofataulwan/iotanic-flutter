import 'package:flutter/material.dart';

Widget Topics() {
  List<String> topic = [
    'Phonska',
    'Bibit',
    'LoRA',
    'Otomasi',
  ];
  List<String> icon = [
    'assets/icon/fertilizer.png',
    'assets/icon/wheat.png',
    'assets/icon/iot.png',
    'assets/icon/automation.png',
  ];
  return Container(
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
          child: const Text(
            'Topik untuk Anda',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: SizedBox(
            height: 200,
            child: ListView.builder(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      AlertDialog alert = AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            // Icon(Icons.close_outlined),
                            Text("Fitur belum tersedia")
                          ],
                        ),
                      );
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 0),
                              )
                            ],
                          ),
                          width: 70,
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.only(top: 15, bottom: 15, right: 15, left: 15),
                          child: Center(
                            child: Image(image: AssetImage(icon[index])),
                          ),
                        ),
                        Text(topic[index]),
                      ],
                    ),
                  );
                }),
          ),
        ),
      ],
    ),
  );
}
