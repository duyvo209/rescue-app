import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatDetailTest extends StatefulWidget {
  final docs;
  const ChatDetailTest({Key key, this.docs}) : super(key: key);
  @override
  _ChatDetailTestState createState() => _ChatDetailTestState();
}

class _ChatDetailTestState extends State<ChatDetailTest> {
  String groupChatId;
  String userId;

  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    getGroupChatId();
    super.initState();
  }

  getGroupChatId() async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = FirebaseAuth.instance.currentUser.uid;
    String anotherUserId = widget.docs['idStore'];
    if (userId.compareTo(anotherUserId) > 0) {
      groupChatId = '$userId - $anotherUserId';
    } else {
      groupChatId = '$userId - $anotherUserId';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.docs['name']}'),
        backgroundColor: Colors.blueGrey[800],
        brightness: Brightness.light,
        elevation: 0,
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(groupChatId)
            .collection(groupChatId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10, bottom: 0),
                    controller: scrollController,
                    itemBuilder: (listContext, index) =>
                        buildItem(snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: 16, bottom: 10),
                    height: 100,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 21,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                                hintText: "Nhập tin nhắn...",
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade500),
                                border: InputBorder.none),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            padding: EdgeInsets.only(right: 20, bottom: 23),
                            child: IconButton(
                              icon: Icon(Icons.send),
                              color: Colors.blueGrey[800],
                              iconSize: 30,
                              onPressed: () {
                                sendMsg();
                                textEditingController.clear();
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                // Row(
                //   children: <Widget>[
                //     Expanded(
                //       child: TextField(
                //         controller: textEditingController,
                //       ),
                //     ),
                //     IconButton(
                //         icon: Icon(Icons.send),
                //         onPressed: () {
                //           sendMsg();
                //           textEditingController.clear();
                //         })
                //   ],
                // )
              ],
            );
          } else {
            return Center(
                child: SizedBox(
              height: 36,
              width: 36,
              child: CircularProgressIndicator(),
            ));
          }
        },
      ),
    );
  }

  sendMsg() {
    String msg = textEditingController.text.trim();
    if (msg.isNotEmpty) {
      var ref = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(ref, {
          'senderId': userId,
          'anotherUserId': widget.docs['idStore'],
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': msg,
          'type': 'text',
        });
      });
      scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
    } else {
      print('Please enter some text to send');
    }
  }

  buildItem(doc) {
    // return Padding(
    //   padding: EdgeInsets.only(
    //       top: 8.0,
    //       left: ((doc['senderId'] == userId ? 64 : 0)),
    //       right: ((doc['senderId'] == userId ? 0 : 64))),
    //   child: Container(
    //     width: MediaQuery.of(context).size.width,
    //     padding: const EdgeInsets.all(8.0),
    //     decoration: BoxDecoration(
    //         color: ((doc['senderId'] == userId)
    //             ? Colors.grey
    //             : Colors.greenAccent),
    //         borderRadius: BorderRadius.circular(8.0)),
    //     child: Text('${doc['content']}'),
    //   ),
    // );
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Align(
        alignment:
            doc['senderId'] == userId ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: (doc['senderId'] == userId
                ? Colors.grey.shade200
                : Colors.white),
          ),
          padding: EdgeInsets.all(16),
          child: Text('${doc['content']}'),
        ),
      ),
    );
  }
}
