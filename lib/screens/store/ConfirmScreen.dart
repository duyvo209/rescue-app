import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescue/blocs/login/login_bloc.dart';
import 'package:rescue/blocs/request/request_bloc.dart';
import 'package:rescue/blocs/store/store_bloc.dart';
import 'package:rescue/models/PriceMoveStore.dart';
import 'package:rescue/models/Rescue.dart';
import 'package:rescue/models/Service.dart';
import 'package:rescue/utils/helper.dart';
import 'package:easy_localization/easy_localization.dart';

double getTotalPrice(List<Service> service) {
  return service
      .map((e) => double.tryParse(e.price))
      .toList()
      .reduce((value, element) => value + element);
}

class ComfirmScreen extends StatefulWidget {
  final Rescue rescue;
  ComfirmScreen({@required this.rescue});
  @override
  _ComfirmScreenState createState() => _ComfirmScreenState();
}

class _ComfirmScreenState extends State<ComfirmScreen> {
  var store;
  List<Service> services = [];

  var priceMove = 0.0;
  var priceListService = 0.0;
  var percentService = 0.0;
  var phiDichVu = 0.0;
  @override
  void initState() {
    store = BlocProvider.of<LoginBloc>(context).state.user;
    if (store != null) {
      BlocProvider.of<StoreBloc>(context).add(GetListService(store.uid));
    }
    _initListServiceOfStore();
    _calPriceMove();
    // _calPriceListService();
    _calPriceServiceStore();
    super.initState();
  }

