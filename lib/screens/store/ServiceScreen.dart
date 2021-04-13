import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescue/blocs/store/store_bloc.dart';

class ServiceScreen extends StatefulWidget {
  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  var store;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  String id;
  String name = '';
  String price = '';
  String desc = '';

  @override
  void initState() {
    store = BlocProvider.of<StoreBloc>(context).state.store.idStore;
    print("store ${store}");
    _nameController.addListener(() {
      setState(() {
        name = _nameController.text;
      });
    });
    _priceController.addListener(() {
      setState(() {
        price = _priceController.text;
      });
    });
    _descController.addListener(() {
      setState(() {
        desc = _descController.text;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Dịch vụ'),
        backgroundColor: Colors.blueGrey[800],
        brightness: Brightness.light,
        elevation: 0,
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 5),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                  decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Tên dịch vụ",
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                  decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: TextFormField(
                    controller: _priceController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Giá",
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                  decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: TextFormField(
                    controller: _descController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Mô tả",
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                child: SizedBox(
                  width: 360,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<StoreBloc>(context).add(AddToService(
                        name: _nameController.text,
                        price: _priceController.text,
                        desc: _descController.text,
                        id: '',
                        storeId: store,
                      ));
                    },
                    child: Text(
                      "Thêm dịch vụ",
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
}
