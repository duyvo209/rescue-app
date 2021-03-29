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
// import 'package:rescue/blocs/login/login_bloc.dart';
import 'package:rescue/blocs/user/user_bloc.dart';
import 'package:rescue/screens/ChatScreen.dart';
// import 'package:rescue/configs/configs.dart';
import 'package:rescue/screens/MapScreen.dart';
import 'package:rescue/screens/ProfileScreen.dart';
import 'package:rescue/screens/IntroScreen.dart';
// import 'package:rescue/widgets/ride_picker.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:location/location.dart';

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

  @override
  void initState() {
    // _kGooglePlex = CameraPosition(
    //   target: LatLng(_originLatitude, _originLongitude),
    //   zoom: 9.4746,
    // );

    BlocProvider.of<UserBloc>(context)
        .add(GetUser(FirebaseAuth.instance.currentUser.uid));

    _kGooglePlex = CameraPosition(
      target: LatLng(10.7915178, 106.7271422),
      // target: LatLng(10.030828509876658, 105.77308673179196),
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'Home',
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
                'Profile',
                style: TextStyle(fontSize: 16),
              ),
              leading: Icon(Icons.person),
            ),
            SizedBox(height: 10),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new MapScreen()));
              },
              title: Text(
                'History',
                style: TextStyle(fontSize: 16),
              ),
              leading: Icon(Icons.home),
            ),
            SizedBox(height: 10),
            ExpansionTile(
              title: Text(
                'Language',
                style: TextStyle(fontSize: 16),
              ),
              leading: Icon(Icons.home),
              children: <Widget>[
                ListTile(
                  onTap: () {
                    setState(() {
                      EasyLocalization.of(context).locale = Locale('vi', 'VN');
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
                      EasyLocalization.of(context).locale = Locale('en', 'US');
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
            // ListTile(
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //         context,
            //         new MaterialPageRoute(
            //             builder: (context) => new HomeScreen()));
            //   },
            //   title: Text(
            //     'Language',
            //     style: TextStyle(fontSize: 16),
            //   ),
            //   leading: Icon(Icons.home),
            // ),
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
                            child: Text("You was logged out !"),
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
              tiltGesturesEnabled: true,
              compassEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              polylines: Set<Polyline>.of(polylines.values),
              markers: Set<Marker>.of(markers.values),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
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
                  onPressed: () {},
                  child: Text(
                    "Tìm kiếm cửa hàng gần bạn",
                    style: TextStyle(color: Colors.blueGrey[800], fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
