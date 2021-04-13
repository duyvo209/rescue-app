import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescue/blocs/login/login_bloc.dart';
import 'package:rescue/blocs/store/store_bloc.dart';
import 'package:rescue/models/Rescue.dart';
import 'package:rescue/models/Service.dart';

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

  @override
  void initState() {
    store = BlocProvider.of<LoginBloc>(context).state.user;
    if (store != null) {
      BlocProvider.of<StoreBloc>(context).add(GetListService(store.uid));
    }
    super.initState();
  }

  List<Service> listServiceSelected = [];
  var totalPrice = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Xác nhận cứu hộ'),
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
                            'Thông tin khách hàng',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: <Widget>[
                              Text('Tên khách hàng'),
                              Spacer(),
                              Text('${widget.rescue.userInfo.name}'),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: <Widget>[
                              Text('Số điện thoại'),
                              Spacer(),
                              Text('${widget.rescue.userInfo.phone}'),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: <Widget>[
                              Text('Địa chỉ'),
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
                          SizedBox(
                            height: 40,
                          ),
                          StreamBuilder<List<Service>>(
                            stream: BlocProvider.of<StoreBloc>(context)
                                .getListService(widget.rescue.idStore),
                            builder: (context, snapshot) {
                              return Row(
                                children: [
                                  Text(
                                    'Dịch vụ',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Thêm dịch vụ'),
                                            content: DropdownButton(
                                              hint: Text('Dịch vụ'),
                                              underline: SizedBox(),
                                              isExpanded: true,
                                              // value: valueChoose,
                                              onChanged: (value) {
                                                setState(() {
                                                  if (!listServiceSelected
                                                      .contains(value)) {
                                                    listServiceSelected
                                                        .add(value);
                                                  }
                                                });
                                              },
                                              items: snapshot.data.map((value) {
                                                return DropdownMenuItem(
                                                    value: value,
                                                    child:
                                                        Text('${value.name}'));
                                              }).toList(),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: <Widget>[
                              Text('Tên'),
                              Spacer(),
                              Text('Đơn giá'),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          if (listServiceSelected.isNotEmpty)
                            Column(
                              children: listServiceSelected.map((e) {
                                return Row(
                                  children: [
                                    Text(e.name),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Spacer(),
                                    Text(e.price),
                                  ],
                                );
                              }).toList(),
                            ),
                          SizedBox(
                            height: 120,
                          ),
                          SizedBox(
                            height: 240,
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                          //   child: SizedBox(
                          //     width: 390,
                          //     height: 52,
                          //     child: ElevatedButton(
                          //       onPressed: () {},
                          //       child: Text(
                          //         "Thêm Hoá Đơn",
                          //         style: TextStyle(
                          //             color: Colors.white, fontSize: 18),
                          //       ),
                          //       style: ElevatedButton.styleFrom(
                          //         primary: Colors.blueGrey[800],
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius:
                          //                 BorderRadius.all(Radius.circular(6))),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          //   child: SizedBox(
                          //     width: 390,
                          //     height: 52,
                          //     child: ElevatedButton(
                          //       onPressed: () {},
                          //       child: Text(
                          //         "Huỷ Yêu Cầu",
                          //         style: TextStyle(
                          //             color: Colors.white, fontSize: 18),
                          //       ),
                          //       style: ElevatedButton.styleFrom(
                          //         primary: Colors.red[800],
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius:
                          //                 BorderRadius.all(Radius.circular(6))),
                          //       ),
                          //     ),
                          //   ),
                          // ),
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
                  return Container(
                    height: 180,
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
                                text: "Tổng tiền: ",
                                style: TextStyle(fontSize: 16),
                                children: [
                                  // if (user != null)
                                  if (listServiceSelected.isNotEmpty)
                                    TextSpan(
                                      text:
                                          '${getTotalPrice(listServiceSelected).toStringAsFixed(0)}',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  // if (state.listService.isEmpty)
                                  // if (user == null)
                                  TextSpan(
                                    text: "",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 100,
                            ),
                            SizedBox(
                              width: 150,
                              height: 50,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                onPressed: () {},
                                textColor: Colors.white,
                                color: Colors.blueGrey[800],
                                child: Text(
                                  'Thanh toán',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }));
      },
    );
  }
}
