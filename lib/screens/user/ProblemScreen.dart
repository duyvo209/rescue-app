import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rescue/models/Problem.dart';
import 'package:rescue/models/Service.dart';
import 'package:rescue/models/Store.dart';
import 'package:rescue/screens/user/InforStoreScreen.dart';

class ProblemScreen extends StatefulWidget {
  @override
  _ProblemScreenState createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> {
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  List<String> listProblems = [];
  bool showListStore = false;
  List<Store> listStore = [];
  bool showLoading = false;
  Problem currentProblem;
  List<Service> services = [];

  @override
  void initState() {
    super.initState();
    _getListProblem();
  }

  Stream<List<Problem>> _getListProblem() {
    return FirebaseFirestore.instance
        .collection('problem')
        .snapshots()
        .asyncMap((event) {
      return event.docs.map((e) {
        return Problem(
          problemId: e.id,
          name: e.data()['name'],
        );
      }).toList();
    });
  }

  Future<List<Store>> _getListStore(String problemId) async {
    try {
      var listService =
          await FirebaseFirestore.instance.collection('services').get();
      var listServicesHaveThisProblem = listService.docs
          .where((element) => element.data()['problem_id'] == problemId);
      var result = await FirebaseFirestore.instance.collection('store').get();
      var listStore =
          result.docs.map((e) => Store.fromFireStore(e.data())).toList();
      List<Store> listStoreHaveThisService = [];
      for (int i = 0; i < listStore.length; i++) {
        var collectionService = await FirebaseFirestore.instance
            .collection('store')
            .doc(listStore[i].idStore)
            .collection('service')
            .get();
        if (listServicesHaveThisProblem.any((element1) => collectionService.docs
            .any((element2) => element1.id == element2.data()['service_id']))) {
          print("found");
          listStoreHaveThisService.add(listStore[i].copyWith(
              listService: collectionService.docs
                  .map((e) => Service(
                        id: e.data()['service_id'],
                        price: e.data()['price'],
                      ))
                  .toList()));
        }
        // listStoreHaveThisService.add(listStore[i]);
      }
      return listStoreHaveThisService;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    return [];
  }

  _sortByPrice() async {
    var listServiceAdmin =
        await FirebaseFirestore.instance.collection('services').get();
    var list = listServiceAdmin.docs.where(
        (element) => element.data()['problem_id'] == currentProblem.problemId);
    var service = list.first;
    // for (int i = 0; i < listStore.length; i++) {
    //   var collectionServiceStore = await FirebaseFirestore.instance
    //       .collection('store')
    //       .doc(listStore[i].idStore)
    //       .collection('service')
    //       .get();
    //   var listServiceAdmin =
    //       await FirebaseFirestore.instance.collection('services').get();
    //   listServiceAdmin.docs.map((element1) {
    //     if (collectionServiceStore.docs
    //         .any((element2) => element1.id == element2.data()['service_id'])) {
    //       var services = collectionServiceStore.docs.map((e) {
    //         return Service(
    //           id: element1.id,
    //           price: collectionServiceStore.docs
    //               .firstWhere(
    //                   (element) => element1.id == element.data()['service_id'])
    //               .data()['price'],
    //         );
    //       }).toList();
    //       listStore[i] = listStore[i].copyWith(listService: services);
    //     }
    //   });
    // }
    listStore.sort((a, b) {
      var serviceA =
          a.listService.firstWhere((element) => service.id == element.id);
      var serviceB =
          b.listService.firstWhere((element) => service.id == element.id);
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

  Widget _buildProblemWidget() {
    return StreamBuilder<List<Problem>>(
      stream: _getListProblem(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var problems = snapshot.data;
          return Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 10,
              children: problems.map((e) {
                return GestureDetector(
                  onTap: () async {
                    setState(() {
                      currentProblem = e;
                      showLoading = true;
                      showListStore = true; // neu bi loi thi xoa cai nay
                    });
                    var result = await _getListStore(currentProblem.problemId);
                    setState(() {
                      listStore = result;
                      showListStore = true;
                      showLoading = false;
                      listStore.sort((a, b) => a
                          .getM(10.029939, 105.7684213)
                          .compareTo(b.getM(10.029939, 105.7684213)));
                    });
                  },
                  child: ChoiceChip(
                      label: Text(
                        e.name,
                        style: TextStyle(color: Colors.black),
                      ),
                      selected: false),
                );
              }).toList(),
            ),
          );
        }
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Vấn đề của xe'),
          backgroundColor: Colors.blueGrey[800],
          brightness: Brightness.light,
          elevation: 0,
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: showLoading
            ? Center(child: CircularProgressIndicator())
            : !showListStore
                ? _buildProblemWidget()
                : SingleChildScrollView(
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
                                      .compareTo(
                                          b.getM(10.029939, 105.7684213)));
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
                                        'Vị trí',
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
                                        'Giá',
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
                                        'Đánh giá',
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
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
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
                                                    'Cách bạn ${m.toString().substring(0, 4)} km',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(width: 5),
                                                  InkWell(
                                                      child: Text(
                                                        '--->',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onTap: () {
                                                        Navigator.pop(
                                                            context, e);
                                                      })
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                child: StreamBuilder<
                                                    QuerySnapshot>(
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
                                                                .map(
                                                                    (feedback) {
                                                              sumrating +=
                                                                  feedback[
                                                                      'rating'];
                                                              rating =
                                                                  sumrating /
                                                                      snapshot
                                                                          .data
                                                                          .size;
                                                              size = snapshot
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
                                                                    Colors
                                                                        .amber
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
                                                                      '0 đánh giá',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    )
                                                                  : Text(
                                                                      '${snapshot.data.size} đánh giá',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
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
                  ));
  }
}
