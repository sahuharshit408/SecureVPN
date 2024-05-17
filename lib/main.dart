import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:vpn_basic_project/helpers/ad_helper.dart';
import 'package:vpn_basic_project/helpers/config.dart';
import 'package:vpn_basic_project/screens/splash_screen.dart';
import 'helpers/pref.dart';
import 'package:get/get.dart';
import 'screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';

late Size mq;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  await Firebase.initializeApp();

  await Config.initConfig();

  await Pref.initializeHive();

  await AdHelper.initAds();

  AdHelper.precacheInterstitialAd();
  AdHelper.precacheNativeAd();

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp , DeviceOrientation.portraitDown]
  ).then((v) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Secure VPN',
      home: SplashScreen(),

      theme :
          ThemeData(
              appBarTheme: AppBarTheme(
                centerTitle: true ,
                elevation: 3 ,
                //color: Theme.of(context).bottomNav,
                  backgroundColor: Theme.of(context).bottomNav,
              ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Theme.of(context).bottomNav, // Set bottom nav background color to bottomNav color
            ),
          ),

      themeMode: Pref.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      darkTheme :
      ThemeData(
          scaffoldBackgroundColor: Colors.black,
        brightness: Brightness.dark,
          appBarTheme: AppBarTheme(
            centerTitle: true ,
            elevation: 3 ,
            //color: Theme.of(context).bottomNav,
              backgroundColor: Theme.of(context).bottomNav,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Theme.of(context).bottomNav, // Set bottom nav background color to bottomNav color
       ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

extension AppTheme on ThemeData {
  Color get lightText => Pref.isDarkMode ? Colors.white70 : Colors.black54;
  Color get bottomNav => Pref.isDarkMode ? Colors.white10 : Colors.blue;
}
