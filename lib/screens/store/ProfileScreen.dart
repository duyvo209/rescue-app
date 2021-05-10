import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rescue/blocs/auth/authencation_bloc.dart';

import 'package:rescue/blocs/store/store_bloc.dart';
import 'package:rescue/models/place_service.dart';
import 'package:rescue/screens/user/AddressSreachScreen.dart';
import 'package:uuid/uuid.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();
  final TextEditingController _addressController = new TextEditingController();
  final TextEditingController _timeController = new TextEditingController();

  Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Chỉnh sửa hồ sơ'.tr().toString()),
        backgroundColor: Colors.blueGrey[800],
        brightness: Brightness.light,
        elevation: 0,
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              BlocBuilder<AuthencationBloc, AuthencationState>(
                  builder: (_, state) {
                if (state is AuthenticationAuthenticated) {
                  return BlocBuilder<StoreBloc, StoreState>(
                      builder: (context, state) {
                    state.store.name == null
                        ? _nameController.text = ""
                        : _nameController.text = state.store.name;

                    state.store.phone == null
                        ? _phoneController.text = ""
                        : _phoneController.text = state.store.phone;

                    state.store.address == null
                        ? _addressController.text = ""
                        : _addressController.text = state.store.address;

                    // state.store.time == null
                    //     // ignore: unnecessary_statements
                    //     ? _timeController.text == ""
                    //     // ignore: unnecessary_statements
                    //     : _timeController.text == state.store.time;

                    return Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 5),
                                labelText: 'Họ tên'.tr().toString(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintStyle: TextStyle(
                                    fontSize: 20, color: Colors.black)),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: TextField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 5),
                                labelText: 'Số điện thoại'.tr().toString(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                // hintText: '0939397979',
                                hintStyle: TextStyle(
                                    fontSize: 20, color: Colors.black)),
                          ),
                        ),
                        // SizedBox(
                        //   height: 35,
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.only(left: 5, right: 5),
                        //   child: TextField(
                        //     controller: _timeController,
                        //     decoration: InputDecoration(
                        //         contentPadding: EdgeInsets.only(bottom: 5),
                        //         labelText:
                        //             'Giờ mở cửa - đóng cửa'.tr().toString(),
                        //         floatingLabelBehavior:
                        //             FloatingLabelBehavior.always,
                        //         hintStyle: TextStyle(
                        //             fontSize: 20, color: Colors.black)),
                        //   ),
                        // ),
                        SizedBox(
                          height: 35,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final sessionToken = Uuid().v4();
                            final Suggestion result = await showSearch(
                              context: context,
                              delegate: AddressSearch(sessionToken),
                            ).then((value) {
                              _addressController.text = value.description;
                              return value;
                            });
                            // This will change the text displayed in the TextField
                            if (result != null) {
                              final placeDetails =
                                  await PlaceApiProvider(sessionToken)
                                      .getPlaceDetailFromId(result.placeId);
                              place = placeDetails;

                              //print(placeDetails.);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: TextField(
                              enabled: false,
                              controller: _addressController,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 5),
                                  labelText: 'Địa chỉ'.tr().toString(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  // hintText: 'Can Tho',
                                  hintStyle: TextStyle(
                                      fontSize: 20, color: Colors.black)),
                            ),
                          ),
                        ),
                      ],
                    );
                  });
                }
                return Container();
              }),
              SizedBox(
                height: 140,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            color: Colors.red[900]),
                        child: Center(
                          child: Text(
                            'Huỷ'.tr().toString(),
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
                    width: 30,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        BlocProvider.of<StoreBloc>(context).add(
                          UpdateStore(
                            FirebaseAuth.instance.currentUser.uid,
                            _nameController.text,
                            _phoneController.text,
                            _addressController.text,
                            _timeController.text,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            color: Colors.blueGrey[800]),
                        child: Center(
                          child: Text(
                            'Lưu'.tr().toString(),
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
            ],
          ),
        ),
      ),
    );
  }
}
