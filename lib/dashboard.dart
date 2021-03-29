import 'dart:io';
import 'dart:math';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:medi_mate/Chatbot.dart';
import 'package:medi_mate/Database.dart';
import 'prescription_logs.dart';
import 'Prescription.dart';
import 'MedicineBill.dart';
import 'Profile.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped }

class Dashboard extends StatefulWidget {
  String userPhone;
  String userName;
  Dashboard({Key key, @required this.userPhone,this.userName}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState(userPhone: userPhone,userName: userName);
}

class _DashboardState extends State<Dashboard> {
  String userPhone;
  String userName;
  _DashboardState({Key key, @required this.userPhone,this.userName});
  Database d = new Database();
  var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  FlutterTts flutterTts;
  dynamic languages;
  String language;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 1.0;

  String _newVoiceText;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;



  initTts() {
    flutterTts = FlutterTts();

    _getLanguages();

    flutterTts.setStartHandler(() {
      setState(() {
        print("playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    print("pritty print ${languages}");
    if (languages != null) setState(() => languages);
  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        var result = await flutterTts.speak(_newVoiceText);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  void AlarmManager() async{
    WidgetsFlutterBinding.ensureInitialized();
    await AndroidAlarmManager.initialize();
    String formattedDate = DateFormat('kk:mm:ss').format(DateTime.now());
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var l2 = DateTime.parse('$date 17:02:00');
    var l2p = DateTime.parse('$date 17:03:00');
    AndroidAlarmManager.oneShotAt(l2p, Random().nextInt(9999999), start);
    AndroidAlarmManager.oneShotAt(l2, Random().nextInt(9999999), stop);
    var l3 = DateTime.parse('$date 15:52:00');
    var l3p = DateTime.parse('$date 15:51:00');
    //AndroidAlarmManager.oneShotAt(l3p, Random().nextInt(9999999), start);
    //AndroidAlarmManager.oneShotAt(l3, Random().nextInt(9999999), stop);
  }
  @override
  void initState(){
    AlarmManager();
    initTts();
    flutterTts.setLanguage("hi-IN");
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
  start () async{
    var scheduledNotificationDateTime = new DateTime.now().add(new Duration(seconds: 2));
    print(scheduledNotificationDateTime);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails('your other channel id','your other channel name', 'your other channel description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
    print("start");
  }

  stop() {
    print("stop");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          /*dashBg*/
          Column(
            children: <Widget>[
              Expanded(
                child: Container(color: const Color(0xFFFFE2E2)),
                flex: 2,
              ),
              Expanded(
                child: Container(color: Colors.transparent),
                flex: 7,
              ),
            ],
          ),

          /*   content  */
          Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.only(left: 30, right: 20, top: 50),
                  title: 
                  Image.asset('assets/womanavatar.png',width:100,height:60),
                       
                  subtitle:
                  Text(
                    ''+userName.toString(),
                    style: TextStyle(
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0),
                    textAlign: TextAlign.center,
                  ),   
                ),

                /* -------------------------*/
                /* grid*/
                Padding(
                  padding : EdgeInsets.only( bottom: 30),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: GridView.count(
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 12, right: 12, bottom: 16),
                          child: Card(
                            color: const Color(0xFFFAC7C7),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PrescriptionPage(userName: userName,userPhone: userPhone),
                                    ));
                              },
                              onLongPress: (){
                                _newVoiceText="Prescription Page";
                                _speak();
                              },
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/Hospital 3.png',
                                      height: 100.0,
                                      width: 100.0,
                                    ),
                                    Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text('Input Prescription')),
                                    /*Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text('Image')),*/
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 12, right: 12, bottom: 16),
                          child: Card(
                            color: const Color(0xFFFAC7C7),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MedicineBillPage(userName: userName,userPhone: userPhone,),
                                    ));
                              },
                              onLongPress: (){
                                _newVoiceText="Medicine Bill Page";
                                _speak();
                              },
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/pill.png',
                                      height: 100.0,
                                      width: 100.0,
                                    ),
                                    Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text('Input Medical Bill')),
                                    /*Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text('Image')),*/
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 12, right: 12, bottom: 16),
                          child: Card(
                            color: const Color(0xFFFAC7C7),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Prescription_Logs(userName: userName,userPhone: userPhone,),
                                    ));
                              },
                              onLongPress: (){
                                _newVoiceText="Prescription Log Page";
                                _speak();
                              },
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/Pulse.png',
                                      height: 100.0,
                                      width: 100.0,
                                    ),
                                    Text('Prescription Log')
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 12, right: 12, bottom: 16),
                          child: Card(
                            color: const Color(0xFFFAC7C7),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Prescription_Logs(userName: userName,userPhone: userPhone,),
                                    ));
                              },
                              onLongPress: (){
                                _newVoiceText="Medicine Log Page";
                                _speak();
                              },
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/Report Card.png',
                                      height: 100.0,
                                      width: 100.0,
                                    ),
                                    Text('Medical Log')
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 12, right: 12, bottom: 16),
                          child: Card(
                            color: const Color(0xFFFAC7C7),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfilePage(userName: userName,userPhone: userPhone,),
                                    ));
                              },
                              onLongPress: (){
                                _newVoiceText="Profile Page";
                                _speak();
                              },
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/Stethoscope.png',
                                      height: 100.0,
                                      width: 100.0,
                                    ),
                                    Text('Profile')
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 12, right: 12, bottom: 16),
                          child: Card(
                            color: const Color(0xFFFAC7C7),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Chatbot(),
                                    ));
                              },
                              onLongPress: (){
                                _newVoiceText="ChatBot Page";
                                _speak();
                              },
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/Medical Doctor.png',
                                      height: 100.0,
                                      width: 100.0,
                                    ),
                                    Text('Chat')
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /*   */
        ],
      ),
    );
  }
}
