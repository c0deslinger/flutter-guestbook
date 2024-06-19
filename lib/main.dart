import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:guestbook/controller/guest_controller.dart';
import 'package:guestbook/view/main_tab_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyD-5fK_0pFC5vFF-cZvrsDuLWMSZVH68ds",
          appId: "1:367354658089:android:553ff109bbfde637748b38",
          messagingSenderId: "",
          storageBucket: "guestbook-app-21354.appspot.com",
          databaseURL:
              "https://guestbook-app-21354-default-rtdb.asia-southeast1.firebasedatabase.app",
          projectId: "guestbook-app-21354"));
  FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GuestController controller = Get.put(GuestController());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Guest Book',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF007AFF),
        // accentColor: Color(0xFFFF2D55),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        textTheme: const TextTheme(),
        // textTheme: TextTheme(
        //   headline1: TextStyle(
        //       color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        //   bodyText1: TextStyle(color: Colors.black, fontSize: 16),
        //   bodyText2: TextStyle(color: Colors.grey, fontSize: 14),
        // ),
        // inputDecorationTheme: InputDecorationTheme(
        //   filled: true,
        //   fillColor: Colors.white,
        //   border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(8),
        //     borderSide: BorderSide.none,
        //   ),
        //   contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        // ),
        // elevatedButtonTheme: ElevatedButtonThemeData(
        //   style: ElevatedButton.styleFrom(
        //     // primary: Color(0xFF007AFF),
        //     // onPrimary: Colors.white,
        //     padding: EdgeInsets.symmetric(vertical: 16),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(8),
        //     ),
        //     textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        //   ),
        // ),
      ),
      home: const MainTabView(),
    );
  }
}
