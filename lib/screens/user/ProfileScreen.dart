import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:rescue/blocs/auth/authencation_bloc.dart';
import 'package:rescue/blocs/user/user_bloc.dart';
import 'package:path/path.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();
  final TextEditingController _addressController = new TextEditingController();

  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  UploadTask uploadedTasks;
  File file;
  bool showLoading = false;

  Future selectFileToUpload() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);

      if (result == null) return;
      final path = result.files.single.path;
      setState(() {
        file = File(path);
      });
    } catch (e) {
      print(e);
    }
  }

  Future upLoadFileToStorage() async {
    if (file == null) return;

    final fileName = basename(file.path);
    final destination = '$fileName';

    uploadedTasks = _firebaseStorage.ref().child(destination).putFile(file);
    setState(() {});

    if (uploadedTasks == null) return;

    final snapshot = await uploadedTasks.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    // print('Download-Link: $urlDownload');
    return urlDownload;
  }

  @override
  Widget build(BuildContext context) {
    // final fileName = file != null ? basename(file.path) : '';
    return LoadingOverlay(
      isLoading: showLoading,
      opacity: 0.5,
      color: Colors.transparent,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Ch???nh s???a h??? s??'.tr().toString()),
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
                    return BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                      state.user.name == null
                          ? _nameController.text = ""
                          : _nameController.text = state.user.name;

                      state.user.phone == null
                          ? _phoneController.text = ""
                          : _phoneController.text = state.user.phone;

                      state.user.address == null
                          ? _addressController.text = ""
                          : _addressController.text = state.user.address;

                      return Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Stack(
                              children: [
                                state.user.imageUser == null
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: CircleAvatar(
                                          radius: 75,
                                          backgroundColor: Colors.blueGrey[800],
                                          child: ClipOval(
                                            child: SizedBox(
                                              width: 140.0,
                                              height: 140.0,
                                              child: Image.asset(
                                                  'assets/noavt.png'),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Align(
                                        alignment: Alignment.center,
                                        child: CircleAvatar(
                                          radius: 75,
                                          backgroundColor: Colors.blueGrey[800],
                                          child: ClipOval(
                                              child: new SizedBox(
                                            width: 140.0,
                                            height: 140.0,
                                            child: (file != null)
                                                ? Image.asset(
                                                    ((file.path)),
                                                    fit: BoxFit.cover,
                                                  )
                                                // ? Text(basename(file.path))
                                                : CachedNetworkImage(
                                                    imageUrl:
                                                        state.user.imageUser,
                                                    fit: BoxFit.cover,
                                                  ),
                                          )),
                                        ),
                                      ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 100,
                                    left: 220,
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.camera_alt,
                                      size: 40.0,
                                      color: Colors.black45,
                                    ),
                                    onPressed: () {
                                      selectFileToUpload();
                                    },
                                  ),
                                ),
                              ],
                            ),
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
                                  labelText: 'H??? t??n'.tr().toString(),
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
                                  labelText: 'S??? ??i???n tho???i'.tr().toString(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  // hintText: '0939397979',
                                  hintStyle: TextStyle(
                                      fontSize: 20, color: Colors.black)),
                            ),
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          GestureDetector(
                            onTap: () async {
                              // final sessionToken = Uuid().v4();
                              // final Suggestion result = await showSearch(
                              //   context: context,
                              //   delegate: AddressSearch(sessionToken),
                              // ).then((value) {
                              //   _addressController.text = value.description;
                              //   return value;
                              // });
                              // // This will change the text displayed in the TextField
                              // if (result != null) {
                              //   final placeDetails =
                              //       await PlaceApiProvider(sessionToken)
                              //           .getPlaceDetailFromId(result.placeId);
                              //   place = placeDetails;

                              //   //print(placeDetails.);
                              // }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: TextField(
                                // enabled: false,
                                controller: _addressController,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 5),
                                    labelText: '?????a ch???'.tr().toString(),
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
                      width: 30,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            showLoading = true;
                          });
                          final url = await upLoadFileToStorage();
                          BlocProvider.of<UserBloc>(context).add(
                            UpdateUser(
                              FirebaseAuth.instance.currentUser.uid,
                              _nameController.text,
                              _phoneController.text,
                              _addressController.text,
                              url,
                            ),
                          );
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              color: Colors.blueGrey[800]),
                          child: Center(
                            child: Text(
                              'L??u'.tr().toString(),
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
      ),
    );
  }
}
