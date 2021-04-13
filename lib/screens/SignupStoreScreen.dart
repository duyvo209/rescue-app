// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:loading_overlay/loading_overlay.dart';
// import 'package:rescue/blocs/signupStore/signupstore_bloc.dart';
// import 'package:rescue/blocs/store/store_bloc.dart';
// import 'package:rescue/models/place_service.dart';
// import 'package:rescue/screens/user/AddressSreachScreen.dart';
// import 'package:rescue/screens/store/LoginStoreScreen.dart';
// import 'package:uuid/uuid.dart';
// import 'package:easy_localization/easy_localization.dart';

// const kGoogleApiKey = "AIzaSyBHRMxpBKc25CMHY51h1jrnCCm6PjNs62s";

// // ignore: must_be_immutable
// class SignupStoreScreen extends StatefulWidget {
//   String uid;
//   @override
//   _SignupStoreScreenState createState() => _SignupStoreScreenState();
// }

// class _SignupStoreScreenState extends State<SignupStoreScreen> {
//   final TextEditingController _nameController = new TextEditingController();
//   final TextEditingController _emailController = new TextEditingController();
//   final TextEditingController _passwordController = new TextEditingController();
//   final TextEditingController _retypepasswordController =
//       new TextEditingController();
//   final TextEditingController _phoneController = new TextEditingController();
//   final TextEditingController _addressController = new TextEditingController();
//   final TextEditingController _timeController = new TextEditingController();

//   String name = '';
//   String email = '';
//   String password = '';
//   String retypepassword = '';
//   String phone = '';
//   String address = '';
//   String time = '';
//   bool isLoading = false;
//   bool first = true;
//   Place place;
//   @override
//   initState() {
//     super.initState();
//     _nameController.addListener(() {
//       setState(() {
//         name = _nameController.text;
//       });
//     });
//     _emailController.addListener(() {
//       setState(() {
//         email = _emailController.text;
//       });
//     });
//     _passwordController.addListener(() {
//       setState(() {
//         password = _passwordController.text;
//       });
//     });
//     _retypepasswordController.addListener(() {
//       setState(() {
//         retypepassword = _retypepasswordController.text;
//       });
//     });
//     _phoneController.addListener(() {
//       setState(() {
//         phone = _phoneController.text;
//       });
//     });
//     _addressController.addListener(() {
//       setState(() {
//         address = _addressController.text;
//       });
//     });
//     _timeController.addListener(() {
//       setState(() {
//         _timeController.text;
//       });
//     });
//   }

//   String _nameError() {
//     if (first) {
//       return null;
//     }
//     if (name == '') {
//       return 'Name is invalid';
//     }
//     return null;
//   }

//   String _emailError() {
//     if (first) {
//       return null;
//     }
//     if (email == '') {
//       return 'Email is invalid';
//     }
//     return null;
//   }

//   String _passwordError() {
//     if (first) {
//       return null;
//     }
//     if (password.length < 6) {
//       return 'Password is invalid';
//     }
//     return null;
//   }

//   String _retypepasswordError() {
//     if (first) {
//       return null;
//     }
//     if (retypepassword == '' || retypepassword != password) {
//       return 'Password incorrect';
//     }
//     return null;
//   }

//   String _phoneError() {
//     if (first) {
//       return null;
//     }
//     if (name == '') {
//       return 'Phone is invalid';
//     }
//     return null;
//   }

//   String _addressError() {
//     if (first) {
//       return null;
//     }
//     if (email == '') {
//       return 'Address is invalid';
//     }
//     return null;
//   }

