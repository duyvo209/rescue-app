import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rescue/blocs/auth/authencation_bloc.dart';
import 'package:rescue/blocs/user/user_bloc.dart';
import 'package:path/path.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();
  final TextEditingController _addressController = new TextEditingController();

  String imageUser = '';
  File _image;

  Future getImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
      print('Image Path $_image');
    });
  }

  Future uploadPic() async {
    try {
      String fileName = basename(_image.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = firebaseStorageRef.putFile(_image);
      TaskSnapshot taskSnapshot = await uploadTask;
      var downloadUrl = await taskSnapshot.ref.getDownloadURL();
      String url = downloadUrl.toString();
      setState(() {
        print("Profile Picture uploaded");
      });
      return url;
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Chỉnh sửa hồ sơ'),
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
                              Align(
                                alignment: Alignment.center,
                                child: CircleAvatar(
                                  radius: 75,
                                  backgroundColor: Colors.blueGrey[800],
                                  child: ClipOval(
                                    child: new SizedBox(
                                      width: 140.0,
                                      height: 140.0,
                                      child: (_image != null)
                                          ? Image.file(
                                              _image,
                                              fit: BoxFit.fill,
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: state.user.imageUser,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
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
                                    color: Colors.orange[300],
                                  ),
                                  onPressed: () {
                                    getImage();
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
                                labelText: 'Họ tên',
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
                                labelText: 'Số điện thoại',
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
                        Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: TextField(
                            controller: _addressController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 5),
                                labelText: 'Địa chỉ',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                // hintText: 'Can Tho',
                                hintStyle: TextStyle(
                                    fontSize: 20, color: Colors.black)),
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
                            'Huỷ',
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
                        final url = await uploadPic();
                        BlocProvider.of<UserBloc>(context).add(
                          UpdateUser(
                            FirebaseAuth.instance.currentUser.uid,
                            _nameController.text,
                            _phoneController.text,
                            _addressController.text,
                            url,
                          ),
                        );
                        uploadPic();
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            color: Colors.blueGrey[800]),
                        child: Center(
                          child: Text(
                            'Lưu',
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
