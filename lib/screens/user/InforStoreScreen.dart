import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rescue/blocs/feedback/feedback_bloc.dart';
import 'package:rescue/blocs/login/login_bloc.dart';
import 'package:rescue/blocs/reportStore/report_bloc.dart';
import 'package:rescue/blocs/request/request_bloc.dart';
import 'package:rescue/models/Service.dart';
import 'package:rescue/models/Store.dart';
import 'package:rescue/screens/user/ChatDetailTest.dart';
import 'package:easy_localization/easy_localization.dart';

class InforStoreScreen extends StatefulWidget {
  final Store store;
  final String storeId;
  final String requestId;
  InforStoreScreen({@required this.store, this.storeId, this.requestId});
  @override
  _InforStoreScreenState createState() => _InforStoreScreenState();
}

class _InforStoreScreenState extends State<InforStoreScreen> {
  var user;
  GlobalKey<ScaffoldState> ratingKey = GlobalKey();
  List<Service> services = [];
  @override
  void initState() {
    user = BlocProvider.of<LoginBloc>(context).state.user;
    BlocProvider.of<FeedbackBloc>(context).add(GetListFeedback());
    sumrating = 0;
    _initListServiceOfStore();
    super.initState();
  }

  _initListServiceOfStore() async {
    var listServiceIds = await FirebaseFirestore.instance
        .collection('store')
        .doc(widget.store.idStore)
        .collection('service')
        .get();
    var listService =
        await FirebaseFirestore.instance.collection('services').get();
    listService.docs.forEach((element1) {
      if (listServiceIds.docs
          .any((element2) => element1.id == element2.data()['service_id'])) {
        services.add(Service(
          id: element1.id,
          price: listServiceIds.docs
              .firstWhere(
                  (element) => element1.id == element.data()['service_id'])
              .data()['price'],
          name: element1.data()['name'],
        ));
      }
    });

    setState(() {});
  }

