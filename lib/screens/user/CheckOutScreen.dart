import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescue/blocs/order/order_bloc.dart';
import 'package:rescue/blocs/request/request_bloc.dart';
import 'package:rescue/models/Rescue.dart';
import 'package:rescue/models/Services.dart';
import 'package:rescue/screens/user/FeedbackScreen.dart';
import 'package:rescue/utils/helper.dart';

double getTotalPrice(List<Services> service) {
  return service
      .map((e) => double.tryParse(e.price))
      .toList()
      .reduce((value, element) => value + element);
}

class CheckOutScreen extends StatefulWidget {
  final Rescue detailStore;
  CheckOutScreen({this.detailStore});
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
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
        title: Text('Chi Tiết'),
        backgroundColor: Colors.blueGrey[800],
        brightness: Brightness.light,
        elevation: 0,
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              'Thông tin chung',
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
                Text('Ngày'),
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
                Text('Xác nhận'),
                Spacer(),
                widget.detailStore.status == 0
                    ? Text('Chưa xác nhận')
                    : Text('Đã xác nhận')
                // Text('${widget.detailStore.status}'),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Text('Thanh toán'),
                Spacer(),
                // Text('${widget.detailStore.checkout}'),
                widget.detailStore.checkout == 0
                    ? Text('Chưa thanh toán')
                    : Text('Đã thanh toán')
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Text('Địa chỉ'),
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
              'Dịch vụ',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Text('Tên'),
                Spacer(),
                Text(
                  'Tổng tiền',
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Column(
                children: widget.detailStore.service.map((e) {
              return Row(
                children: <Widget>[
                  Text('${e.name}'),
                  Spacer(),
                  Text(
                    '${e.price} đ',
                  ),
                ],
              );
            }).toList()),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Text('Phí di chuyển'),
                    Spacer(),
                    Text(priceMove.toStringAsFixed(0) + " đ")
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                    children: widget.detailStore.service.map((e) {
                  double priceService = double.parse(e.price) * 10 / 100;
                  return Row(
                    children: [
                      Text('Phí dịch vụ (10%)'),
                      Spacer(),
                      Text(priceService.toStringAsFixed(0) + " đ"),
                    ],
                  );
                }).toList()),
              ],
            ),
            SizedBox(
              height: 80,
            ),
            Column(
                children: widget.detailStore.service.map((e) {
              var priceService = double.parse(e.price) * 10 / 100;
              var totalPriceAll = 0.0;
              totalPriceAll = double.parse(e.price) + priceMove + priceService;
              return Row(
                children: [
                  Text(
                    'Tổng:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Spacer(),
                  if (widget.detailStore.service.isNotEmpty)
                    Text(
                      '${totalPriceAll.toStringAsFixed(0)} đ',
                      style: TextStyle(fontSize: 18),
                    ),
                  if (widget.detailStore.service.isEmpty)
                    Text(
                      '0 đ',
                      style: TextStyle(fontSize: 18),
                    ),
                ],
              );
            }).toList()),
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
                    BlocProvider.of<OrderBloc>(context).add(NewOrderEvent(
                      storeId: widget.detailStore.idStore,
                      userId: widget.detailStore.idUser,
                      total: getTotalPrice(widget.detailStore.service)
                          .toStringAsFixed(0),
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
                    "Xác Nhận Hoá Đơn",
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
                  onPressed: () {},
                  child: Text(
                    "Thanh Toán PayPal",
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
