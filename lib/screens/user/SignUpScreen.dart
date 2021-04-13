import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:rescue/blocs/signup/signup_bloc.dart';
import 'package:rescue/screens/user/LoginScreen.dart';
import 'package:easy_localization/easy_localization.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatefulWidget {
  String uid;

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _retypepasswordController =
      new TextEditingController();

  String name = '';
  String email = '';
  String password = '';
  String retypepassword = '';
  bool isLoading = false;
  bool first = true;

  @override
  initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {
        name = _nameController.text;
      });
    });
    _emailController.addListener(() {
      setState(() {
        email = _emailController.text;
      });
    });
    _passwordController.addListener(() {
      setState(() {
        password = _passwordController.text;
      });
    });
    _retypepasswordController.addListener(() {
      setState(() {
        retypepassword = _retypepasswordController.text;
      });
    });
  }

  String _nameError() {
    if (first) {
      return null;
    }
    if (name == '') {
      return 'Name is invalid';
    }
    return null;
  }

  String _emailError() {
    if (first) {
      return null;
    }
    if (email == '') {
      return 'Email is invalid';
    }
    return null;
  }

  String _passwordError() {
    if (first) {
      return null;
    }
    if (password.length < 6) {
      return 'Password is invalid';
    }
    return null;
  }

  String _retypepasswordError() {
    if (first) {
      return null;
    }
    if (retypepassword == '' || retypepassword != password) {
      return 'Password incorrect';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (_, state) {
        if (state.signupSuccess) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        }
      },
      child: BlocBuilder<SignupBloc, SignupState>(
        builder: (context, state) {
          return LoadingOverlay(
            isLoading: state.signupLoading,
            opacity: 0.5,
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  iconTheme: IconThemeData(color: Colors.black),
                  elevation: 0,
                ),
                body: SafeArea(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    constraints: BoxConstraints.expand(),
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 0,
                          ),
                          Image.asset("assets/moto1.png"),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "Welcome Back!",
                              style: TextStyle(
                                  fontSize: 22, color: Color(0xff333333)),
                            ),
                          ),
                          Text(
                            "Signup to continue using dvRescue",
                            style: TextStyle(
                                fontSize: 16, color: Color(0xff606470)),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 50, 0, 5),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                  color: Color(0xFFF2F2F2),
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: TextFormField(
                                controller: _nameController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Họ tên".tr().toString(),
                                  errorText: _nameError(),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 20),
                                ),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return "a";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                  color: Color(0xFFF2F2F2),
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: TextFormField(
                                controller: _emailController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  errorText: _emailError(),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 20),
                                ),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return "a";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                  color: Color(0xFFF2F2F2),
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: TextFormField(
                                controller: _passwordController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Mật khẩu".tr().toString(),
                                  errorText: _passwordError(),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 20),
                                ),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return "a";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                  color: Color(0xFFF2F2F2),
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: TextFormField(
                                controller: _retypepasswordController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Nhập lại mật khẩu".tr().toString(),
                                  errorText: _retypepasswordError(),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 20),
                                ),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return "a";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                first = false;
                              });
                              BlocProvider.of<SignupBloc>(context).add(
                                Signup(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    uid: widget.uid),
                              );
                              await Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                            child: Container(
                              width: 360,
                              height: 52,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                  color: Colors.blueGrey[800]),
                              child: Center(
                                child: Text(
                                  'Đăng ký'.tr().toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                          //   child: SizedBox(
                          //     width: 360,
                          //     height: 52,
                          //     child: ElevatedButton(
                          //       onPressed: () async {
                          //         setState(() {
                          //           first = false;
                          //         });
                          //         BlocProvider.of<SignupBloc>(context).add(
                          //           Signup(
                          //               name: _nameController.text,
                          //               email: _emailController.text,
                          //               password: _passwordController.text,
                          //               uid: widget.uid),
                          //         );
                          //         await Navigator.push(
                          //             context,
                          //             new MaterialPageRoute(
                          //                 builder: (context) => LoginScreen()));
                          //       },
                          //       child: Text(
                          //         "Sign Up",
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
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