  Service serviceSelected;
  double rating;
  int sumrating = 0;
  final TextEditingController _reportController = new TextEditingController();
  final TextEditingController _reportStoreController =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(
      builder: (context, state) {
        //  print(state.listFeedback[0].rating);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Th??ng tin c???a h??ng'.tr().toString()),
            backgroundColor: Colors.blueGrey[800],
            brightness: Brightness.light,
            elevation: 0,
            actionsIconTheme: IconThemeData(color: Colors.white),
            iconTheme: IconThemeData(color: Colors.white),
            actions: <Widget>[
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('store')
                    .doc(widget.store.idStore)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return IconButton(
                      icon: Icon(Icons.messenger_rounded),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new ChatDetailTest(
                              docs: snapshot.data,
                            ),
                          ),
                        )
                      },
                    );
                  }
                  return Container();
                },
              )
            ],
          ),
          body: ListView(
            padding: EdgeInsets.all(0),
            children: [
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                        child: Hero(
                      tag: widget.store.name,
                      child: AspectRatio(
                        aspectRatio: 1 / 0.667,
                        child: Image.asset(
                          'assets/2.jpeg',
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 0,
                ),
                child: Row(
                  children: [
                    Text(
                      "${widget.store.name}",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                        icon: Icon(
                          Icons.report,
                          color: Colors.grey,
                        ),
                        iconSize: 30,
                        onPressed: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) {
                                return SingleChildScrollView(
                                  child: Container(
                                    height: 700,
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30)),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, -15),
                                          blurRadius: 20,
                                          color: Color(0xFFDADADA)
                                              .withOpacity(0.15),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            text: "B??o c??o c???a h??ng vi ph???m",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: TextFormField(
                                            controller: _reportStoreController,
                                            maxLines: 4,
                                            keyboardType:
                                                TextInputType.multiline,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: "Nh???p b??o c??o",
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            BlocProvider.of<ReportBloc>(context)
                                                .add(
                                              AddToReport(
                                                storeId: widget.store.idStore,
                                                storeName: widget.store.name,
                                                report:
                                                    _reportStoreController.text,
                                              ),
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            height: 55,
                                            width: 395,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6)),
                                                color: Colors.blueGrey[800]),
                                            child: Center(
                                              child: Text(
                                                'G???i',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        })
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 0,
                ),
                child: Text(
                  "${widget.store.address}",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 0,
                ),
                child: Text(
                  "C??ch b???n ${widget.store.getM(10.029939, 105.768421).toString().substring(0, 4)} km",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 0,
                ),
                child: FlatButton(
                  padding: EdgeInsets.only(right: 270),
                  onPressed: () async {
                    // await FlutterPhoneDirectCaller.callNumber(widget.store.phone);
                  },
                  child: Text(
                    "${widget.store.phone}",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 0,
                ),
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blueGrey[800],
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(15)),
                  child: DropdownButton<Service>(
                    hint: Text(
                      '${serviceSelected?.name ?? "Ch???n d???ch v???".tr().toString()}',
                    ),
                    underline: SizedBox(),
                    isExpanded: true,
                    // value: serviceSelected,
                    onChanged: (value) {
                      setState(() {
                        serviceSelected = value;
                      });
                    },
                    items: services.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text('${value.name}' + ' - ' + '${value.price}'),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              color: Colors.red[900]),
                          child: Center(
                            child: Text(
                              'Hu???'.tr().toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _showDialog(context);
                          BlocProvider.of<RequestBloc>(context).add(
                            AddToRequest(
                              userId: FirebaseAuth.instance.currentUser.uid,
                              storeId: widget.store.idStore,
                              requestId: widget.requestId,
                              storeName: widget.store.name,
                              problem: serviceSelected?.toMap(),
                              lat: widget.store.lat,
                              long: widget.store.long,
                            ),
                          );
                        },
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              color: Colors.blueGrey[800]),
                          child: Center(
                            child: Text(
                              'G???i Y??u C???u'.tr().toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('feedback')
                      .where('storeId', isEqualTo: widget.store.idStore)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      sumrating = 0;
                      rating = 0;
                      return Column(
                        children: [
                          Row(
                            children: [
                              Row(
                                children: snapshot.data.docs.map((feedback) {
                                  sumrating += feedback['rating'];
                                  rating = sumrating / snapshot.data.size;
                                  return Row();
                                }).toList(),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '????nh gi??'.tr().toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '${rating.toString().substring(0, 3)} / 5.0',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              RatingBarIndicator(
                                rating: rating,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                ),
                                itemCount: 5,
                                itemSize: 30.0,
                                unratedColor: Colors.amber.withAlpha(50),
                                direction: Axis.horizontal,
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Text(
                  'B??nh lu???n'.tr().toString(),
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('feedback')
                      .where('storeId', isEqualTo: widget.store.idStore)
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children:
                            snapshot.data.docs.map((DocumentSnapshot feedback) {
                          return Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.grey[300],
                                    child: ClipOval(
                                      child: new SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: CachedNetworkImage(
                                            imageUrl:
                                                feedback['user_info.image']),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    feedback['user_info.name'],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Spacer(),
                                  IconButton(
                                      icon: Icon(
                                        Icons.report,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (context) {
                                              return SingleChildScrollView(
                                                child: Container(
                                                  height: 700,
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(30),
                                                            topRight:
                                                                Radius.circular(
                                                                    30)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        offset: Offset(0, -15),
                                                        blurRadius: 20,
                                                        color: Color(0xFFDADADA)
                                                            .withOpacity(0.15),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text.rich(
                                                        TextSpan(
                                                          text:
                                                              "B??o c??o b??nh lu???n vi ph???m",
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20,
                                                                right: 20),
                                                        child: TextFormField(
                                                          controller:
                                                              _reportController,
                                                          maxLines: 4,
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            hintText:
                                                                "Nh???p b??o c??o",
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 30,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          BlocProvider.of<
                                                                      FeedbackBloc>(
                                                                  context)
                                                              .add(
                                                            UpdateReport(
                                                              feedbackId:
                                                                  feedback.id,
                                                              report:
                                                                  _reportController
                                                                      .text,
                                                            ),
                                                          );
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          height: 55,
                                                          width: 395,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              6)),
                                                              color: Colors
                                                                      .blueGrey[
                                                                  800]),
                                                          child: Center(
                                                            child: Text(
                                                              'G???i',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      })
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  (feedback['rating'] == 1)
                                      ? Icon(
                                          Icons.star,
                                          size: 16,
                                          color: Colors.orange,
                                        )
                                      : Text(''),
                                  (feedback['rating'] == 2)
                                      ? Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Colors.orange,
                                            ),
                                            Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Colors.orange,
                                            ),
                                          ],
                                        )
                                      : Text(''),
                                  (feedback['rating'] == 3)
                                      ? Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Colors.orange,
                                            ),
                                            Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Colors.orange,
                                            ),
                                            Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Colors.orange,
                                            ),
                                          ],
                                        )
                                      : Text(''),
                                  (feedback['rating'] == 4)
                                      ? Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Colors.orange,
                                            ),
                                            Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Colors.orange,
                                            ),
                                            Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Colors.orange,
                                            ),
                                            Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Colors.orange,
                                            ),
                                          ],
                                        )
                                      : Text(''),
                                  (feedback['rating'] == 5)
                                      ? Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Colors.orange,
                                            ),
                                            Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Colors.orange,
                                            ),
                                            Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Colors.orange,
                                            ),
                                            Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Colors.orange,
                                            ),
                                            Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Colors.orange,
                                            ),
                                          ],
                                        )
                                      : Text(''),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    feedback['time']
                                        .toString()
                                        .substring(0, 10)
                                        .split('-')
                                        .reversed
                                        .join('/'),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: feedback['comment'] ==
                                            'N???i dung n??y ???? b??? ???n'
                                        ? Text(
                                            feedback['comment'],
                                            maxLines: 2,
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : Text(
                                            feedback['comment'],
                                            maxLines: 4,
                                          ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              )
                            ],
                          );
                        }).toList(),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _showDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title:
                Text('Th??nh c??ng', style: TextStyle(color: Colors.green[600])),
            content: Text(
                'Y??u c???u c???a b???n ???? ???????c g???i ??i, ch??ng t??i s??? ?????n trong ??t ph??t'),
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
