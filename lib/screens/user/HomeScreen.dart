import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rescue/blocs/auth/authencation_bloc.dart';
import 'package:rescue/blocs/store/store_bloc.dart';
import 'package:rescue/blocs/user/user_bloc.dart';
import 'package:rescue/configs/configs.dart';
import 'package:rescue/screens/user/ServiceScreen.dart';
import 'package:rescue/screens/user/ChatTest.dart';
import 'package:rescue/screens/user/HistoryScreen.dart';
import 'package:rescue/screens/user/InforStoreScreen.dart';
import 'package:rescue/screens/user/ProblemScreen.dart';
import 'package:rescue/screens/user/ProfileScreen.dart';
import 'package:rescue/screens/IntroScreen.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:badges/badges.dart';

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
  bool _isLoading = true;

  @override
  void initState() {
    BlocProvider.of<StoreBloc>(context).add(GetListStore());
    // _kGooglePlex = CameraPosition(
    //   target: LatLng(_originLatitude, _originLongitude),
    //   zoom: 9.4746,
    // );

    BlocProvider.of<UserBloc>(context)
        .add(GetUser(FirebaseAuth.instance.currentUser.uid));

    // _kGooglePlex = CameraPosition(
    //   // target: LatLng(10.7915178, 106.7271422),
    //   target: LatLng(10.02545, 105.77621),
    //   zoom: 14.4746,
    // );

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
    _getCurrentLocation();
    super.initState();
  }

  _getCurrentLocation() async {
    try {
      Location location = new Location();
      var data = await location.getLocation();
      setState(() {
        _kGooglePlex = CameraPosition(
          // target: LatLng(10.7915178, 106.7271422),
          target: LatLng(data.latitude, data.longitude),
          zoom: 14.4746,
        );
        _isLoading = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  void setCustomMarker() async {
    iconMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/storeicon.png');
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {});
    // setMapPins();
    // setPolylines();
  }

  void setMapPins() {
    setState(() {
      BlocListener<StoreBloc, StoreState>(
        listener: (_, state) {
          if (state.listStore.isNotEmpty) {
            setState(() {
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
            PointLatLng(10.029939, 105.768421),
            PointLatLng(latitude, longitude));
    List<PointLatLng> result = resultPoly?.points;
    // print(result);
    if (result.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId('poly'),
          geodesic: true,
          width: 5,
          color: Color.fromARGB(255, 40, 122, 198),
          // points: [LatLng(latitude, longitude), LatLng(10.02545, 105.77621)]);
          points: polylineCoordinates);
      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    });
  }

  double rating;
  int sumrating = 0;
  int size;

  @override
  Widget build(BuildContext context) {
    return BlocListener<StoreBloc, StoreState>(
      listener: (_, state) {
        if (state.listStore.isNotEmpty) {
          setState(() {
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
                onPressed: () {
                  setState(() {
                    BlocProvider.of<StoreBloc>(context).add(GetListStore());
                    _polylines.clear();
                    // BlocBuilder<StoreBloc, StoreState>(
                    //     builder: (context, state) {
                    //   return setPolylines(state.store.lat, state.store.long);
                    // });
                  });
                },
                icon: Icon(Icons.refresh)),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('userId',
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
                          child: state.user.imageUser != null
                              ? CachedNetworkImage(
                                  imageUrl: '${state.user.imageUser}',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                )
                              : Text(''),
                        ));
                  });
                }
                return Container();
              }),
              SizedBox(height: 10),
              ListTile(
                onTap: () {
                  // Navigator.pop(context);
                  Navigator.pushReplacement(
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
                          builder: (context) => new HistoryScreen()));
                },
                title: Text(
                  'Lịch sử'.tr().toString(),
                  style: TextStyle(fontSize: 16),
                ),
                leading: Icon(Icons.history),
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
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
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
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 490, 30, 0),
                      // color: Colors.red,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 1,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            var store = await Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new ServiceScreen()));
                            if (store != null) {
                              setPolylines(store.lat, store.long);
                            }
                          },
                          child: Text(
                            'Dịch vụ bạn cần là gì ?',
                            style: TextStyle(
                                color: Colors.blueGrey[800], fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white.withOpacity(0.7),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 555, 30, 0),
                      // color: Colors.red,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 1,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            var store = await Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new ProblemScreen()));
                            if (store != null) {
                              setPolylines(store.lat, store.long);
                            }
                          },
                          child: Text(
                            'Vấn đề của bạn là gì ?'.tr().toString(),
                            style: TextStyle(
                                color: Colors.blueGrey[800], fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white.withOpacity(0.7),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: BlocBuilder<StoreBloc, StoreState>(
                            builder: (context, state) {
                          if (state.listStore != null &&
                              state.listStore.isNotEmpty) {
                            state.listStore.sort((a, b) => a
                                .getM(10.029939, 105.768421)
                                .compareTo(b.getM(10.029939, 105.768421)));
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: state.listStore.map((e) {
                                double m = e.getM(10.029939, 105.768421);
                                // calculateDistance(10.02545, 105.77621, e.lat, e.long);
                                return Container(
                                    height: 160,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
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
                                                builder: (context) =>
                                                    InforStoreScreen(
                                                      store: e,
                                                    )));
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 110,
                                            height: 120,
                                            child: Image.asset('assets/2.jpeg',
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
                                                  '${e.name}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "${e.address.toString()}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Cách bạn ${m.toString().substring(0, 4)} km',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  child: StreamBuilder<
                                                      QuerySnapshot>(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('feedback')
                                                        .where('storeId',
                                                            isEqualTo:
                                                                e.idStore)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        sumrating = 0;
                                                        rating = 0;

                                                        return Column(
                                                          children: [
                                                            Row(
                                                              children: snapshot
                                                                  .data.docs
                                                                  .map(
                                                                      (feedback) {
                                                                sumrating +=
                                                                    feedback[
                                                                        'rating'];
                                                                rating =
                                                                    sumrating /
                                                                        snapshot
                                                                            .data
                                                                            .size;
                                                                size = snapshot
                                                                    .data.size;
                                                                return Row();
                                                              }).toList(),
                                                            ),
                                                            Row(
                                                              children: [
                                                                RatingBarIndicator(
                                                                  rating:
                                                                      rating,
                                                                  itemBuilder:
                                                                      (context,
                                                                              index) =>
                                                                          Icon(
                                                                    Icons.star,
                                                                    color: Colors
                                                                        .amber,
                                                                  ),
                                                                  itemCount: 5,
                                                                  itemSize:
                                                                      20.0,
                                                                  unratedColor: Colors
                                                                      .amber
                                                                      .withAlpha(
                                                                          50),
                                                                  direction: Axis
                                                                      .horizontal,
                                                                ),
                                                                Spacer(),
                                                                snapshot.data
                                                                            .size ==
                                                                        null
                                                                    ? Text(
                                                                        '0'
                                                                            .tr()
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )
                                                                    : Text(
                                                                        '${snapshot.data.size} ' +
                                                                            'đánh giá'.tr().toString(),
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                              ],
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                      return Container();
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                    height: 30,
                                                    // color: Colors.red,
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.arrow_forward,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        setPolylines(
                                                            e.lat, e.long);
                                                      },
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                              }).toList()),
                            );
                          }
                          return Container();
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
