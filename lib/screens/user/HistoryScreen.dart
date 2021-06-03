import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescue/blocs/login/login_bloc.dart';
import 'package:rescue/blocs/request/request_bloc.dart';
import 'package:rescue/models/Rescue.dart';
import 'package:rescue/screens/user/CheckOutScreen.dart';
import 'package:easy_localization/easy_localization.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var user;
  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<LoginBloc>(context).state.user;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Lịch sử cứu hộ'.tr().toString()),
        backgroundColor: Colors.blueGrey[800],
        brightness: Brightness.light,
        elevation: 0,
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<List<Rescue>>(
          stream: FirebaseFirestore.instance
              .collection('request')
              .where('idUser', isEqualTo: FirebaseAuth.instance.currentUser.uid)
              .orderBy('time', descending: true)
              .snapshots()
              .asyncMap((event) => event.docs.map((e) {
                    var data = Rescue.fromFireStore(e.data());
                    var idRescue = e.id;
                    data.setRequestId(idRescue);
                    return data;
                  }).toList()),
          // .asyncMap((event) => event.docs
          //     .map((e) => Rescue.fromFireStore(e.data()))
          //     .toList()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var requests = snapshot.data;

              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: ListView(
                        children: List.generate(requests.length, (index) {
                          print("status ${requests[index].status}");
                          return Container(
                            margin: const EdgeInsets.only(
                                bottom: 10, left: 20, right: 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            height: 150,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey[800],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '${requests[index].storeName}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    Spacer(),
                                    RaisedButton(
                                      onPressed: () {
                                        requests[index]
                                            .service
                                            .forEach((element) {
                                          // print(element.name);
                                        });
                                        // print(
                                        //     "state ${state.request[index].toMap()}");
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    CheckOutScreen(
                                                      detailStore:
                                                          requests[index],
                                                    )));
                                      },
                                      child:
                                          Text('Xem chi tiết'.tr().toString()),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    requests[index].status == 0
                                        ? SizedBox(
                                            width: 35,
                                            height: 36.5,
                                            child: RaisedButton(
                                              onPressed: () {
                                                _showDialog(context);
                                                BlocProvider.of<RequestBloc>(
                                                        context)
                                                    .add(
                                                  DeleteService(
                                                      requestId: requests[index]
                                                          .idRequest),
                                                );
                                              },
                                              color: Colors.red[900],
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Text(
                                                "X",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                                Text(
                                  '${requests[index].problems.map((e) => e.name).reduce((value, element) => value + element)}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${requests[index].time.toString().substring(0, 10).split('-').reversed.join('/')}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                requests[index].status == 0
                                    ? Text(
                                        'Chưa xác nhận'.tr().toString(),
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : Text(
                                        'Đã xác nhận'.tr().toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          }),
    );
  }

  _showDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title:
                Text('Thành công', style: TextStyle(color: Colors.green[600])),
            content: Text('Bạn thật sự muốn huỷ yêu cầu cứu hộ ?'),
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
