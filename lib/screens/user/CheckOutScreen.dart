import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescue/blocs/order/order_bloc.dart';
import 'package:rescue/blocs/request/request_bloc.dart';
import 'package:rescue/models/PriceMoveStore.dart';
import 'package:rescue/models/Rescue.dart';
import 'package:rescue/models/Services.dart';
import 'package:rescue/screens/user/FeedbackScreen.dart';
import 'package:rescue/utils/helper.dart';
import 'package:rescue/utils/stripe.dart';
import 'package:easy_localization/easy_localization.dart';

double getTotalPrice(List<Services> service) {
  return service
      .map((e) => double.tryParse(e.price))
      .toList()
      .reduce((value, element) => value + element);
}

class CheckOutScreen extends StatefulWidget {
  final Rescue detailStore;
  final String id;
  CheckOutScreen({this.detailStore, this.id});
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  var totalPriceAll = 0.0;
  double usd = 23000;

  var totalPrice = 0.0;
  var sum = 0.0;
  var priceMove = 0.0;
  var priceServiceStore = 0.0;
  var priceListService = 0.0;

  payViaNewCard(BuildContext context) async {
    var totalCard = totalPriceAll / usd * 100;
    print(totalCard.toStringAsFixed(0));
    var response = await StripeService.payWithNewCard(
        amount: totalCard.toStringAsFixed(0), currency: 'USD');

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration:
          new Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
  }

  @override
  void initState() {
    StripeService.init();
    _calPriceMove();
    _calPriceServiceStore();
    _calPriceListService();

    super.initState();
  }

  _calPriceMove() async {
    double m = Helper.getDistanceBetween(
        widget.detailStore.latUser,
        widget.detailStore.lngUser,
        widget.detailStore.lat,
        widget.detailStore.long);
    var data = await FirebaseFirestore.instance
        .collection('store')
        .doc(widget.detailStore.idStore)
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
    priceListService = widget.detailStore.service
        .map((e) => double.tryParse(e.price))
        .toList()
        .reduce((value, element) => value + element);
  }

  _calPriceServiceStore() async {
    var data = await FirebaseFirestore.instance
        .collection('store')
        .doc(widget.detailStore.idStore)
        .get();
    priceServiceStore = double.parse(data.data()['price_service'].toString()) *
        priceListService;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var priceSum = priceListService + priceServiceStore + priceMove;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Chi tiết'.tr().toString()),
        backgroundColor: Colors.blueGrey[800],
        brightness: Brightness.light,
        elevation: 0,
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text(
                'Thông tin chung'.tr().toString(),
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Text('ID'),
                  Spacer(),
                  Text('${widget.detailStore.idRequest}'),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Text('Ngày'.tr().toString()),
                  Spacer(),
                  Text(
                      '${widget.detailStore.time.toString().substring(0, 10).split('-').reversed.join('/')}'),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Text('Xác nhận'.tr().toString()),
                  Spacer(),
                  widget.detailStore.status == 0
                      ? Text('Chưa xác nhận'.tr().toString())
                      : Text('Đã xác nhận'.tr().toString())
                  // Text('${widget.detailStore.status}'),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Text('Thanh toán'.tr().toString()),
                  Spacer(),
                  // Text('${widget.detailStore.checkout}'),
                  widget.detailStore.checkout == 0
                      ? Text('Chưa thanh toán'.tr().toString())
                      : Text('Đã thanh toán'.tr().toString())
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Text('Địa chỉ'.tr().toString()),
                  Spacer(),
                  Flexible(
                    child: Text(
                      '${widget.detailStore.userInfo.address}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'Dịch vụ'.tr().toString(),
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Text('Tên dịch vụ'.tr().toString()),
                  Spacer(),
                  Text(
                    'Tổng tiền'.tr().toString(),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                child: Column(
                    children: widget.detailStore.service.map((e) {
                  return Row(
                    children: <Widget>[
                      Text('${e.name}'),
                      Spacer(),
                      Text(
                        '${e.price} VNĐ',
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                }).toList()),
              ),
              SizedBox(
                height: 20,
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
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text('Phí dịch vụ'.tr().toString() + ' (10%)'),
                      Spacer(),
                      Text(priceServiceStore.toStringAsFixed(0) + " VNĐ"),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Text(
                    'Tổng tiền'.tr().toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                  Spacer(),
                  if (widget.detailStore.service.isNotEmpty)
                    Text(
                      '${priceSum.toInt()} VNĐ',
                      style: TextStyle(fontSize: 18),
                    ),
                  if (widget.detailStore.service.isEmpty)
                    Text(
                      '0 VNĐ',
                      style: TextStyle(fontSize: 18),
                    ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                child: SizedBox(
                  width: 390,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      _showDialog(context);
                      // var sum = totalPrice + priceMove;
                      // BlocProvider.of<OrderBloc>(context).add(NewOrderEvent(
                      //   storeId: widget.detailStore.idStore,
                      //   userId: widget.detailStore.idUser,
                      //   total: priceSum.toStringAsFixed(0),
                      //   userInfo: widget.detailStore.userInfo,
                      //   checkout: 1,
                      // ));

                      // BlocProvider.of<RequestBloc>(context).add(
                      //   UpdateCheckout(
                      //     requestId: widget.detailStore.idRequest,
                      //     checkout: 1,
                      //   ),
                      // );

                      // BlocProvider.of<RequestBloc>(context).add(
                      //   DeleteService(
                      //     requestId: widget.detailStore.idRequest,
                      //   ),
                      // );
                    },
                    child: Text(
                      "Xác Nhận Hoá Đơn".tr().toString(),
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
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: SizedBox(
                  width: 390,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      payViaNewCard(context);

                      BlocProvider.of<OrderBloc>(context).add(NewOrderEvent(
                        storeId: widget.detailStore.idStore,
                        userId: widget.detailStore.idUser,
                        total: priceSum.toStringAsFixed(0),
                        userInfo: widget.detailStore.userInfo,
                        checkout: 1,
                      ));

                      BlocProvider.of<RequestBloc>(context).add(
                        UpdateCheckout(
                          requestId: widget.detailStore.idRequest,
                          checkout: 1,
                        ),
                      );

                      BlocProvider.of<RequestBloc>(context).add(
                        DeleteService(
                          requestId: widget.detailStore.idRequest,
                        ),
                      );
                    },
                    child: Text(
                      "Thanh Toán Thẻ".tr().toString(),
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
            ],
          ),
        ),
      ),
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
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              FeedbackScreen(widget.detailStore)),
                    );
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.blueGrey[800]),
                  ))
            ],
          ));
}
