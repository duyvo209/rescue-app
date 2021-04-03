// import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rescue/blocs/auth/authencation_bloc.dart';
import 'package:rescue/blocs/store/store_bloc.dart';
import 'package:rescue/blocs/user/user_bloc.dart';
import 'package:rescue/screens/ChatScreen.dart';
import 'package:rescue/screens/InforStoreScreen.dart';
import 'package:rescue/screens/MapScreen.dart';
import 'package:rescue/screens/ProfileScreen.dart';
import 'package:rescue/screens/IntroScreen.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

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

  Completer<GoogleMapController> _controller = Completer();
  // Configure map position and zoom
  CameraPosition _kGooglePlex;

  Set<Marker> _marker = {};
  BitmapDescriptor iconMarker;

  @override
  void initState() {
    BlocProvider.of<StoreBloc>(context).add(GetListStore());
    // _kGooglePlex = CameraPosition(
    //   target: LatLng(_originLatitude, _originLongitude),
    //   zoom: 9.4746,
    // );

    BlocProvider.of<UserBloc>(context)
        .add(GetUser(FirebaseAuth.instance.currentUser.uid));

    _kGooglePlex = CameraPosition(
      // target: LatLng(10.7915178, 106.7271422),
      target: LatLng(10.02545, 105.77621),
      zoom: 14.4746,
    );

    /// add origin marker origin marker
    // _addMarker(
    //   LatLng(_originLatitude, _originLongitude),
    //   "origin",
    //   BitmapDescriptor.defaultMarker,
    // );

    // // Add destination marker
    // _addMarker(
    //   LatLng(_destLatitude, _destLongitude),
    //   "destination",
    //   BitmapDescriptor.defaultMarkerWithHue(90),
    // );

    // _getPolyline();

    setCustomMarker();

    super.initState();
  }

  void setCustomMarker() async {
    iconMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/motoicon.png');
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StoreBloc, StoreState>(
      listener: (_, state) {
        if (state.listStore.isNotEmpty) {
          state.listStore.forEach((element) {
            _marker.add(Marker(
              markerId: MarkerId('${element.email}'),
              position: LatLng(element.lat, element.long),
              icon: iconMarker,
              infoWindow: InfoWindow(
                title: '${element.name}',
                snippet: '${element.address}',
              ),
            ));
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
            IconButton(
              icon: Icon(Icons.message),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ChatScreen()));
              },
            )
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        // ),

        drawerEdgeDragWidth: 0,
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              BlocBuilder<AuthencationBloc, AuthencationState>(
                  builder: (_, state) {
                if (state is AuthenticationAuthenticated) {
                  return BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                    return UserAccountsDrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[800],
                        ),
                        accountEmail: Text('${state.user?.email}'),
                        accountName: Text('${state.user?.name}'),
                        currentAccountPicture: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: CachedNetworkImage(
                            imageUrl: '${state.user.imageUser}',
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
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
                  'Trang chủ',
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
                  'Hồ sơ',
                  style: TextStyle(fontSize: 16),
                ),
                leading: Icon(Icons.person),
              ),
              SizedBox(height: 10),
              ListTile(
                // onTap: () {
                //   Navigator.push(
                //       context,
                //       new MaterialPageRoute(
                //           builder: (context) => new MapScreen()));
                // },
                title: Text(
                  'Lịch sử',
                  style: TextStyle(fontSize: 16),
                ),
                leading: Icon(Icons.home),
              ),
              SizedBox(height: 10),
              ExpansionTile(
                title: Text(
                  'Ngôn ngữ',
                  style: TextStyle(fontSize: 16),
                ),
                leading: Icon(Icons.home),
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      setState(() {
                        EasyLocalization.of(context).locale =
                            Locale('vi', 'VN');
                      });
                    },
                    title: Text(
                      "Vietnamese",
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
                      "English",
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
                              child: Text("Bạn đã đăng xuất !"),
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
                    'Log out',
                    style: TextStyle(fontSize: 16),
                  ),
                  leading: Icon(Icons.home),
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
                polylines: Set<Polyline>.of(polylines.values),
                // markers: Set<Marker>.of(markers.values),
                // onMapCreated: (GoogleMapController controller) {
                //   _controller.complete(controller);
                // },

                markers: _marker,
                onMapCreated: _onMapCreated,
              ),
              // Positioned(
              //   left: 0,
              //   top: 0,
              //   right: 0,
              //   child: Column(
              //     children: <Widget>[
              //       Padding(
              //         padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              //         child: RidePicker(),
              //       ),
              //     ],
              //   ),
              // ),

              Container(
                padding: const EdgeInsets.fromLTRB(25, 600, 0, 0),
                child: SizedBox(
                  width: 360,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      BlocBuilder<StoreBloc, StoreState>(
                          builder: (context, state) {
                        return Column(
                            children: state.listStore.map((e) {
                          return Text('${e.name}');
                        }).toList());
                      });
                    },
                    child: Text(
                      "Tìm kiếm cửa hàng gần bạn",
                      style:
                          TextStyle(color: Colors.blueGrey[800], fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white.withOpacity(0.7),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: BlocBuilder<StoreBloc, StoreState>(
                      builder: (context, state) {
                    // List<Store> temp = state.listStore.map((e) => e);
                    state.listStore.sort((a, b) => a
                        .getM(10.02545, 105.77621)
                        .compareTo(b.getM(10.02545, 105.77621)));
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: state.listStore.map((e) {
                        double m = e.getM(10.02545, 105.77621);
                        // calculateDistance(10.02545, 105.77621, e.lat, e.long);
                        return Container(
                            height: 120,
                            width: MediaQuery.of(context).size.width * 0.8,
                            margin: EdgeInsets.only(
                                left: 20, right: 20, bottom: 35),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[800],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => InforStoreScreen(
                                              store: e,
                                            )));
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    child: Image.asset('assets/2.jpeg',
                                        fit: BoxFit.cover),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${e.name}',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      // Text(
                                      //   "${e.address}",
                                      //   maxLines: 2,
                                      //   overflow: TextOverflow.ellipsis,
                                      //   style: TextStyle(color: Colors.white),
                                      // ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Cách bạn ${m.toString().substring(0, 5)} km',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ));
                      }).toList()),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
