import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MedicineReminder.dart';
import 'navbar.dart';
import 'Database.dart';
//import 'package:medi_mate/Notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
//import 'SMS_Peer.dart';
//import 'package:telephony/telephony.dart';



class ProfilePage extends StatefulWidget {
  String userName;
  String userPhone;
  ProfilePage({Key key, @required this.userName, @required this.userPhone}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState(userName: userName,userPhone: userPhone);
}

class _ProfileState extends State<ProfilePage> {
  String userName;
  String userPhone;
  _ProfileState({Key key, @required this.userName, @required this.userPhone});
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            title: Image.asset("assets/logo_text.png",width:200,height:100),
            centerTitle: true,
          )),
      drawer: NavDrawer(userName: userName,userPhone: userPhone,),
      body: SingleChildScrollView (child : ProfileForm(userName: userName,userPhone: userPhone,),),
    );
  }
}
class ProfileForm extends StatefulWidget {
  String userName;
  String userPhone;
  ProfileForm({Key key, @required this.userName, @required this.userPhone}) : super(key: key);
  @override
  _ProfileFormState createState() => _ProfileFormState(userPhone: userPhone,userName: userName);
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();

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
class _ProfileFormState extends State<ProfileForm> {
  String userName;
  String userPhone;
  _ProfileFormState({Key key, @required this.userName, @required this.userPhone});
  Database d = new Database();
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay breakfastTime = TimeOfDay(hour: 10,minute: 30);
  TimeOfDay lunchTime = TimeOfDay(hour: 12,minute: 30);
  TimeOfDay dinnerTime = TimeOfDay(hour: 20,minute: 30);
  //Notifi n = new Notifi();
  //final telephony = Telephony.instance;
  String Gender="Male";
  TextEditingController _nameController;
  TextEditingController _numberController;
  static List<String> friendsList = [null];
  static List<String> NumbersList = [null];
  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _requestPermissions();
    _configureSelectNotificationSubject();
    _configureDidReceiveLocalNotificationSubject();
  }

