import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _NameField = TextEditingController();

  final TextEditingController _MessageField = TextEditingController();

  final _Firestore = FirebaseFirestore.instance;
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 80,
                ),
                Text(
                  "Messages",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 25),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 450,
                  width: 300,
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: _Firestore.collection('Data').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('err ${snapshot.error}');
                        } else if (snapshot.data == null) {
                          return Text('no Data');
                        }
                        snapshot.data!.docs.first;

                        return ListView.separated(
                            itemCount: snapshot.data!.docs.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider();
                            },
                            itemBuilder: (BuildContext context, int index) =>
                                Cont(snapshot, index));

                        // return Text(snapshot.data!.docs.first
                        //     .data()["first_name"]
                        //     .toString());
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                // Divider(),
                // SizedBox(
                //   height: 10,
                // ),
                Text(
                  "SEND ME A MESSAGE",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    height: 100,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                      color: Color.fromARGB(255, 242, 242, 242),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      controller: _MessageField,
                      expands: true,
                      maxLines: null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Message",
                          contentPadding: EdgeInsets.all(10)),
                    )),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          color: Color.fromARGB(255, 242, 242, 242),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Name",
                              contentPadding: EdgeInsets.all(10)),
                          controller: _NameField,
                        )),
                    IconButton(
                        onPressed: () {
                          sendJob(_NameField, _MessageField);
                        },
                        icon: Icon(
                          Icons.send,
                          color: Color.fromARGB(255, 98, 204, 102),
                        ))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget Cont(snap, int index) {
  return Container(
    height: 120,
    width: 300,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        color: Color.fromARGB(255, 242, 242, 242),
        border: Border.all(width: 1, color: Color.fromARGB(255, 98, 204, 102))),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 14),
              child: Text(
                snap.data!.docs[index].data()["Name"].toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            snap.data!.docs[index].data()["Message"].toString(),
            style: TextStyle(color: Color.fromARGB(255, 61, 61, 61)),
          ),
        )
      ],
    ),
  );
}

void sendJob(TextEditingController Name, TextEditingController Message) async {
  final _fire = FirebaseFirestore.instance;
  DocumentReference Ref = await _fire
      .collection('Data')
      .add({"Name": Name.text.toString(), "Message": Message.text.toString()});
  Name.clear();
  Message.clear();
}
