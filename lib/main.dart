import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/color_constants.dart';
import 'core/init/navigation/navigation_route.dart';
import 'core/init/navigation/navigation_service.dart';
import 'core/init/provider/provider_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import 'firebase_options.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

Future<void> main() async {
  if(!kIsWeb){
    timeDilation = 0.5;
  }
  WidgetsFlutterBinding.ensureInitialized();

  Provider.debugCheckInvalidValueType = null;

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // if (kIsWeb) {
  //   await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         apiKey: 'AIzaSyBwvjJ2ttyp8GWnhjVQqlrnbKyXcBHpd4Y',
  //         authDomain: 'baklava-firebase.firebaseapp.com',
  //         databaseURL: "", // **DATABASEURL MUST BE GIVEN.**
  //         projectId: 'baklava-firebase',
  //         storageBucket: 'baklava-firebase.appspot.com',
  //         messagingSenderId: '130016201952',
  //         appId: '1:130016201952:web:8dd90e871b7cb876aa1485'),
  //   );
  // } else {
  //   await Firebase.initializeApp();
  // }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings();

  //await LocaleManager.prefrencesInit();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [...ProviderManager.instance.singleProvider],
      child: ScreenUtilInit(
          minTextAdapt: false,
          builder: (context, child) => MaterialApp(
            navigatorObservers: [routeObserver],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: ColorConstants.instance.searchBarColor),
              primaryColor: ColorConstants.instance.searchBarColor,
                indicatorColor: ColorConstants.instance.searchBarColor,
                listTileTheme: ListTileThemeData(iconColor: ColorConstants.instance.searchBarColor),
                textSelectionTheme:  TextSelectionThemeData(
                    cursorColor:ColorConstants.instance.searchBarColor,
                ),
                useMaterial3: true,
              elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              ),),

            ),
            debugShowCheckedModeBanner: false,
            onGenerateRoute: NavigationRoute.instance.generateRoute,
            navigatorKey: NavigationService.instance.navigatorKey,
          ),
        ),
    );
  }
}
