import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:rescue/models/Service.dart';
import 'package:rescue/models/Store.dart';

import 'InforStoreScreen.dart';

class ServiceScreen extends StatefulWidget {
  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  List<String> listProblems = [];
  bool showListStore = false;
  List<Store> listStore = [];
  bool showLoading = false;
  Service currentService;

  @override
  void initState() {
    super.initState();
    // _getListService();
    _getListServiceStream();
  }

  Stream<List<Service>> _getListServiceStream() {
    return FirebaseFirestore.instance
        .collection('services')
        .snapshots()
        .asyncMap((event) {
      return event.docs.map((e) {
        return Service(
          desc: e.data()['problem'],
          id: e.id,
          name: e.data()['name'],
          price: e.data()['price'],
        );
      }).toList();
    });
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

      if (snapshotService.docs.any((element) =>
          element.data()['service_id'].toString().toLowerCase() ==
          query.toLowerCase())) {
        listStoreQuery.add(listStore
            .firstWhere((element) => element.idStore == ids[i])
            .copyWith(
                listService: snapshotService.docs.map((e) {
              return Service(
                  id: e.data()['service_id'], price: e.data()['price']);
            }).toList()));
      }
    }
    return listStoreQuery;
  }

  _sortByPrice() async {
    listStore.sort((a, b) {
      var serviceA = a.listService
          .firstWhere((element) => currentService.id.contains(element.id));
      var serviceB = b.listService
          .firstWhere((element) => currentService.id.contains(element.id));
      return int.tryParse(serviceA.price)
          .compareTo(int.tryParse(serviceB.price));
    });
    setState(() {});
  }

  _sortByRating() async {
    var result = await FirebaseFirestore.instance.collection('feedback').get();
    var feedback = result.docs.toList();
    listStore = listStore.map((element) {
      int total = 0;
      int index = 0;
      total = feedback
          .map((e) {
            if (e.data()['storeId'] == element.idStore) {
              index++;
              return e.data()['rating'] as int;
            }
            return 0;
          })
          .toList()
          .reduce((value, element) => value + element);

      return element.copyWith(avgRating: total / ((index == 0 ? 1 : index)));
    }).toList();

    listStore.sort((a, b) => b.avgRating.compareTo(a.avgRating));

    setState(() {});
  }

  double rating;
  int sumrating = 0;
  int size;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('D???ch v??? hi???n c??'),
        backgroundColor: Colors.blueGrey[800],
        brightness: Brightness.light,
        elevation: 0,
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: showLoading
          ? Center(child: CircularProgressIndicator())
          : showListStore
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 42.5,
                          ),
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                listStore.sort((a, b) => a
                                    .getM(10.029939, 105.7684213)
                                    .compareTo(b.getM(10.029939, 105.7684213)));
                              });
                            },
                            child: Container(
                                width: 80,
                                height: 30,
                                padding: EdgeInsets.only(left: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.amber),
                                child: Row(
                                  children: [
                                    Text(
                                      'V??? tr??',
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.arrow_downward_outlined,
                                      size: 16,
                                    )
                                  ],
                                )),
                          ),
                          FlatButton(
                            onPressed: () async {
                              await _sortByPrice();
                            },
                            child: Container(
                                width: 80,
                                height: 30,
                                padding: EdgeInsets.only(left: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.amber),
                                child: Row(
                                  children: [
                                    Text(
                                      'Gi??',
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.arrow_downward_outlined,
                                      size: 16,
                                    )
                                  ],
                                )),
                          ),
                          FlatButton(
                            onPressed: () async {
                              await _sortByRating();
                            },
                            child: Container(
                                // color: Colors.amber,

                                width: 100,
                                height: 30,
                                padding: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.amber),
                                child: Row(
                                  children: [
                                    Text(
                                      '????nh gi??',
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.arrow_downward_outlined,
                                      size: 16,
                                    )
                                  ],
                                )),
                          ),
                        ],
                      ),
                      Column(
                        children: listStore.map((e) {
                          double m = e.getM(10.029939, 105.7684213);
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '${e.name}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${e.address}",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'C??ch b???n ${m.toString().substring(0, 4)} km',
                                                  style: TextStyle(
                                                      color: Colors.white),
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
                                              child:
                                                  StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore
                                                    .instance
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
                                                          children: snapshot
                                                              .data.docs
                                                              .map((feedback) {
                                                            sumrating +=
                                                                feedback[
                                                                    'rating'];
                                                            rating = sumrating /
                                                                snapshot
                                                                    .data.size;

                                                            return Row();
                                                          }).toList(),
                                                        ),
                                                        Row(
                                                          children: [
                                                            RatingBarIndicator(
                                                              rating: rating,
                                                              itemBuilder:
                                                                  (context,
                                                                          index) =>
                                                                      Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                              ),
                                                              itemCount: 5,
                                                              itemSize: 20.0,
                                                              unratedColor:
                                                                  Colors.amber
                                                                      .withAlpha(
                                                                          50),
                                                              direction: Axis
                                                                  .horizontal,
                                                            ),
                                                            Spacer(),
                                                            snapshot.data
                                                                        .size ==
                                                                    null
                                                                ? Text(
                                                                    '0 ????nh gi??',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  )
                                                                : Text(
                                                                    '${snapshot.data.size} ????nh gi??',
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
                    ],
                  ),
                )
              : StreamBuilder<List<Service>>(
                  stream: _getListServiceStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      var services = snapshot.data;
                      return SingleChildScrollView(
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: Wrap(
                            direction: Axis.horizontal,
                            spacing: 10,
                            children: List.generate(services.length, (index) {
                              return GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    showLoading = true;
                                    showListStore = true;
                                    currentService = services[index];
                                  });
                                  var list = await _getListStore(
                                      query: services[index].id);
                                  setState(() {
                                    listStore = list;
                                    showLoading = false;
                                    listStore.sort((a, b) => a
                                        .getM(10.029939, 105.7684213)
                                        .compareTo(
                                            b.getM(10.029939, 105.7684213)));
                                  });
                                },
                                child: ChoiceChip(
                                    label: Text(
                                      services[index].name,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    selected: false),
                              );
                            }),
                          ),
                        ),
                      );
                    }
                    return Container();
                  }),
    );
  }
}