  Future<void> scheduleDailyTenAMNotification(int hr,int min,int sec,int id) async {
    print("inside noti");
    String checktime;
    switch(id) {
      case 0:checktime = "morning";
        break;
      case 1:checktime = "afternoon";
        break;
      case 2:checktime = "evening";
        break;
  }
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'Medicine Reminder',
        'It\'s time to take your '+checktime+' medicine',
        _nextInstanceOfTenAM(hr,min,sec),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'daily notification channel id',
              'daily notification channel name',
              'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload:'Reminder',);

  }
  tz.TZDateTime _nextInstanceOfTenAM(int hr , int min ,int sec) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, hr,min,sec);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
  void _configureSelectNotificationSubject() {
    print("outside Payload");
    selectNotificationSubject.stream.listen((String payload) async {
      print("Inside payload");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicineReminder(userPhone: userPhone,userName: userName,),
          ));
    });
  }
  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        MedicineReminder(userPhone: userPhone,userName: userName,),
                  ),
                );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }
  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.person),
            title :TextFormField(
              decoration: InputDecoration(
                hintText: userName,
              ),
              validator: (value){
                if (value.isEmpty){
                  return null;
                  //return 'Please enter your Name';
                }
                userName = value;
                return null;
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title :TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: userPhone.substring(3),
              ),
              validator: (value){
                if(value.isEmpty){
                  return null;
                }
                else if (value!=userPhone.substring(3)){
                  return "Please enter the registered Mobile Number";
                  //return 'Please enter your Phone Number';
                }
                userPhone = "+91"+value;
                return null;
              },
            ),
          ),
          Padding(padding: const EdgeInsets.only(left: 20.0,top:10),
          child :Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: <Widget>[
            Text(
              'Gender:',
              style: new TextStyle(fontSize: 16.0),
            ),
            Row(
              children: <Widget>[
                Radio(

                    value: "Male",
                    groupValue: Gender,
                    onChanged:(value){setState(() {
                      Gender=value;
                    });}),
                Text(
                  "Male",
                  style: new TextStyle(                    fontSize: 14.0,                  ),
                ),
                Radio(
                    value: "Female",
                    groupValue: Gender,
                    onChanged: (value){setState(() {
                      Gender=value;
                    });}),
                Text(
                  "Female",
                  style: new TextStyle(                    fontSize: 14.0,                  ),
                ),
              ],
            )
          ])),
          ListTile(
            leading: const Icon(Icons.today),
            title : Text("Birthday"),
            subtitle: Text("${selectedDate.toLocal()}".split(' ')[0]),
            onTap: () => _selectDate(context),
          ),
          ListTile(
            leading: const Icon(Icons.watch_later_outlined),
            title : Text("Breakfast Time"),
            subtitle: Text("${breakfastTime.hour}:${breakfastTime.minute}"),
            onTap: () => _breakfastTime(context),
          ),
          ListTile(
            leading: const Icon(Icons.watch_later_outlined),
            title : Text("Lunch Time"),
            subtitle: Text("${lunchTime.hour}:${lunchTime.minute}"),
            onTap: () => _lunchTime(context),
          ),
          ListTile(
            leading: const Icon(Icons.watch_later_outlined),
            title : Text("Dinner Time"),
            subtitle: Text("${dinnerTime.hour}:${dinnerTime.minute}"),
            onTap: () => _dinnerTime(context),
          ),
          RaisedButton(
            color:const Color(0xFFFFC7C7),
            child : Row(
                children:[
                  Flexible(
                    flex: 1,
                    child: const Icon(Icons.person_add),
                  ),
                  Flexible(
                    flex: 8,
                    child:Center(child:Text("Add Peer")),
                  ),
                ]
            ),
            onPressed: () async {
              friendsList.insert(0, null);
              NumbersList.insert(0, null);
              setState((){});
            },
          ),
          SizedBox(height: 20,),
          ..._getFriends(),
          SizedBox(height: 40,),
          /*RaisedButton(
            color:const Color(0xFFFFC7C7),
            child: Text("Change Language"),
            onPressed:(){
              showDialog(
                context: context,
                builder: (BuildContext context) => _buildAboutDialog(context),
              );
            } ,
          ),*/
          ElevatedButton(
            onPressed: (){
              if(_formKey.currentState.validate()) {
                d.saveProfile(userPhone, userName,(selectedDate).toString().substring(0,10) ,Gender, (breakfastTime).format(context), (lunchTime).format(context), (dinnerTime).format(context), friendsList, NumbersList);
                scheduleDailyTenAMNotification(breakfastTime.hour,breakfastTime.minute,00,0);
                scheduleDailyTenAMNotification(lunchTime.hour,lunchTime.minute,00,1);
                scheduleDailyTenAMNotification(dinnerTime.hour,dinnerTime.minute,00,2);
                Scaffold.of(context).showSnackBar(SnackBar(content: Text('Saving Data'),));
              }
            },
            child: Text('Save'),
          )
        ],
      ),
    );
  }
  List<Widget> _getFriends(){
    List<Widget> friendsTextFields = [];
    List<Widget> friendsNumberFields = [];
    List<Widget> combinedFields = [];
    for(int i=0; i<friendsList.length; i++){
      friendsTextFields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                Expanded(child: FriendTextFields(i)),
                SizedBox(width: 16,),
                // we need add button at last friends row
                _addRemoveButton(false, i),
              ],
            ),
          )
      );
      friendsNumberFields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                Expanded(child: FriendNumberFields(i)),
                SizedBox(width: 16,),
              ],
            ),
          )
      );
      combinedFields.add(friendsTextFields[i]);
      combinedFields.add(friendsNumberFields[i]);
    }
    return combinedFields;
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index){
    return InkWell(
      onTap: (){
        if(add){
          // add new text-fields at the top of all friends textfields
          friendsList.insert(0, null);
          NumbersList.insert(0, null);
        }
        else {
          friendsList.removeAt(index);
          NumbersList.removeAt(index);
        }
          setState((){});
      },
      child: Container(
        width: 50,
        height: 50,
        child: Icon((add) ? Icons.add : Icons.remove_circle, color: Colors.red,size: 40,),
      ),
    );
  }
  _selectDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1920),
      lastDate: DateTime(2022),
      helpText: 'Select Birthday',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
  _breakfastTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: breakfastTime,
    );
    if (picked != null && picked != breakfastTime)
      setState(() {
        breakfastTime = picked;
      });
  }
  _lunchTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: lunchTime,
    );
    if (picked != null && picked != lunchTime)
      setState(() {
        lunchTime = picked;
      });
  }
  _dinnerTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: dinnerTime,
    );
    if (picked != null && picked != dinnerTime)
      setState(() {
        dinnerTime = picked;
      });
  }
  Widget _buildAboutDialog(BuildContext context){
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:<Widget> [
          ListTile(
            title : Text("English"),
            //onTap: () => (context),
          ),
          ListTile(
            title : Text("हिंदी"),
            //onTap: () => (context),
          ),
        ],
      ),
    );
  }
}

class FriendTextFields extends StatefulWidget {
  final int index;
  FriendTextFields(this.index);
  @override
  _FriendTextFieldsState createState() => _FriendTextFieldsState();
}

class _FriendTextFieldsState extends State<FriendTextFields> {
  TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text = _ProfileFormState.friendsList[widget.index] ?? '';
    });

    return Container(
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child:TextFormField(
      controller: _nameController,
      onChanged: (v) => _ProfileFormState.friendsList[widget.index] = v,
      decoration: InputDecoration(
          hintText: 'Enter peer\'s name'
      ),
      validator: (v){
        if(v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    )
    )
    );
  }
}

class FriendNumberFields extends StatefulWidget {
  final int index;
  FriendNumberFields(this.index);
  @override
  _FriendNumbersFieldsState createState() => _FriendNumbersFieldsState();
}

class _FriendNumbersFieldsState extends State<FriendNumberFields> {
  TextEditingController _numberController;

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController();
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _numberController.text = _ProfileFormState.NumbersList[widget.index] ?? '';
    });

    return Container(
        child: Padding(
        padding: const EdgeInsets.only(left: 16.0,right: 66.0),
          child:TextFormField(
      controller: _numberController,
      onChanged: (v) => _ProfileFormState.NumbersList[widget.index] = v,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Enter peer\'s number'
      ),
      validator: (v){
        if(v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    )
    )
    );
  }
}