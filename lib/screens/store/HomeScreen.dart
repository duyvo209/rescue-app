import 'dart:async';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescue/blocs/auth/authencation_bloc.dart';
import 'package:rescue/blocs/request/request_bloc.dart';
import 'package:rescue/blocs/store/store_bloc.dart';
import 'package:rescue/configs/configs.dart';
import 'package:rescue/models/Rescue.dart';
import 'package:rescue/screens/store/ChatDetailTest.dart';
import 'package:rescue/screens/store/ConfirmScreen.dart';
import 'package:rescue/screens/store/ChatTest.dart';
import 'package:rescue/screens/store/ProfileScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:rescue/screens/store/UpdateLocationScreen.dart';
import 'package:rescue/utils/helper.dart';
import '../IntroScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  // Markers to show points on the map
  Map<MarkerId, Marker> markers = {};

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  // ignore: unused_field
  Completer<GoogleMapController> _controller = Completer();
  // Configure map position and zoom
  CameraPosition _kGooglePlex;

  Set<Marker> _marker = {};
  BitmapDescriptor iconMarker;

  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  @override
  void initState() {
    BlocProvider.of<StoreBloc>(context)
        .add(GetStore(FirebaseAuth.instance.currentUser.uid));

    BlocProvider.of<RequestBloc>(context)
        .add(GetRequest(idStore: FirebaseAuth.instance.currentUser.uid));

    _kGooglePlex = CameraPosition(
      // target: LatLng(10.7915178, 106.7271422),
      target: LatLng(10.03088, 105.76904),
      zoom: 14.4746,
    );

    setCustomMarker();

    super.initState();
  }

  void setCustomMarker() async {
    iconMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/man.png');
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {});
    setMapPins();
    // setPolylines();
  }

  void setMapPins() {
    setState(() {
      BlocListener<RequestBloc, RequestState>(
        listener: (_, state) {
          if (state.request.isNotEmpty) {
            state.request.forEach((element) {
              _marker.add(Marker(
                markerId: MarkerId('${element.idUser}'),
                position: LatLng(element.latUser, element.lngUser),
                icon: iconMarker,
                infoWindow: InfoWindow(
                  title: '${element.userInfo.name}',
                  snippet:
                      '${element.userInfo.phone}\n${element.problems.first.name}',
                ),
              ));
            });
          }
        },
      );
    });
  }

  setPolylines(latitude, longitude) async {
    polylineCoordinates.clear();
    PolylineResult resultPoly =
        await polylinePoints?.getRouteBetweenCoordinates(
            GOOGLE_API_KEY,
            PointLatLng(10.028118, 105.773649),
            PointLatLng(latitude, longitude));
    List<PointLatLng> result = resultPoly?.points;

    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      Polyline polyline = Polyline(
          polylineId: PolylineId('poly'),
          geodesic: true,
          width: 5,
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates);
      _polylines.add(polyline);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RequestBloc, RequestState>(
      listener: (_, state) {
        if (state.request.isNotEmpty) {
          setState(() {
            state.request.forEach((element) {
              _marker.add(Marker(
                markerId: MarkerId('${element.userInfo.email}'),
                position: LatLng(element.latUser, element.lngUser),
                icon: iconMarker,
                infoWindow: InfoWindow(
                  title: '${element.userInfo.name}',
                  snippet:
                      '${element.userInfo.phone}\n${element.problems.first.name}',
                ),
              ));
            });
          });
        }
      },
      child: Scaffold(
        key: drawerKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text('dvRescue'),
          backgroundColor: Colors.blueGrey[800],
          brightness: Brightness.light,
          elevation: 0,
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              drawerKey.currentState.openDrawer();
            },
          ),
          actions: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('storeId',
                      isEqualTo: FirebaseAuth.instance.currentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.docs.isNotEmpty) {
                    return BlocBuilder<AuthencationBloc, AuthencationState>(
                        builder: (context, authState) {
                      return Badge(
                        showBadge: authState is AuthenticationAuthenticated,
                        badgeContent: Text(
                          '${snapshot.data.docs.length}',
                          style: TextStyle(color: Colors.white),
                        ),
                        badgeColor: Colors.red[600],
                        shape: BadgeShape.circle,
                        position: BadgePosition.topStart(start: 25, top: 2.5),
                        animationType: BadgeAnimationType.scale,
                        child: IconButton(
                          icon: Icon(Icons.messenger_rounded),
                          onPressed: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new ChatTest()));
                          },
                        ),
                      );
                    });
                  }
                }
                return IconButton(
                  icon: Icon(Icons.messenger_rounded),
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new ChatTest()));
                  },
                );
              },
            ),
          ],
        ),
        drawerEdgeDragWidth: 0,
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              BlocBuilder<AuthencationBloc, AuthencationState>(
                  builder: (_, state) {
                if (state is AuthenticationAuthenticated) {
                  return BlocBuilder<StoreBloc, StoreState>(
                      builder: (context, state) {
                    return UserAccountsDrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[800],
                        ),
                        accountEmail: Text('${state.store?.email}'),
                        accountName: Text('${state.store?.name}'),
                        currentAccountPicture: ClipRRect(
                          // borderRadius: BorderRadius.circular(70),
                          child: Image.asset('assets/2.jpeg'),
                        ));
                  });
                }
                return Container();
              }),
              SizedBox(height: 10),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new HomeScreen()));
                },
                title: Text(
                  'Trang chủ'.tr().toString(),
                  style: TextStyle(fontSize: 16),
                ),
                leading: Icon(Icons.home),
              ),
              SizedBox(height: 10),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new ProfileScreen()));
                },
                title: Text(
                  'Hồ sơ'.tr().toString(),
                  style: TextStyle(fontSize: 16),
                ),
                leading: Icon(Icons.person),
              ),
              SizedBox(height: 10),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new UpdateLocationScreen()));
                },
                title: Text(
                  'Cập nhật vị trí'.tr().toString(),
                  style: TextStyle(fontSize: 16),
                ),
                leading: Icon(Icons.location_on),
              ),
              SizedBox(height: 10),
              ExpansionTile(
                title: Text(
                  'Ngôn ngữ'.tr().toString(),
                  style: TextStyle(fontSize: 16),
                ),
                leading: Icon(Icons.language),
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      setState(() {
                        EasyLocalization.of(context).locale =
                            Locale('vi', 'VN');
                      });
                    },
                    title: Text(
                      "Vietnamese".tr().toString(),
                      style: TextStyle(fontSize: 16),
                    ),
                    leading: Icon(Icons.arrow_forward),
                    //Icon(),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        EasyLocalization.of(context).locale =
                            Locale('en', 'US');
                      });
                    },
                    title: Text(
                      "English".tr().toString(),
                      style: TextStyle(fontSize: 16),
                    ),
                    leading: Icon(Icons.arrow_forward),
                    //Icon(),
                  ),
                ],
              ),
              SizedBox(height: 10),
              BlocBuilder<AuthencationBloc, AuthencationState>(
                  builder: (_, state) {
                return ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return SimpleDialog(
                          title: Text(
                            'Success',
                            style: TextStyle(
                              color: Colors.green[600],
                            ),
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 25, right: 20),
                              child: Text("Bạn đã đăng xuất !".tr().toString()),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            RaisedButton(
                              onPressed: () {
                                BlocProvider.of<AuthencationBloc>(context)
                                    .add((LoggedOut()));
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => IntroScreen()),
                                    (route) => false);
                              },
                              padding: EdgeInsets.only(left: 50, right: 50),
                              child: Container(
                                child: Icon(
                                  Icons.check_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              color: Colors.blueGrey[800],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  title: Text(
                    'Đăng xuất'.tr().toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                  leading: Icon(Icons.logout),
                );
              }),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 16 / 5,
                    child: Image.asset(
                      "assets/banner.jpeg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          constraints: BoxConstraints.expand(),
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                tiltGesturesEnabled: true,
                compassEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                markers: _marker,
                onMapCreated: _onMapCreated,
                polylines: _polylines,
              ),
              Positioned.fill(
                  child: Align(
                alignment: Alignment.topCenter,
                child: StreamBuilder<List<Rescue>>(
                  stream: FirebaseFirestore.instance
                      .collection('request')
                      .where('idStore',
                          isEqualTo: FirebaseAuth.instance.currentUser.uid)
                      .orderBy('time', descending: true)
                      .snapshots()
                      .asyncMap((event) => event.docs
                          .map((e) => Rescue.fromFireStore(
                              e.data()..addAll({'idRequest': e.id})))
                          .toList()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var requests = snapshot.data;
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: requests.map((e) {
                            if (e.checkout == 0) {}
                            var store =
                                BlocProvider.of<StoreBloc>(context).state.store;
                            if (store != null) {
                              double m = Helper.getDistanceBetween(
                                  e.latUser, e.lngUser, store.lat, store.long);
                              return Container(
                                height: 215,
                                width: MediaQuery.of(context).size.width * 0.8,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[800],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 170,
                                        child: CachedNetworkImage(
                                            imageUrl: e.userInfo.imageUser,
                                            fit: BoxFit.cover),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${e.userInfo.name}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '${e.userInfo.phone}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Cách bạn ${m.toStringAsFixed(2)} km',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${e.problems.first.name}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Container(
                                              height: 35,
                                              child: IconButton(
                                                  icon: Icon(
                                                    Icons.arrow_forward,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    setPolylines(
                                                        e.latUser, e.lngUser);
                                                  }),
                                            ),
                                            // SizedBox(
                                            //   height: 5,
                                            // ),
                                            Row(
                                              children: [
                                                FlatButton(
                                                  color: Colors.white70,
                                                  onPressed: () {
                                                    BlocProvider.of<
                                                                RequestBloc>(
                                                            context)
                                                        .add(
                                                      UpdateStatus(
                                                        status: 1,
                                                        requestId: e.idRequest,
                                                      ),
                                                    );

                                                    Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                            builder: (context) =>
                                                                ComfirmScreen(
                                                                    rescue:
                                                                        e)));
                                                  },
                                                  child: Text(
                                                    'Xác nhận'.tr().toString(),
                                                  ),
                                                ),
                                                Spacer(),
                                                StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(e.idUser)
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      return FlatButton(
                                                        color: Colors.white70,
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            new MaterialPageRoute(
                                                              builder: (context) =>
                                                                  new ChatDetailTest(
                                                                docs: snapshot
                                                                    .data,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Text(
                                                          'Nhắn tin'
                                                              .tr()
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      );
                                                    }
                                                    return Container();
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return Container();
                          }).toList(),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
