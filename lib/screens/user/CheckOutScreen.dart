import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescue/blocs/order/order_bloc.dart';
import 'package:rescue/blocs/request/request_bloc.dart';
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
  var totalPriceService = 0.0;
  var totalPrice = 0.0;
  var sum = 0.0;

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
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    double m = Helper.getDistanceBetween(
        widget.detailStore.latUser,
        widget.detailStore.lngUser,
        widget.detailStore.lat,
        widget.detailStore.long);
    var priceMove = 0.0;
    if (m < 2.0) {
      priceMove = 20000.0;
    } else {
      priceMove =
          20000.0 + ((double.parse(m.toStringAsFixed(0)) - 2.0) * 5000.0);
    }
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
                  Column(
                      children: widget.detailStore.service.map((e) {
                    double priceService = double.parse(e.price) * 10 / 100;
                    totalPriceService += priceService;
                    return Row(
                      children: [
                        // Text('Phí dịch vụ'.tr().toString() + '(10%)'),
                        // Spacer(),
                        // Text(totalPriceService.toStringAsFixed(0) + " VNĐ"),
                      ],
                    );
                  }).toList()),
                  Row(
                    children: [
                      Text('Phí dịch vụ'.tr().toString() + ' (10%)'),
                      Spacer(),
                      Text(totalPriceService.toStringAsFixed(0) + " VNĐ"),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Column(
                  children: widget.detailStore.service.map((e) {
                var priceService = double.parse(e.price) * 10 / 100;

                // totalPriceAll =
                //     double.parse(e.price) + priceMove + priceService;
                totalPriceAll = double.parse(e.price) + priceService;
                totalPrice += totalPriceAll;
                return Row(
                  children: [
                    // Text(
                    //   'Tổng tiền'.tr().toString(),
                    //   style: TextStyle(fontSize: 18),
                    // ),
                    // Spacer(),
                    // if (widget.detailStore.service.isNotEmpty)
                    //   Text(
                    //     '${totalPriceAll.toStringAsFixed(0)} VNĐ',
                    //     style: TextStyle(fontSize: 18),
                    //   ),
                    // if (widget.detailStore.service.isEmpty)
                    //   Text(
                    //     '0 VNĐ',
                    //     style: TextStyle(fontSize: 18),
                    //   ),
                  ],
                );
              }).toList()),
              Row(
                children: [
                  Text(
                    'Tổng tiền'.tr().toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                  Spacer(),
                  if (widget.detailStore.service.isNotEmpty)
                    Text(
                      '${totalPrice.toInt() + priceMove.toInt()} VNĐ',
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
                      var sum = totalPrice + priceMove;
                      BlocProvider.of<OrderBloc>(context).add(NewOrderEvent(
                        storeId: widget.detailStore.idStore,
                        userId: widget.detailStore.idUser,
                        total: sum.toStringAsFixed(0),
                        userInfo: widget.detailStore.userInfo,
                        checkout: 1,
                      ));

                      BlocProvider.of<RequestBloc>(context).add(
                        UpdateCheckout(
                          requestId: widget.detailStore.idRequest,
                          checkout: 1,
                        ),
                      );
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
                        total: sum.toStringAsFixed(0),
                        userInfo: widget.detailStore.userInfo,
                        checkout: 1,
                      ));

                      BlocProvider.of<RequestBloc>(context).add(
                        UpdateCheckout(
                          requestId: widget.detailStore.idRequest,
                          checkout: 1,
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
