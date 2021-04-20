import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescue/blocs/login/login_bloc.dart';
import 'package:rescue/blocs/request/request_bloc.dart';
import 'package:rescue/screens/user/CheckOutScreen.dart';

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
    BlocProvider.of<RequestBloc>(context).add(
      GetListRequest(context),
    );
  }

  Widget build(BuildContext context) {
    return BlocBuilder<RequestBloc, RequestState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Lịch sử cứu hộ'),
            backgroundColor: Colors.blueGrey[800],
            brightness: Brightness.light,
            elevation: 0,
            actionsIconTheme: IconThemeData(color: Colors.white),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: ListView(
                    children: List.generate(state.request.length, (index) {
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
                                  '${state.request[index].storeName}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                Spacer(),
                                RaisedButton(
                                  onPressed: () {
                                    state.request[index].service
                                        .forEach((element) {
                                      print(element.name);
                                    });
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                CheckOutScreen(
                                                  detailStore:
                                                      state.request[index],
                                                )));
                                  },
                                  child: Text('Xem chi tiết'),
                                )
                              ],
                            ),
                            Text(
                              '${state.request[index].problems.map((e) => e.name).reduce((value, element) => value + element)}',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${state.request[index].time}',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            if (state.request[index].status == 0)
                              Text(
                                'Chưa xác nhận',
                                style: TextStyle(color: Colors.white),
                              ),
                            if (state.request[index].status == 1)
                              Text(
                                'Đã xác nhận',
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
          ),
        );
      },
    );
  }
}
