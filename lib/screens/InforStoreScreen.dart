import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescue/blocs/login/login_bloc.dart';
import 'package:rescue/blocs/request/request_bloc.dart';
import 'package:rescue/models/Store.dart';

class InforStoreScreen extends StatefulWidget {
  final Store store;
  final String storeId;
  InforStoreScreen({@required this.store, this.storeId});
  @override
  _InforStoreScreenState createState() => _InforStoreScreenState();
}

class _InforStoreScreenState extends State<InforStoreScreen> {
  var user;
  @override
  void initState() {
    user = BlocProvider.of<LoginBloc>(context).state.user;
    super.initState();
  }

  String valueChoose;
  List listProblem = [
    'Xe bị mất lửa',
    'Ổ khoá xe bị kẹt',
    'Bể hộp số',
    'Xe bị nóng máy',
    'Xe bị chết máy',
    'Xe bị rung lắc',
    'Xe bị ngập nước',
    'Xe bị rồ ga',
    'Xe bị cháy cầu chì',
    'Xe bị rỉ nhớt',
    'Xe bị sặc xăng',
    'Xe bị thủng bô',
    'Xe bị trượt đề'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('dvRescue'),
          backgroundColor: Colors.blueGrey[800],
          brightness: Brightness.light,
          elevation: 0,
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: ListView(
          padding: EdgeInsets.all(0),
          children: [
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    child: Hero(
                      tag: widget.store.name,
                      child: AspectRatio(
                        aspectRatio: 1 / 0.667,
                        child: Image.asset(
                          'assets/2.jpeg',
                        ),
                        // child: CachedNetworkImage(
                        //   imageUrl:
                        //       "https://drive.google.com/thumbnail?id=${widget.product.picture[i]}&sz=w500-h500",
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 0,
              ),
              child: Text(
                "${widget.store.name}",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 0,
              ),
              child: Text(
                "${widget.store.address}",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 0,
              ),
              child: Text(
                "Cách bạn ${widget.store.getM(10.02545, 105.77621).toString().substring(0, 5)} km",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 0,
              ),
              child: Text(
                "${widget.store.phone}",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 0,
              ),
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blueGrey[800],
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(15)),
                child: DropdownButton(
                  hint: Text('Vấn đề của bạn là gì ?'),
                  underline: SizedBox(),
                  isExpanded: true,
                  value: valueChoose,
                  onChanged: (value) {
                    setState(() {
                      valueChoose = value;
                    });
                  },
                  items: listProblem.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 55,
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
                    width: 20,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        BlocProvider.of<RequestBloc>(context).add(
                          AddToRequest(
                            userId: FirebaseAuth.instance.currentUser.uid,
                            storeName: widget.store.name,
                            problem: valueChoose,
                          ),
                        );

                        // AddToRequest();
                        // BlocProvider.of<RequestBloc>(context).add(AddToRequest(
                        //   userId: FirebaseAuth.instance.currentUser.uid,
                        //   store: widget.store,
                        // ));
                      },
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            color: Colors.blueGrey[800]),
                        child: Center(
                          child: Text(
                            'Gửi Yêu Cầu',
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
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ));
  }
}
//         body: Material(
//           child: CustomScrollView(
//             slivers: [
//               SliverPersistentHeader(
//                 delegate: MySliverAppBar(expandedHeight: 200),
//                 pinned: true,
//               ),
//               SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                   (_, index) => ListTile(
//                     title: Text("Index: $index"),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ));
//   }
// }

// class MySliverAppBar extends SliverPersistentHeaderDelegate {
//   final double expandedHeight;

//   MySliverAppBar({@required this.expandedHeight});

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Stack(
//       fit: StackFit.expand,
//       overflow: Overflow.visible,
//       children: [
//         Image.network(
//           "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//           fit: BoxFit.cover,
//         ),
//         Center(
//           child: Opacity(
//             opacity: shrinkOffset / expandedHeight,
//             child: Text(
//               "MySliverAppBar",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 23,
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           top: expandedHeight / 2 - shrinkOffset,
//           left: MediaQuery.of(context).size.width / 4,
//           child: Opacity(
//             opacity: (1 - shrinkOffset / expandedHeight),
//             child: Card(
//               elevation: 10,
//               child: SizedBox(
//                   height: expandedHeight,
//                   width: MediaQuery.of(context).size.width / 2,
//                   child: Container(
//                     child: Column(
//                       children: <Widget>[
//                         Text('${}')
//                       ],
//                     ),
//                   )

//                   ),
//                   ),
//             ),
//           ),

//       ],
//     );
//   }

//   @override
//   double get maxExtent => expandedHeight;

//   @override
//   double get minExtent => kToolbarHeight;

//   @override
//   bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
// }
