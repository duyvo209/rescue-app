import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescue/blocs/store/store_bloc.dart';
import 'package:rescue/models/Service.dart';
import 'package:rescue/models/Service.dart';

class ProblemScreen extends StatefulWidget {
  @override
  _ProblemScreenState createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> {
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  var problemController = new TextEditingController();
  List<String> listProblems = [
    "Apple",
    "Armidillo",
    "Actual",
    "Actuary",
    "America",
    "Argentina",
    "Australia",
    "Antarctica",
    "Blueberry",
    "Cheese",
    "Danish",
    "Eclair",
    "Fudge",
    "Granola",
    "Hazelnut",
    "Ice Cream",
    "Jely",
    "Kiwi Fruit",
    "Lamb",
    "Macadamia",
    "Nachos",
    "Oatmeal",
    "Palm Oil",
    "Quail",
    "Rabbit",
    "Salad",
    "T-Bone Steak",
    "Urid Dal",
    "Vanilla",
    "Waffles",
    "Yam",
    "Zest"
  ];

  List<Service> listServiceSelected = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Service>>(
      stream: getListServiceAllStore(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Container(
              margin: EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 4.0,
              ),
              decoration: BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(12.0)),
              child: AutoCompleteTextField(
                key: key,
                controller: problemController,
                suggestions: snapshot.data.map((e) {
                  return e.name;
                }).toList(),
                clearOnSubmit: false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Tìm dịch vụ ...",
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black54,
                  ),
                ),
                itemFilter: (item, query) {
                  return item.toLowerCase().startsWith(query.toLowerCase());
                },
                itemSorter: (a, b) {
                  return a.compareTo(b);
                },
                itemSubmitted: (item) {
                  problemController.text = item;
                },
                itemBuilder: (context, item) {
                  return Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: <Widget>[Text(item)],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

Stream<List<Service>> getListServiceAllStore() {
  return FirebaseFirestore.instance
      .collection('store')
      .doc()
      .collection('service')
      .snapshots()
      .asyncMap((event) {
    return event.docs.map((e) {
      return Service.fromFireStore(e.data());
    }).toList();
  });
}