  _initListServiceOfStore() async {
    var listServiceIds = await FirebaseFirestore.instance
        .collection('store')
        .doc(widget.rescue.idStore)
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

  _calPriceMove() async {
    double m = Helper.getDistanceBetween(widget.rescue.latUser,
        widget.rescue.lngUser, widget.rescue.lat, widget.rescue.long);
    var data = await FirebaseFirestore.instance
        .collection('store')
        .doc(widget.rescue.idStore)
        .collection('prices_move')
        .get();

    for (int i = 0; i < data.docs.length; i++) {
      var priveMoveStore = PriceMoveStore(
          price: data.docs[i].data()['price'],
          from: double.tryParse(data.docs[i].data()['from'].toString()),
          to: double.tryParse(data.docs[i].data()['to'].toString()));
      if (priveMoveStore.from <= m && m <= priveMoveStore.to) {
        priceMove = double.tryParse(priveMoveStore.price);
      }
    }
    setState(() {});
  }

  _calPriceListService() {
    setState(() {
      priceListService = listServiceSelected
          .map((e) => double.tryParse(e.price))
          .toList()
          .reduce((value, element) => value + element);
    });
  }

  _calPriceServiceStore() async {
    var data = await FirebaseFirestore.instance
        .collection('store')
        .doc(widget.rescue.idStore)
        .get();

    setState(() {
      percentService = double.parse(data.data()['price_service'].toString());
    });
  }

  List<Service> listServiceSelected = [];
  Service listService;

  var totalPrice = 0;
  var priceService = 0.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        var priceSum = priceListService + priceMove + phiDichVu;

        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Xác nhận cứu hộ'.tr().toString()),
              backgroundColor: Colors.blueGrey[800],
              brightness: Brightness.light,
              elevation: 0,
              actionsIconTheme: IconThemeData(color: Colors.white),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: Stack(children: [
              Container(
                child: ListView(
                  children: [
                    Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            child: Hero(
                              tag: widget.rescue.userInfo,
                              child: Container(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Thông tin khách hàng'.tr().toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: <Widget>[
                              Text('Tên khách hàng'.tr().toString()),
                              Spacer(),
                              Text('${widget.rescue.userInfo.name}'),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: <Widget>[
                              Text('Số điện thoại'.tr().toString()),
                              Spacer(),
                              Text('${widget.rescue.userInfo.phone}'),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: <Widget>[
                              Text('Địa chỉ'.tr().toString()),
                              Spacer(),
                              Flexible(
                                child: Text(
                                  '${widget.rescue.userInfo.address}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: <Widget>[
                              Text('Dịch vụ'.tr().toString()),
                              Spacer(),
                              Text(
                                '${widget.rescue.problems.first.name}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              Text(
                                'Dịch vụ'.tr().toString(),
                                style: TextStyle(fontSize: 18),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                            'Thêm dịch vụ'.tr().toString()),
                                        content: DropdownButton(
                                          hint: Text('Dịch vụ'.tr().toString()),
                                          underline: SizedBox(),
                                          isExpanded: true,
                                          // value: valueChoose,
                                          onChanged: (value) {
                                            setState(() {
                                              if (!listServiceSelected
                                                  .contains(value)) {
                                                listServiceSelected.add(value);
                                                _calPriceListService();
                                                phiDichVu = percentService *
                                                    priceListService;
                                              }
                                            });

                                            // print(listServiceSelected.length);
                                          },
                                          items: services.map((value) {
                                            return DropdownMenuItem(
                                                value: value,
                                                child: Text('${value.name}'));
                                          }).toList(),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: <Widget>[
                              Text('Tên dịch vụ'.tr().toString()),
                              Spacer(),
                              Text('Đơn giá'.tr().toString()),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          if (listServiceSelected.isNotEmpty)
                            Column(
                              children: listServiceSelected.map((e) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(e.name),
                                        SizedBox(
                                          height: 40,
                                        ),
                                        Spacer(),
                                        Text(e.price + " VNĐ"),
                                        SizedBox(width: 10),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                listServiceSelected.remove(e);
                                              });
                                            },
                                            child: Text(
                                              'X',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text('Phí di chuyển'.tr().toString()),
                                  Spacer(),
                                  Text(priceMove.toStringAsFixed(0) + " VNĐ")
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              // StreamBuilder<List<Service>>(
                              //     stream: BlocProvider.of<StoreBloc>(context)
                              //         .getListService(widget.rescue.idStore),
                              //     builder: (context, snapshot) {
                              //       if (listServiceSelected.isNotEmpty) {
                              //         priceService =
                              //             getTotalPrice(listServiceSelected) *
                              //                 10 /
                              //                 100;
                              //       }
                              Row(
                                children: [
                                  Text(
                                      'Phí dịch vụ'.tr().toString() + " (10%)"),
                                  Spacer(),
                                  Text(phiDichVu.toStringAsFixed(0) + ' VNĐ'),
                                ],
                              ),
                              // }),
                            ],
                          ),
                          SizedBox(
                            height: 120,
                          ),
                          SizedBox(
                            height: 240,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            bottomNavigationBar: StreamBuilder<List<Service>>(
                stream: BlocProvider.of<StoreBloc>(context)
                    .getListService(widget.rescue.idStore),
                builder: (context, snapshot) {
                  var totalPriceAll = 0.0;
                  if (listServiceSelected.isNotEmpty) {
                    totalPriceAll = getTotalPrice(listServiceSelected) +
                        priceMove +
                        priceService;
                  }
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, -15),
                            blurRadius: 20,
                            color: Color(0xFFDADADA) //.withOpacity(0.15),
                            ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                            ),
                            Text.rich(
                              TextSpan(
                                text: "Tổng tiền ".tr().toString(),
                                style: TextStyle(fontSize: 16),
                                children: [
                                  // if (user != null)
                                  if (listServiceSelected.isNotEmpty)
                                    TextSpan(
                                      text:
                                          '${priceSum.toStringAsFixed(0) + " VNĐ"}',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  // if (state.listService.isEmpty)
                                  // if (user == null)
                                  if (listServiceSelected.isEmpty)
                                    TextSpan(
                                      text: "",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Container(
                              margin: EdgeInsets.only(right: 20, bottom: 10),
                              // padding: EdgeInsets.only(bottom: 20),
                              child: SizedBox(
                                width: 150,
                                height: 50,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  onPressed: () {
                                    _showDialog(context);
                                    BlocProvider.of<RequestBloc>(context).add(
                                      UpdateService(
                                        requestId: widget.rescue.idRequest,
                                        service: listServiceSelected,
                                        total: totalPriceAll.toStringAsFixed(0),
                                      ),
                                    );
                                  },
                                  textColor: Colors.white,
                                  color: Colors.blueGrey[800],
                                  child: Text(
                                    'Xác nhận'.tr().toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                            ),
                            Text.rich(
                              TextSpan(
                                text: "${widget.rescue.storeName}",
                                // '${getTotalPrice(listServiceSelected).toStringAsFixed(0)}',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ),
                            Spacer(),
                            Container(
                              margin: EdgeInsets.only(right: 20),
                              child: SizedBox(
                                width: 150,
                                height: 50,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  onPressed: () {
                                    _showDialogCancel(context);
                                    BlocProvider.of<RequestBloc>(context).add(
                                      DeleteService(
                                        requestId: widget.rescue.idRequest,
                                      ),
                                    );
                                  },
                                  textColor: Colors.white,
                                  color: Colors.red[900],
                                  child: Text(
                                    'Huỷ yêu cầu'.tr().toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }));
      },
    );
  }

  _showDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title:
                Text('Thành công', style: TextStyle(color: Colors.green[600])),
            content: Text('Xác nhận hoá đơn thành công !'),
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

  _showDialogCancel(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Thành công', style: TextStyle(color: Colors.red[600])),
            content: Text('Bạn có thật sự muốn huỷ yêu cầu ?'),
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
