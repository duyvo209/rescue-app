import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescue/blocs/store/store_bloc.dart';

class UpdateLocationScreen extends StatefulWidget {
  @override
  _UpdateLocationScreenState createState() => _UpdateLocationScreenState();
}

class _UpdateLocationScreenState extends State<UpdateLocationScreen> {
  final TextEditingController _updateLat = new TextEditingController();
  final TextEditingController _updateLng = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhật vị trí'),
        backgroundColor: Colors.blueGrey[800],
        brightness: Brightness.light,
        elevation: 0,
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(0, 50, 0, 5),
            //   child: Container(
            //     margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            //     decoration: BoxDecoration(
            //         color: Color(0xFFF2F2F2),
            //         borderRadius: BorderRadius.circular(12.0)),
            //     child: TextFormField(
            //       controller: _updateLat,
            //       textInputAction: TextInputAction.next,
            //       decoration: InputDecoration(
            //         border: InputBorder.none,
            //         hintText: "Nhập kinh độ",
            //         contentPadding:
            //             EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            //       ),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            //   child: Container(
            //     margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            //     decoration: BoxDecoration(
            //         color: Color(0xFFF2F2F2),
            //         borderRadius: BorderRadius.circular(12.0)),
            //     child: TextFormField(
            //       controller: _updateLng,
            //       textInputAction: TextInputAction.next,
            //       decoration: InputDecoration(
            //         border: InputBorder.none,
            //         hintText: "Nhập vĩ độ",
            //         contentPadding:
            //             EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 30),
              child: SizedBox(
                width: 360,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<StoreBloc>(context).add(
                      UpdateLocation(
                        storeId: FirebaseAuth.instance.currentUser.uid,
                        lat: 10.028118,
                        lng: 105.773649,
                        // 10.028167, 105.776633
                      ),
                    );
                  },
                  child: Text(
                    'Cập nhật vị trí A',
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: SizedBox(
                width: 360,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<StoreBloc>(context).add(
                      UpdateLocation(
                        storeId: FirebaseAuth.instance.currentUser.uid,
                        lat: 10.028167,
                        lng: 105.776633,
                        // 10.028167, 105.776633
                      ),
                    );
                  },
                  child: Text(
                    'Cập nhật vị trí B',
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: SizedBox(
                width: 360,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<StoreBloc>(context).add(
                      UpdateLocation(
                        storeId: FirebaseAuth.instance.currentUser.uid,
                        lat: double.parse(_updateLat.text),
                        lng: double.parse(_updateLng.text),
                        // 10.028167, 105.776633
                      ),
                    );
                  },
                  child: Text(
                    'Cập nhật vị trí C',
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: SizedBox(
                width: 360,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<StoreBloc>(context).add(
                      UpdateLocation(
                        storeId: FirebaseAuth.instance.currentUser.uid,
                        lat: double.parse(_updateLat.text),
                        lng: double.parse(_updateLng.text),
                        // 10.028167, 105.776633
                      ),
                    );
                  },
                  child: Text(
                    'Cập nhật vị trí D',
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
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
            //   child: SizedBox(
            //     width: 360,
            //     height: 52,
            //     child: ElevatedButton(
            //       onPressed: () {
            //         BlocProvider.of<StoreBloc>(context).add(
            //           UpdateLocation(
            //             storeId: FirebaseAuth.instance.currentUser.uid,
            //             lat: double.parse(_updateLat.text),
            //             lng: double.parse(_updateLng.text),
            //             // 10.028167, 105.776633
            //           ),
            //         );
            //       },
            //       child: Text(
            //         'Cập nhật',
            //         style: TextStyle(color: Colors.white, fontSize: 18),
            //       ),
            //       style: ElevatedButton.styleFrom(
            //         primary: Colors.blueGrey[800],
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.all(Radius.circular(6))),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
