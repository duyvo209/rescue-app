import 'package:flutter/material.dart';
import 'package:rescue/screens/store/LoginStoreScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rescue/screens/user/LoginScreen.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.grey[200],
              Colors.grey[400],
              Colors.grey[600],
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // SizedBox(
            //   height: 50,
            // ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset('assets/vespaa.png'),
                  Text(
                    "dvRescue",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.blue[900],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 350,
            // ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              "Tìm kiếm cửa hàng cứu hộ xe máy gần bạn"
                                  .tr()
                                  .toString(),
                              style: TextStyle(
                                fontSize: 18,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Đăng nhập vào ứng dụng".tr().toString()),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueGrey[800],
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ),
                          // color: Colors.blueGrey[800],
                          child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                "Dành cho người dùng".tr().toString(),
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => LoginStoreScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueGrey[800],
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                "Dành cho cửa hàng".tr().toString(),
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
