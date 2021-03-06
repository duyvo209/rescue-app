import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescue/blocs/feedback/feedback_bloc.dart';
import 'package:rescue/blocs/login/login_bloc.dart';
import 'package:rescue/blocs/order/order_bloc.dart';
import 'package:rescue/blocs/reportStore/report_bloc.dart';
import 'package:rescue/blocs/request/request_bloc.dart';
import 'package:rescue/blocs/signup/signup_bloc.dart';
import 'package:rescue/blocs/signupStore/signupstore_bloc.dart';
import 'package:rescue/blocs/store/store_bloc.dart';
import 'package:rescue/screens/IntroScreen.dart';
import 'blocs/auth/authencation_bloc.dart';
import 'blocs/user/user_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    print(change);
    super.onChange(cubit, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(cubit, error, stackTrace);
  }
}

void main() async {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(
    EasyLocalization(
      child: MyApp(),
      path: 'assets/langs',
      saveLocale: true,
      supportedLocales: [
        Locale('vi', 'VN'),
        Locale('en', 'US'),
      ],
      fallbackLocale: Locale('vi', 'VN'),
    ),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = false;
  void initializeFlutterFire() async {
    setState(() {
      isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SignupBloc()),
          BlocProvider(create: (context) => LoginBloc()),
          BlocProvider(create: (context) => UserBloc()),
          BlocProvider(create: (context) => StoreBloc()),
          BlocProvider(create: (context) => SignupstoreBloc()),
          BlocProvider(create: (context) => RequestBloc()),
          BlocProvider(create: (context) => OrderBloc()),
          BlocProvider(create: (context) => FeedbackBloc()),
          BlocProvider(create: (context) => ReportBloc()),
          BlocProvider(
              create: (context) => AuthencationBloc(
                  loginBloc: BlocProvider.of<LoginBloc>(context),
                  userBloc: BlocProvider.of<UserBloc>(context),
                  storeBloc: BlocProvider.of<StoreBloc>(context))
                ..add(StartApp())),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: "poppins",
            scaffoldBackgroundColor: Colors.white,
            dividerColor: Colors.transparent,
          ),
          home: IntroScreen(),
        ),
      ),
    );
  }
}

// https://www.facebook.com/profile.php?id=100018138815119
