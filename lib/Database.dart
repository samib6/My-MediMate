//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:flutter/material.dart';
//import 'package:medi_mate/signup.dart';

class Database {

  final databaseReference = FirebaseDatabase.instance.reference();
  static int countid=0;
  Future <void> saveUser(String UserName , String PhoneNumber) {
    var id = databaseReference.child(PhoneNumber).child("Profile").set({
      'Name': UserName,
    });
  }

  Future <void> savePrescription(String PhoneNumber,String DiseaseName,String MedicineName,bool Breakfast,bool Lunch, bool Dinner, String Date,int Days) {
    //print("in Database");
    //print(PhoneNumber);
    //print(Date);
    //print(DiseaseName);
    //print(MedicineName);
    int c =0;
    if(Breakfast)
      c++;
    if(Lunch)
      c++;
    if(Dinner)
      c++;
    int total = c*Days;
    try {
      var id = databaseReference.child(PhoneNumber).child("Prescription").child(
          Date).child(DiseaseName).child(MedicineName).set({
        'Breakfast': Breakfast,
        'Lunch': Lunch,
        'Dinner': Dinner,
        'Total' : total,
        'Days': Days
      });
    }
    catch(e){
      print(e);
    }
  }
  Future <void> saveMedicine(String PhoneNumber,String MedicineName,int Quantity) async{
    //print("in Database");
    //print(PhoneNumber);
    //print(MedicineName);
    int Temp = await getQuantity(PhoneNumber, MedicineName);
    Quantity+=Temp;
    try {
      var id = databaseReference.child(PhoneNumber).child("Medicine").child(MedicineName).set({
        'Quantity': Quantity,
      }).catchError((onError) {
        print(onError);
      });
    }
    catch(e){
      print(e);
    }
  }
  
  Future <void> saveProfile(String PhoneNumber, String UserName, String Birthdate, String BreakfastTime, String LunchTime, String DinnerTime, List<String> PeerName, List<String> PeerNumber)
  {
    try{
      var id = databaseReference.child(PhoneNumber).child("Profile").set({
        'Name': UserName,
        'Birthdate': Birthdate,
        'BreakfastTime': BreakfastTime,
        'LunchTime': LunchTime,
        'DinnerTime': DinnerTime,
      });
      for(int i = PeerName.length-1;i>=0;i--)
      {
          var id2 = databaseReference.child(PhoneNumber).child("Profile").child("Peer").child(i.toString()).set({
            'PeerName': PeerName[i],
            'PeerNumber': "+91"+PeerNumber[i]
          });
      }
    }
    catch(e){
      print(e);
    }
  }

  Future <int> getQuantity(String PhoneNumber,String MedicineName) async{
    int Quantity;
    try {
      await databaseReference.child(PhoneNumber).child("Medicine").child(
          MedicineName).once().then((DataSnapshot data) {
        //print(data.value['UserName']);
        Quantity = data.value['Quantity'];
      });
    }
    catch(e) {
      Quantity = 0;
    }
    return Quantity;
  }

  Future <String> getUser(String PhoneNumber) async{
    String userName;

    await databaseReference.child(PhoneNumber).child("Profile").once().then((DataSnapshot data) {
      //print(data);
      userName = data.value['Name'];
    });
    return userName;
  }
  Future <DataSnapshot> getProfile(String PhoneNumber) async{
    DataSnapshot dataList;
    await databaseReference.child(PhoneNumber).child("Profile").once().then((DataSnapshot data) {
      //print(data);
      dataList = data;
    });
    return dataList;
  }
  Future <List<String>> getMedicine(String PhoneNumber,String Time) async{
    List<String> MedicineName = [];
    List<String> DateValue = [];
    try {
      await databaseReference.child(PhoneNumber).child("Prescription").once().then((DataSnapshot data) {
        //print(data.value);
        data.value.forEach((key,value){DateValue.insert(0,key);});
      });
      for(int i =0;i<DateValue.length;i++)
      {
        List<String> temp = [];
        await databaseReference.child(PhoneNumber).child("Prescription").child(DateValue[i]).once().then((DataSnapshot data) {
          data.value.forEach((key,value){temp.insert(0,key);});
        });
        for(int j = 0;j<temp.length;j++)
          {
            await databaseReference.child(PhoneNumber).child("Prescription").child(DateValue[i]).child(temp[j]).once().then((DataSnapshot data) {
              data.value.forEach((key,value){
                if(value[Time])
                  {
                    MedicineName.insert(0, DateValue[i]);
                    MedicineName.insert(1, temp[j]);
                    MedicineName.insert(2, key);
                  }
              });
            });
          }
      }
    }
    catch(e) {
      print(e);
    }
    print(MedicineName);
    return MedicineName;
  }