//   String _timeError() {
//     if (first) {
//       return null;
//     }
//     if (email == '') {
//       return 'Time is invalid';
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<StoreBloc, StoreState>(
//       listener: (_, state) {
//         if (state.storeSuccess) {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (context) => LoginStoreScreen()));
//         }
//       },
//       child: BlocBuilder<StoreBloc, StoreState>(
//         builder: (context, state) {
//           return LoadingOverlay(
//             isLoading: state.storeLoading,
//             opacity: 0.5,
//             color: Colors.transparent,
//             child: GestureDetector(
//               onTap: () {
//                 FocusScope.of(context).unfocus();
//               },
//               child: Scaffold(
//                 appBar: AppBar(
//                   backgroundColor: Colors.white,
//                   iconTheme: IconThemeData(color: Colors.black),
//                   elevation: 0,
//                 ),
//                 body: SafeArea(
//                   child: Container(
//                     padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
//                     constraints: BoxConstraints.expand(),
//                     color: Colors.white,
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: <Widget>[
//                           SizedBox(
//                             height: 0,
//                           ),
//                           Image.asset("assets/moto1.png"),
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//                             child: Text(
//                               "Welcome Back!",
//                               style: TextStyle(
//                                   fontSize: 22, color: Color(0xff333333)),
//                             ),
//                           ),
//                           Text(
//                             "Signup to continue using dvRescue",
//                             style: TextStyle(
//                                 fontSize: 16, color: Color(0xff606470)),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(0, 50, 0, 5),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(
//                                   horizontal: 4.0, vertical: 4.0),
//                               decoration: BoxDecoration(
//                                   color: Color(0xFFF2F2F2),
//                                   borderRadius: BorderRadius.circular(12.0)),
//                               child: TextFormField(
//                                 controller: _nameController,
//                                 textInputAction: TextInputAction.next,
//                                 decoration: InputDecoration(
//                                   border: InputBorder.none,
//                                   hintText: "Tên cửa hàng".tr().toString(),
//                                   errorText: _nameError(),
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: 24, vertical: 20),
//                                 ),
//                                 validator: (String value) {
//                                   if (value.isEmpty) {
//                                     return "a";
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(
//                                   horizontal: 4.0, vertical: 4.0),
//                               decoration: BoxDecoration(
//                                   color: Color(0xFFF2F2F2),
//                                   borderRadius: BorderRadius.circular(12.0)),
//                               child: TextFormField(
//                                 controller: _emailController,
//                                 textInputAction: TextInputAction.next,
//                                 decoration: InputDecoration(
//                                   border: InputBorder.none,
//                                   hintText: "Email",
//                                   errorText: _emailError(),
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: 24, vertical: 20),
//                                 ),
//                                 validator: (String value) {
//                                   if (value.isEmpty) {
//                                     return "a";
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(
//                                   horizontal: 4.0, vertical: 4.0),
//                               decoration: BoxDecoration(
//                                   color: Color(0xFFF2F2F2),
//                                   borderRadius: BorderRadius.circular(12.0)),
//                               child: TextFormField(
//                                 controller: _passwordController,
//                                 textInputAction: TextInputAction.next,
//                                 decoration: InputDecoration(
//                                   border: InputBorder.none,
//                                   hintText: "Mật khẩu".tr().toString(),
//                                   errorText: _passwordError(),
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: 24, vertical: 20),
//                                 ),
//                                 validator: (String value) {
//                                   if (value.isEmpty) {
//                                     return "a";
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(
//                                   horizontal: 4.0, vertical: 4.0),
//                               decoration: BoxDecoration(
//                                   color: Color(0xFFF2F2F2),
//                                   borderRadius: BorderRadius.circular(12.0)),
//                               child: TextFormField(
//                                 controller: _retypepasswordController,
//                                 textInputAction: TextInputAction.next,
//                                 decoration: InputDecoration(
//                                   border: InputBorder.none,
//                                   hintText: "Nhập lại mật khẩu".tr().toString(),
//                                   errorText: _retypepasswordError(),
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: 24, vertical: 20),
//                                 ),
//                                 validator: (String value) {
//                                   if (value.isEmpty) {
//                                     return "a";
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(
//                                   horizontal: 4.0, vertical: 4.0),
//                               decoration: BoxDecoration(
//                                   color: Color(0xFFF2F2F2),
//                                   borderRadius: BorderRadius.circular(12.0)),
//                               child: TextFormField(
//                                 controller: _phoneController,
//                                 textInputAction: TextInputAction.next,
//                                 decoration: InputDecoration(
//                                   border: InputBorder.none,
//                                   hintText: "Số điện thoại".tr().toString(),
//                                   errorText: _phoneError(),
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: 24, vertical: 20),
//                                 ),
//                                 validator: (String value) {
//                                   if (value.isEmpty) {
//                                     return "a";
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () async {
//                               final sessionToken = Uuid().v4();
//                               final Suggestion result = await showSearch(
//                                 context: context,
//                                 delegate: AddressSearch(sessionToken),
//                               ).then((value) {
//                                 _addressController.text = value.description;
//                                 return value;
//                               });
//                               // This will change the text displayed in the TextField
//                               if (result != null) {
//                                 final placeDetails =
//                                     await PlaceApiProvider(sessionToken)
//                                         .getPlaceDetailFromId(result.placeId);
//                                 place = placeDetails;

//                                 //print(placeDetails.);
//                               }
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
//                               child: Container(
//                                 margin: EdgeInsets.symmetric(
//                                     horizontal: 4.0, vertical: 4.0),
//                                 decoration: BoxDecoration(
//                                     color: Color(0xFFF2F2F2),
//                                     borderRadius: BorderRadius.circular(12.0)),
//                                 child: TextFormField(
//                                   enabled: false,
//                                   controller: _addressController,
//                                   textInputAction: TextInputAction.next,
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     hintText: "Địa chỉ".tr().toString(),
//                                     errorText: _addressError(),
//                                     contentPadding: EdgeInsets.symmetric(
//                                         horizontal: 24, vertical: 20),
//                                   ),
//                                   validator: (String value) {
//                                     if (value.isEmpty) {
//                                       return "a";
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(
//                                   horizontal: 4.0, vertical: 4.0),
//                               decoration: BoxDecoration(
//                                   color: Color(0xFFF2F2F2),
//                                   borderRadius: BorderRadius.circular(12.0)),
//                               child: TextFormField(
//                                 controller: _timeController,
//                                 textInputAction: TextInputAction.next,
//                                 decoration: InputDecoration(
//                                   border: InputBorder.none,
//                                   hintText:
//                                       "Giờ mở cửa - đóng cửa".tr().toString(),
//                                   errorText: _timeError(),
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: 24, vertical: 20),
//                                 ),
//                                 validator: (String value) {
//                                   if (value.isEmpty) {
//                                     return "a";
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 30,
//                           ),
//                           GestureDetector(
//                             onTap: () async {
//                               setState(() {
//                                 first = false;
//                               });
//                               BlocProvider.of<SignupstoreBloc>(context)
//                                   .add(SignupStore(
//                                 name: _nameController.text,
//                                 email: _emailController.text,
//                                 password: _passwordController.text,
//                                 phone: _phoneController.text,
//                                 address: _addressController.text,
//                                 time: _timeController.text,
//                                 lat: place?.lat,
//                                 long: place?.long,
//                                 uid: widget.uid,
//                               ));
//                               await Navigator.push(
//                                   context,
//                                   new MaterialPageRoute(
//                                       builder: (context) =>
//                                           LoginStoreScreen()));
//                             },
//                             child: Container(
//                               width: 360,
//                               height: 52,
//                               decoration: BoxDecoration(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(6)),
//                                   color: Colors.blueGrey[800]),
//                               child: Center(
//                                 child: Text(
//                                   'Đăng ký'.tr().toString(),
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
