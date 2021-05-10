import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
// import 'package:rescue/blocs/auth/authencation_bloc.dart';

import 'package:rescue/blocs/login/login_bloc.dart';
import 'package:rescue/screens/ForgotPassScreen.dart';
import 'package:rescue/screens/store/HomeScreen.dart';
import 'package:rescue/screens/store/SignupStoreScreen.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginStoreScreen extends StatefulWidget {
  @override
  _LoginStoreScreenState createState() => _LoginStoreScreenState();
}

class _LoginStoreScreenState extends State<LoginStoreScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String email = '';
  String password = '';
  bool first = true;
  @override
  initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (_, state) {
        if (state.loginError.isNotEmpty) {
          showDialog(
              context: context,
              builder: (_) {
                return SimpleDialog(
                  title: Text("Error", style: TextStyle(color: Colors.red)),
                  children: [
                    Padding(
                      child: Text(state.loginError),
                      padding: EdgeInsets.only(left: 25, right: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey[800],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        padding: EdgeInsets.only(left: 50, right: 50),
                      ),
                      child: Container(
                        child: Icon(
                          Icons.close_outlined,
                          color: Colors.white,
                        ),
                        width: 10,
                      ),
                    )
                  ],
                );
              });
        }
        if (state.loginSuccess) {
          // BlocProvider.of<AuthencationBloc>(context).add(LoggedIn());
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return LoadingOverlay(
            isLoading: state.loginLoading,
            opacity: 0.5,
            color: Colors.transparent,
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
                        Image.asset("assets/vespa.png"),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(
                            "Welcome Back!",
                            style: TextStyle(
                                fontSize: 22, color: Color(0xff333333)),
                          ),
                        ),
                        Text(
                          "Login to continue using dvRescue",
                          style:
                              TextStyle(fontSize: 16, color: Color(0xff606470)),
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
                              controller: _emailController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                errorText: _emailError(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 20),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 4.0),
                            decoration: BoxDecoration(
                                color: Color(0xFFF2F2F2),
                                borderRadius: BorderRadius.circular(12.0)),
                            child: TextFormField(
                              obscureText: true,
                              controller: _passwordController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Mật khẩu".tr().toString(),
                                errorText: _passwordError(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 20),
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
                                setState(() {
                                  first = false;
                                });
                                BlocProvider.of<LoginBloc>(context).add(
                                  Login(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                              },
                              child: Text(
                                "Đăng nhập".tr().toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blueGrey[800],
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6))),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => SignupStoreScreen()));
                          },
                          child: Text(
                            "Tạo tài khoản mới".tr().toString(),
                            style:
                                TextStyle(color: Colors.blueGrey, fontSize: 15),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => ForgotPassScreen()));
                          },
                          child: Text(
                            "Quên mật khẩu".tr().toString(),
                            style:
                                TextStyle(color: Colors.blueGrey, fontSize: 15),
                          ),
                        ),
                      ],
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

class LoggedIn {}
