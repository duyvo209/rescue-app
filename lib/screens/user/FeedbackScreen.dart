import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescue/blocs/feedback/feedback_bloc.dart';
import 'package:rescue/models/Rescue.dart';
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
              if (_rating != null && _rating != 0 && _rating == 1)
                SizedBox(
                  height: 44,
                  child: Text('???', style: TextStyle(fontSize: 18)),
                ),
              if (_rating != null && _rating != 0 && _rating == 2)
                SizedBox(
                  height: 44,
                  child:
                      Text('Nữa đi, khùng hả', style: TextStyle(fontSize: 18)),
                ),
              if (_rating != null && _rating != 0 && _rating == 3)
                SizedBox(
                  height: 44,
                  child: Text('Ây za, nữa đi', style: TextStyle(fontSize: 18)),
                ),
              if (_rating != null && _rating != 0 && _rating == 4)
                SizedBox(
                  height: 44,
                  child:
                      Text('Cho 5 sao luông', style: TextStyle(fontSize: 18)),
                ),
              if (_rating != null && _rating != 0 && _rating == 5)
                SizedBox(
                  height: 44,
                  child: Text('Wá đã', style: TextStyle(fontSize: 18)),
                ),
              if (_rating == null &&
                  _rating == 0 &&
                  _rating != 1 &&
                  _rating != 2 &&
                  _rating != 3 &&
                  _rating != 4 &&
                  _rating != 5)
                SizedBox.shrink(),
              Container(
                padding: EdgeInsets.fromLTRB(50, 10, 50, 0),
                child: TextFormField(
                  controller: _commentController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Bình luận',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: SizedBox(
                  width: 335,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      _showDialog(context);
                      BlocProvider.of<FeedbackBloc>(context).add(
                        AddFeedback(
                          storeId: widget.feedback.idStore,
                          userId: widget.feedback.idUser,
                          userInfo: widget.feedback.userInfo,
                          rating: _rating,
                          comment: _commentController.text,
                        ),
                      );
                    },
                    child: Text(
                      "Đăng",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueGrey[800],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                    ),
                  ),
                ),
              ),

              // SizedBox(
              //     height: 44,
              //     // child: (_rating != null && _rating != 0)
              //     //     ? Text("You selected $_rating rating",
              //     //         style: TextStyle(fontSize: 18))
              //     //     : SizedBox.shrink())
              //     child: Text();
            ],
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
            content: Text('Cám ơn bạn đã phản hồi về cửa hàng của chúng tôi !'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.blueGrey[800]),
                  ))
            ],
          ));
}
