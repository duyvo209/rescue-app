import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rescue/screens/store/ChatDetailTest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatTest extends StatefulWidget {
  @override
  State createState() => _ChatTestState();
}

class _ChatTestState extends State<ChatTest> {
  String userId;
  @override
  void initState() {
    getUserId();
    super.initState();
  }

  getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    userId = sharedPreferences.getString('id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Tin nhắn'),
        backgroundColor: Colors.blueGrey[800],
        brightness: Brightness.light,
        elevation: 0,
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (listContext, index) =>
                  buildItem(snapshot.data.docs[index]),
              itemCount: snapshot.data.docs.length,
            );
          }
          return Container();
        },
      ),
    );
  }

  buildItem(doc) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatDetailTest(
                      docs: doc,
                    )));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    // backgroundImage: AssetImage(widget.image),
                    backgroundImage: NetworkImage('${doc['image']}'),
                    maxRadius: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(doc['name']),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            'aaa',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Text(
            //   widget.time,
            //   style: TextStyle(
            //       fontSize: 12,
            //       color:
            //           ? Colors.pink
            //           : Colors.grey.shade500),
            // ),
          ],
        ),
      ),
      // child: Card(
      //   color: Colors.lightBlue,
      //   child: Center(
      //     child: Text(doc['name']),
      //   ),
      // ),
    );
  }
}
