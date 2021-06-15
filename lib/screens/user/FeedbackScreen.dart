import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescue/blocs/feedback/feedback_bloc.dart';
import 'package:rescue/models/Rescue.dart';
import 'package:rescue/screens/user/HomeScreen.dart';
import 'package:rescue/utils/rating.dart';

class FeedbackScreen extends StatefulWidget {
  final Rescue feedback;
  FeedbackScreen(this.feedback);
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _commentController = new TextEditingController();
  int _rating;
  List<String> choice = [];
  @override
  void initState() {
    BlocProvider.of<FeedbackBloc>(context).add(GetListFeedback());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Đánh giá'),
          backgroundColor: Colors.blueGrey[800],
          brightness: Brightness.light,
          elevation: 0,
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(50, 10, 50, 0),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('feedback')
                          .where('userId',
                              isEqualTo: FirebaseAuth.instance.currentUser.uid)
                          .where('storeId', isEqualTo: widget.feedback.idStore)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.docs.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Rating((rating) {
                                    setState(() {
                                      _rating = rating;
                                    });
                                  }, 5),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  if (_rating != null &&
                                      _rating != 0 &&
                                      _rating == 1)
                                    SizedBox(
                                      height: 130,
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 0, right: 0, top: 0),
                                          child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('feedback')
                                                .where('storeId',
                                                    isEqualTo:
                                                        widget.feedback.idStore)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Wrap(
                                                  spacing: 5,
                                                  children: snapshot.data.docs
                                                      .map(
                                                          (DocumentSnapshot e) {
                                                    return Wrap(
                                                      children: [
                                                        e['rating'] == 1
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    if (choice
                                                                        .contains(
                                                                            '${e['comment']}')) {
                                                                      choice.remove(
                                                                          '${e['comment']}');
                                                                      _commentController
                                                                          .text = '';
                                                                    } else {
                                                                      choice.add(
                                                                          '${e['comment']}');
                                                                      _commentController
                                                                              .text =
                                                                          '${e['comment']}';
                                                                    }
                                                                  });
                                                                },
                                                                child:
                                                                    ChoiceChip(
                                                                  label: Text(
                                                                      '${e['comment']}'),
                                                                  selected: choice
                                                                      .contains(
                                                                          '${e['comment']}'),
                                                                ),
                                                              )
                                                            : Text('')
                                                      ],
                                                    );
                                                  }).toList(),
                                                );
                                              }
                                              return Container();
                                            },
                                          )),
                                    ),
                                  if (_rating != null &&
                                      _rating != 0 &&
                                      _rating == 2)
                                    SizedBox(
                                      height: 130,
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 0, right: 0, top: 0),
                                          child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('feedback')
                                                .where('storeId',
                                                    isEqualTo:
                                                        widget.feedback.idStore)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Wrap(
                                                  spacing: 5,
                                                  children: snapshot.data.docs
                                                      .map(
                                                          (DocumentSnapshot e) {
                                                    return Wrap(
                                                      children: [
                                                        e['rating'] == 2
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    if (choice
                                                                        .contains(
                                                                            '${e['comment']}')) {
                                                                      choice.remove(
                                                                          '${e['comment']}');
                                                                      _commentController
                                                                          .text = '';
                                                                    } else {
                                                                      choice.add(
                                                                          '${e['comment']}');
                                                                      _commentController
                                                                              .text =
                                                                          '${e['comment']}';
                                                                    }
                                                                  });
                                                                },
                                                                child:
                                                                    ChoiceChip(
                                                                  label: Text(
                                                                      '${e['comment']}'),
                                                                  selected: choice
                                                                      .contains(
                                                                          '${e['comment']}'),
                                                                ),
                                                              )
                                                            : Text('')
                                                      ],
                                                    );
                                                  }).toList(),
                                                );
                                              }
                                              return Container();
                                            },
                                          )),
                                    ),
                                  if (_rating != null &&
                                      _rating != 0 &&
                                      _rating == 3)
                                    SizedBox(
                                      height: 130,
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 0, right: 0, top: 0),
                                          child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('feedback')
                                                .where('storeId',
                                                    isEqualTo:
                                                        widget.feedback.idStore)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Wrap(
                                                  spacing: 5,
                                                  children: snapshot.data.docs
                                                      .map(
                                                          (DocumentSnapshot e) {
                                                    return Wrap(
                                                      children: [
                                                        e['rating'] == 3
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    if (choice
                                                                        .contains(
                                                                            '${e['comment']}')) {
                                                                      choice.remove(
                                                                          '${e['comment']}');
                                                                      _commentController
                                                                          .text = '';
                                                                    } else {
                                                                      choice.add(
                                                                          '${e['comment']}');
                                                                      _commentController
                                                                              .text =
                                                                          '${e['comment']}';
                                                                    }
                                                                  });
                                                                },
                                                                child:
                                                                    ChoiceChip(
                                                                  label: Text(
                                                                      '${e['comment']}'),
                                                                  selected: choice
                                                                      .contains(
                                                                          '${e['comment']}'),
                                                                ),
                                                              )
                                                            : Text('')
                                                      ],
                                                    );
                                                  }).toList(),
                                                );
                                              }
                                              return Container();
                                            },
                                          )),
                                    ),
                                  if (_rating != null &&
                                      _rating != 0 &&
                                      _rating == 4)
                                    SizedBox(
                                      height: 130,
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 0, right: 0, top: 0),
                                          child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('feedback')
                                                .where('storeId',
                                                    isEqualTo:
                                                        widget.feedback.idStore)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Wrap(
                                                  spacing: 5,
                                                  children: snapshot.data.docs
                                                      .map(
                                                          (DocumentSnapshot e) {
                                                    return Wrap(
                                                      children: [
                                                        e['rating'] == 4
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    if (choice
                                                                        .contains(
                                                                            '${e['comment']}')) {
                                                                      choice.remove(
                                                                          '${e['comment']}');
                                                                      _commentController
                                                                          .text = '';
                                                                    } else {
                                                                      choice.add(
                                                                          '${e['comment']}');
                                                                      _commentController
                                                                              .text =
                                                                          '${e['comment']}';
                                                                    }
                                                                  });
                                                                },
                                                                child:
                                                                    ChoiceChip(
                                                                  label: Text(
                                                                      '${e['comment']}'),
                                                                  selected: choice
                                                                      .contains(
                                                                          '${e['comment']}'),
                                                                ),
                                                              )
                                                            : Text('')
                                                      ],
                                                    );
                                                  }).toList(),
                                                );
                                              }
                                              return Container();
                                            },
                                          )),
                                    ),
                                  if (_rating != null &&
                                      _rating != 0 &&
                                      _rating == 5)
                                    SizedBox(
                                      height: 130,
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 0, right: 0, top: 0),
                                          child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('feedback')
                                                .where('storeId',
                                                    isEqualTo:
                                                        widget.feedback.idStore)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Wrap(
                                                  spacing: 5,
                                                  children: snapshot.data.docs
                                                      .map(
                                                          (DocumentSnapshot e) {
                                                    return Wrap(
                                                      children: [
                                                        e['rating'] == 5 &&
                                                                e['comment'] !=
                                                                    'Nội dung này đã bị ẩn'
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    if (choice
                                                                        .contains(
                                                                            '${e['comment']}')) {
                                                                      choice.remove(
                                                                          '${e['comment']}');
                                                                      _commentController
                                                                          .text = '';
                                                                    } else {
                                                                      choice.add(
                                                                          '${e['comment']}');
                                                                      _commentController
                                                                              .text =
                                                                          '${e['comment']}';
                                                                    }
                                                                  });
                                                                },
                                                                child:
                                                                    ChoiceChip(
                                                                  label: Text(
                                                                      '${e['comment']}'),
                                                                  selected: choice
                                                                      .contains(
                                                                          '${e['comment']}'),
                                                                ),
                                                              )
                                                            : Text('')
                                                      ],
                                                    );
                                                  }).toList(),
                                                );
                                              }
                                              return Container();
                                            },
                                          )),
                                    ),
                                  if (_rating == null &&
                                      _rating == 0 &&
                                      _rating != 1 &&
                                      _rating != 2 &&
                                      _rating != 3 &&
                                      _rating != 4 &&
                                      _rating != 5)
                                    SizedBox.shrink(),
                                  TextFormField(
                                    controller: _commentController,
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Bình luận',
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 50, 0, 0),
                                    child: SizedBox(
                                      width: 335,
                                      height: 52,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _showDialog(context);
                                          BlocProvider.of<FeedbackBloc>(context)
                                              .add(
                                            AddFeedback(
                                              storeId: widget.feedback.idStore,
                                              userId: widget.feedback.idUser,
                                              userInfo:
                                                  widget.feedback.userInfo,
                                              storeName:
                                                  widget.feedback.storeName,
                                              rating: _rating,
                                              comment: _commentController.text,
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Đăng",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.blueGrey[800],
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6))),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Center(
                              child: Column(
                                children: snapshot.data.docs
                                    .map((DocumentSnapshot feedback) {
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          (feedback['rating'] == 1)
                                              ? Icon(
                                                  Icons.star,
                                                  size: 40,
                                                  color: Colors.orange,
                                                )
                                              : Text(''),
                                          (feedback['rating'] == 2)
                                              ? Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      size: 40,
                                                      color: Colors.orange,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      size: 40,
                                                      color: Colors.orange,
                                                    ),
                                                  ],
                                                )
                                              : Text(''),
                                          (feedback['rating'] == 3)
                                              ? Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      size: 40,
                                                      color: Colors.orange,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      size: 40,
                                                      color: Colors.orange,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      size: 40,
                                                      color: Colors.orange,
                                                    ),
                                                  ],
                                                )
                                              : Text(''),
                                          (feedback['rating'] == 4)
                                              ? Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      size: 40,
                                                      color: Colors.orange,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      size: 40,
                                                      color: Colors.orange,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      size: 40,
                                                      color: Colors.orange,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      size: 40,
                                                      color: Colors.orange,
                                                    ),
                                                  ],
                                                )
                                              : Text(''),
                                          (feedback['rating'] == 5)
                                              ? Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      size: 40,
                                                      color: Colors.orange,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      size: 40,
                                                      color: Colors.orange,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      size: 40,
                                                      color: Colors.orange,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      size: 40,
                                                      color: Colors.orange,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      size: 40,
                                                      color: Colors.orange,
                                                    ),
                                                  ],
                                                )
                                              : Text(''),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        maxLines: null,
                                        readOnly: true,
                                        keyboardType: TextInputType.multiline,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: '${feedback['comment']}',
                                          hintMaxLines: 10,
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            );
                          }
                        }
                        return Container();
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title:
                Text('Thành công', style: TextStyle(color: Colors.green[600])),
            content: Text('Cám ơn bạn đã góp ý về cửa hàng của chúng tôi !'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.blueGrey[800]),
                  ))
            ],
          ));
}
