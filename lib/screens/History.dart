import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescue/blocs/login/login_bloc.dart';
import 'package:rescue/blocs/request/request_bloc.dart';

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
                        margin: const EdgeInsets.only(bottom: 30),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        color: Colors.blueGrey[800],
                        height: 120,

                        // decoration: BoxDecoration(
                        //     color: Colors.blueGrey[800],
                        //     borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  '${state.request[index].idStore}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${state.request[index].problem}',
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
                // Expanded(
                //   child: ListView(
                //     children: List.generate(state.request.length, (index) {
                //       var request = state.request[index];
                //       if (user != null) {
                //         return ExpandablePanel(
                //           header: Container(
                //             height: 2.4,
                //             child: Text(
                //               '${request.idUser}',
                //               textAlign: TextAlign.center,
                //               style: TextStyle(
                //                 height: 2.4,
                //               ),
                //             ),
                //           ),
                //           expanded: Container(
                //             decoration: BoxDecoration(
                //               color: Colors.grey[200],
                //               borderRadius: BorderRadius.circular(8),
                //             ),
                //             margin: EdgeInsets.only(left: 36, right: 36),
                //             child: Column(
                //               children: [
                //                 Padding(
                //                   padding:
                //                       const EdgeInsets.symmetric(horizontal: 8),
                //                   child: Container(
                //                     alignment: Alignment.center,
                //                     child: Column(
                //                       crossAxisAlignment:
                //                           CrossAxisAlignment.start,
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.center,
                //                       children: <Widget>[
                //                         SizedBox(
                //                           height: 20,
                //                         ),
                //                         Align(
                //                           alignment: Alignment.center,
                //                           child: Text('${request.idStore}'),
                //                         ),
                //                         SizedBox(
                //                           height: 10,
                //                         ),
                //                         Align(
                //                           alignment: Alignment.center,
                //                           child: Text('${request.problem}'),
                //                         ),
                //                         SizedBox(
                //                           height: 10,
                //                         ),
                //                         if (request.status == 0)
                //                           Align(
                //                             alignment: Alignment.center,
                //                             child: Text('Chờ xác nhận'),
                //                           ),
                //                         if (request.status == 1)
                //                           Align(
                //                             alignment: Alignment.center,
                //                             child: Text('Đã xác nhận'),
                //                           ),
                //                         SizedBox(
                //                           height: 10,
                //                         ),
                //                         Align(
                //                           alignment: Alignment.center,
                //                           child: Text('${request.time}'),
                //                         ),
                //                         SizedBox(
                //                           height: 20,
                //                         )
                //                       ],
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         );
                //       } else {
                //         return Container();
                //       }
                //     }),
                //   ),
                // )
              ],
            ),
          ),
        );
      },
    );
  }
}
