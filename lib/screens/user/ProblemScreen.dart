import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:rescue/models/Store.dart';
import 'package:rescue/screens/user/InforStoreScreen.dart';

class ProblemScreen extends StatefulWidget {
  @override
  _ProblemScreenState createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> {
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  var problemController = new TextEditingController();
  List<String> listProblems = [];
  bool showListStore = false;
  List<Store> listStore = [];

  @override
  void initState() {
    super.initState();
    _getListService();
  }

  Future<List<String>> _getListService({String query}) async {
    var snapshot = await FirebaseFirestore.instance.collection('store').get();
    var ids = snapshot.docs.map((e) {
      return e.id;
    }).toList();
    List<String> services = [];
    for (int i = 0; i < ids.length; i++) {
      var snapshotService = await FirebaseFirestore.instance
          .collection('store')
          .doc(ids[i])
          .collection('service')
          .get();
      var listServiceId = snapshotService.docs.map((e) => e.id).toList();
      for (int j = 0; j < listServiceId.length; j++) {
        var result = await FirebaseFirestore.instance
            .collection('store')
            .doc(ids[i])
            .collection('service')
            .doc(listServiceId[j])
            .get();
        if (!services.contains(result.data()['name'])) {
          services.add(result.data()['name']);
        }
      }
    }
    setState(() {
      listProblems = services;
    });

    return services
        .where((element) => element.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<Store>> _getListStore({String query}) async {
    var snapshot = await FirebaseFirestore.instance.collection('store').get();
    List<Store> listStore = [];
    List<Store> listStoreQuery = [];
    var ids = snapshot.docs.map((e) {
      return e.id;
    }).toList();
    listStore = snapshot.docs.map((e) {
      return Store.fromFireStore(e.data());
    }).toList();

    for (int i = 0; i < ids.length; i++) {
      var snapshotService = await FirebaseFirestore.instance
          .collection('store')
          .doc(ids[i])
          .collection('service')
          .get();
      var listServiceId = snapshotService.docs.map((e) => e.id).toList();
      for (int j = 0; j < listServiceId.length; j++) {
        var result = await FirebaseFirestore.instance
            .collection('store')
            .doc(ids[i])
            .collection('service')
            .doc(listServiceId[j])
            .get();
        if (query == (result.data()['name'])) {
          listStoreQuery.add(
              listStore.firstWhere((element) => element.idStore == ids[i]));
        }
      }
    }
    return listStoreQuery;
  }

  double rating;
  int sumrating = 0;
  int size;

  @override
  Widget build(BuildContext context) {
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
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Tìm dịch vụ ...',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              ),
            ),
            suggestionsCallback: (pattern) async {
              return await _getListService(query: pattern);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion),
                // subtitle: Text('\$suggestion'),
              );
            },
            onSuggestionSelected: (suggestion) async {
              var list = await _getListStore(query: suggestion);
              setState(() {
                listStore = list;
                showListStore = true;
              });
            },
          ),
        ),
      ),
      body: showListStore
          ? SingleChildScrollView(
              child: Column(
                children: listStore.map((e) {
                  listStore.sort((a, b) => a
                      .getM(10.02545, 105.77621)
                      .compareTo(b.getM(10.02545, 105.77621)));
                  double m = e.getM(10.02545, 105.77621);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => InforStoreScreen(
                                    store: e,
                                  )));
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 140,
                          margin: const EdgeInsets.only(
                              bottom: 0, left: 20, right: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          decoration: BoxDecoration(
                              color: Colors.blueGrey[800],
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                child: Image.asset('assets/2.jpeg',
                                    fit: BoxFit.cover),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${e.name}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${e.address}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Cách bạn ${m.toString().substring(0, 4)} km',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(width: 5),
                                        InkWell(
                                            child: Text(
                                              '--->',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onTap: () {
                                              Navigator.pop(context, e);
                                            })
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      child: StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('feedback')
                                            .where('storeId',
                                                isEqualTo: e.idStore)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            sumrating = 0;
                                            rating = 0;
                                            return Column(
                                              children: [
                                                Row(
                                                  children: snapshot.data.docs
                                                      .map((feedback) {
                                                    sumrating +=
                                                        feedback['rating'];
                                                    rating = sumrating /
                                                        snapshot.data.size;
                                                    size = snapshot.data.size;
                                                    return Row();
                                                  }).toList(),
                                                ),
                                                Row(
                                                  children: [
                                                    RatingBarIndicator(
                                                      rating: rating,
                                                      itemBuilder:
                                                          (context, index) =>
                                                              Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      itemCount: 5,
                                                      itemSize: 20.0,
                                                      unratedColor: Colors.amber
                                                          .withAlpha(50),
                                                      direction:
                                                          Axis.horizontal,
                                                    ),
                                                    Spacer(),
                                                    size == null
                                                        ? Text(
                                                            '0 đánh giá',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )
                                                        : Text(
                                                            '${size.toString()} đánh giá',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          }
                                          return Container();
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            )
          : Container(),
    );
  }
}
