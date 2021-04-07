import 'dart:async';
import 'package:flutter/material.dart';
import 'package:medi_mate/Database.dart';
import 'package:medi_mate/Prescription_image.dart';
import 'package:medi_mate/dashboard.dart';
import 'signup.dart';
import 'select_language.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'MedicineReminder.dart';
import 'Prescription_manual.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:medi_mate/Notification.dart';

//import 'NotiTry.dart';
//import 'Notification.dart';
Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};



final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();

const MethodChannel platform =
MethodChannel('dexterx.dev/flutter_local_notifications_example');



class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

String selectedNotificationPayload;
GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
/// IMPORTANT: running the following code on its own won't work as there is
/// setup required for each platform head project.
///
/// Please download the complete example app from the GitHub repository where
/// all the setup has been done
Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  /*WidgetsFlutterBinding.ensureInitialized();
  await _configureLocalTimeZone();

  //String initialRoute = HomePage.routeName;

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings();
  const MacOSInitializationSettings initializationSettingsMacOS =
  MacOSInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload == "Reminder") {
          debugPrint('notification payload: $payload');
        }
        selectedNotificationPayload = payload;
        selectNotificationSubject.add(payload);
      });*/

  runApp(
      MyApp()
  );
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await platform.invokeMethod('getTimeZoneName');
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}



// ignore: non_constant_identifier_names

MaterialColor final_color = MaterialColor(0xFFE2E2, color);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'My MediMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: const Color(0xFFFFE2E2),
        //primaryColor: Colors.yellow,
        accentColor: const Color(0xFFFAC7C7),
        //primarySwatch: Colors.pink,
      ),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: SplashPage(),
      //home : HomePage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}
final FirebaseAuth _auth = FirebaseAuth.instance;
class _SplashPageState extends State<SplashPage> {
  Database d = new Database();
  var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  String userPhone;
  String userName;
  initializeNotifications() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _configureLocalTimeZone();

    //String initialRoute = HomePage.routeName;

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings();
    const MacOSInitializationSettings initializationSettingsMacOS =
    MacOSInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: onSelectNotification);
    final NotificationAppLaunchDetails notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      print("new stuff");
      if(notificationAppLaunchDetails.payload=='Reminder') {
        print("go to page");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>
                MedicineReminder(userPhone: userPhone,userName: userName,)));
      }
      //selectedNotificationPayload = notificationAppLaunchDetails!.payload;
      //initialRoute = SecondPage.routeName;
    }
  }

  Future onSelectNotification(String payload) async {
    print('Notification clicked');
    //print(payload);
    if(payload=='Reminder') {
      print("go to page");
      await navigatorKey.currentState.push(MaterialPageRoute(builder: (context) =>
              MedicineReminder(userPhone: userPhone,userName: userName,)));
    }
    //return Future.value(0);
  }

  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
            () {
          getUser().then((user) async {
            if(user != null){
              userPhone =user.phoneNumber.toString();
              userName = await  d.getUser(user.phoneNumber.toString());
              //print(user.phoneNumber.toString());
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Dashboard(userPhone:user.phoneNumber.toString(),userName: userName.toString(),)));
            }
            else
            {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  SignUp()), (Route<dynamic> route) => false);
              //Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SelectLanguagePage()));
              //Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>Prescription_Manual(userName: "Sameeksha",userPhone: "+919833515264",)));
              //Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>MedicineReminder(userPhone: "+919833515264",)));
            }
          });
        });
    initializeNotifications();
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: const Color(0xFFFFE2E2),
      child: Column(children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 70.0, right: 20.0),
              child: Image.asset('assets/logo_text.png',
              width: MediaQuery.of(context).size.width-40,),
            ),
            /*Text("My MediMate",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                )),
                */
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 20.0, top: 80.0, right: 20.0),
          child:Row(
            children: [
              Image.asset(
                'assets/splash_screen_img.png',
                width: MediaQuery.of(context).size.width-40,
                height: 300.0,
                fit: BoxFit.fill,
              ),
            ],
          ),),
        Padding(
          padding: const EdgeInsets.only(
              left: 1.0, top: 50.0, right: 8.0, bottom: 50.0),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 10.0, right: 8.0, bottom: 50.0),
            ),
            Image.asset(
              'assets/hand_with_pill.png',
              color: const Color(0xFFFFE2E2),
              colorBlendMode: BlendMode.softLight,
            ),
          ],
        ),
      ]),
    );
  }
}

//class SignUpPage extends
/*
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('My mediMate'),
      ),
      body: Center(
        child: Text(''),
      ),
    );
  }
}

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          //Image.asset('assets/cover.png'),
          DrawerHeader(
            child: Text(
              'Sameeksha',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.brown,
                image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: AssetImage('assets/cover.png'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Upload Prescription'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Prescription Logs'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Medical Logs'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Upload bill'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('Chat'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
*/