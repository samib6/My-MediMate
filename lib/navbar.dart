import 'package:flutter/material.dart';
import 'package:medi_mate/Chatbot.dart';
import 'package:medi_mate/MedicineBill_manual.dart';
import 'medical_logs.dart';
import 'prescription_logs.dart';
import 'Prescription.dart';
import 'MedicineBill.dart';
import 'Profile.dart';
import 'dashboard.dart';
import 'Chatbot.dart';

class NavDrawer extends StatelessWidget {
  String userName;
  String userPhone;
  NavDrawer({Key key, @required this.userName,@required this.userPhone}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          //Image.asset('assets/cover.png'),
          DrawerHeader(
            child: Text(
              ''+userName,
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
           
            decoration: BoxDecoration(
                color: Colors.brown,
                image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: AssetImage('assets/womanavatar.png'))),
          ),
           
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Input Prescription Image'),
            onTap: () => {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Dashboard(userPhone: userPhone,userName: userName,),
                    ),
                    ModalRoute.withName('/')),

            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PrescriptionPage(userName: userName,userPhone: userPhone,),
                                    )),
            },
          ),
          ListTile(
            
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Dashboard(userPhone: userPhone,userName: userName,),
                  ),
                  ModalRoute.withName('/')),
              Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfilePage(userName: userName,userPhone: userPhone,),
                                    )),
            },
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Prescription Logs'),
            onTap: () => {Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Dashboard(userPhone: userPhone,userName: userName,),
                ),
                ModalRoute.withName('/')),
              Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Prescription_Logs(userName: userName,userPhone: userPhone,),
                                    )),},
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Medical Logs'),
            onTap: () => {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Dashboard(userPhone: userPhone,userName: userName,),
                  ),
                  ModalRoute.withName('/')),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Medical_Logs(userName: userName,userPhone: userPhone,),
                  )),
            },
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Input Medicine Bill Image'),
            onTap: () => {Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Dashboard(userPhone: userPhone,userName: userName,),
                ),
                ModalRoute.withName('/')),
              Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MedicineBill_Manual(userName: userName,userPhone: userPhone,),
                                      //builder: (context) => MedicineBillPage(userName: userName,userPhone: userPhone,),
                                    )),},
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('Chat'),
            onTap: () => {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Dashboard(userPhone: userPhone,userName: userName,),
                ),
                ModalRoute.withName('/')),
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Chatbot(),
                )),},
          ),
        ],
      ),
    );
  }
}