  void updateMedicine(String PhoneNumber,String Date,String DiseaseName,String MedicineName) async{
    int total;
    DataSnapshot temp;
    try {
      await databaseReference.child(PhoneNumber).child("Prescription").child(Date).child(DiseaseName).child(MedicineName).once().then((DataSnapshot data) {
        //print(data.value);
        total = (data.value['Total']);
        temp=data;
      });
      total--;
      if(total == 0)
        {
          var id = databaseReference.child(PhoneNumber).child("Archive")
              .child(Date).child(DiseaseName).child(MedicineName).set({
            'Breakfast': temp.value['Breakfast'],
            'Lunch': temp.value['Lunch'],
            'Dinner': temp.value['Dinner'],
            'Total' : 0,
            'Days': temp.value['Days']
          });
          databaseReference.child(PhoneNumber).child("Prescription").child(Date).child(DiseaseName).child(MedicineName).remove();
        }
      else {
        var id = databaseReference.child(PhoneNumber).child("Prescription")
            .child(Date).child(DiseaseName).child(MedicineName)
            .set({
          'Breakfast': temp.value['Breakfast'],
          'Lunch': temp.value['Lunch'],
          'Dinner': temp.value['Dinner'],
          'Total' : total,
          'Days': temp.value['Days']
        });
      }
    }
    catch(e){
      print(e);
    }
  }
  void updateMedicineQuantity(String PhoneNumber,String MedicineName) async{
    int total;

    try {
      await databaseReference.child(PhoneNumber).child("Medicine").child(MedicineName).once().then((
          DataSnapshot data) {
        //print(data.value);
        total = (data.value['Quantity']);
      });
      if(total>0)
        {
          total--;
        }
      if(total<5)
      {
        var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
        var scheduledNotificationDateTime = new DateTime.now().add(new Duration(seconds: 2));
        print(scheduledNotificationDateTime);
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails('your other channel id','your other channel name', 'your other channel description');
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.schedule(
            3+countid,
            MedicineName,
            'Please Refill this medicine',
            scheduledNotificationDateTime,
            platformChannelSpecifics);
        countid++;
        if(countid>15)
          countid=0;
      }
      await databaseReference.child(PhoneNumber).child("Medicine").child(MedicineName).set({
        'Quantity':total,
      });
    }
    catch(e){
      print(e);
    }
  }

  Future <List<String>> getMedicineLogs(String PhoneNumber) async {
    List<String> DeseasesName = [];
    List<String> DateValue = [];
    try {
      await databaseReference.child(PhoneNumber).child("Prescription").once().then((DataSnapshot data) {
        //print(data.value);
        data.value.forEach((key, value) {
          DateValue.insert(0, key);
        });
      });
      for (int i = 0; i < DateValue.length; i++) {
        await databaseReference.child(PhoneNumber).child("Prescription").child(DateValue[i]).once().then((DataSnapshot data) {
          data.value.forEach((key, value) {
            DeseasesName.insert(0, DateValue[i]);
            DeseasesName.insert(1, key);
            DeseasesName.insert(2, "Prescription");
          });
        });
      }
      DateValue = [];
      await databaseReference.child(PhoneNumber).child("Archive").once().then((DataSnapshot data) {
        //print(data.value);
        data.value.forEach((key, value) {
          DateValue.insert(0, key);
        });
      });
      for (int i = 0; i < DateValue.length; i++) {
        await databaseReference.child(PhoneNumber).child("Archive").child(DateValue[i]).once().then((DataSnapshot data) {
          data.value.forEach((key, value) {
            DeseasesName.insert(0, DateValue[i]);
            DeseasesName.insert(1, key);
            DeseasesName.insert(2, "Archive");
          });
        });
      }
    }
    catch (e) {
      print(e);
    }
    var temp;
    for(int i =0;i<DeseasesName.length;i+=3)
      {
        for(int j =i+3;j<DeseasesName.length-3;j+=3)
          {
            if(checkDate(DeseasesName[i],DeseasesName[j]))
              {
                temp = DeseasesName[i];
                DeseasesName[i] = DeseasesName[j];
                DeseasesName[j]=temp;
                temp = DeseasesName[i+1];
                DeseasesName[i+1] = DeseasesName[j+1];
                DeseasesName[j+1]=temp;
                temp = DeseasesName[i+2];
                DeseasesName[i+2] = DeseasesName[j+2];
                DeseasesName[j+2]=temp;
              }
          }
      }
    print(DeseasesName);
    return DeseasesName;
  }
  bool checkDate(String Date1, String Date2)
  {
    Date1=Date1.replaceAll("-", "");
    Date2=Date2.replaceAll("-", "");
    if(int.parse(Date1)<int.parse(Date2))
      {
        return true;
      }
    return false;
  }
  Future <List<String>> getMedicineLogsinfo(String PhoneNumber,String type,String Date,String Deseases) async {
    List<String> DeseasesName = [];
    List<String> MedicineName = [];
    print(type);
    try{
      await databaseReference.child(PhoneNumber).child(type).child(Date).child(Deseases).once().then((DataSnapshot data) {
        data.value.forEach((key, value) {
          MedicineName.insert(0, key);
        });
      });
      for(int i=0;i<MedicineName.length;i++)
        {
          await databaseReference.child(PhoneNumber).child(type).child(Date).child(Deseases).child(MedicineName[i]).once().then((DataSnapshot data) {
            DeseasesName.insert(0, MedicineName[i]);
            DeseasesName.insert(1, data.value["Breakfast"].toString());
            DeseasesName.insert(2, data.value["Lunch"].toString());
            DeseasesName.insert(3, data.value["Dinner"].toString());
          });
        }
    }
    catch(e){
      print(e);
    }
    print(DeseasesName);
    return DeseasesName;
  }
  Future <List<String>> getMedicineQuantity(String PhoneNumber) async {
    List<String> MedicineName = [];
    List<String> TempKey = [];
    try {
      await databaseReference.child(PhoneNumber).child("Medicine").once().then((DataSnapshot data) {
        //print(data.value);
        data.value.forEach((key, value) {
          TempKey.insert(0, key);
        });
      });
      for(int i =0;i<TempKey.length;i++)
        {
          await databaseReference.child(PhoneNumber).child("Medicine").child(TempKey[i]).child("Quantity").once().then((DataSnapshot data) {
            print(data.value);
            MedicineName.insert(0, TempKey[i]);
            MedicineName.insert(1, data.value.toString());
          });
        }
    }
    catch (e) {
      print(e);
    }
    print(MedicineName);
    return MedicineName;
  }
}