import 'package:flutter/material.dart';
import 'signup.dart';
//import 'lib/localization/language_constants.dart';

class SelectLanguagePage extends StatefulWidget {
  @override
  _SelectLanguagePageState createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends State<SelectLanguagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.0),
          child: AppBar(
              title: Container(
            child: Column(
              children: [
                Row(
                  children: [Padding(padding: EdgeInsets.all(5))],
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                    ),
                    Text("जारी रखने के लिए भाषा का चयन करें"),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    Text("Select language to continue"),
                  ],
                )
              ],
            ),
          ))),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Center(
            child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          SignUp()), (Route<dynamic> route) => false);
                    },
                    child: Text("हिंदी",
                        style: TextStyle(
                            fontSize: 32.0, fontWeight: FontWeight.bold)),
                    minWidth: 100.0,
                    height: 90.0,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          SignUp()), (Route<dynamic> route) => false);
                    },
                    child: Text("English",
                        style: TextStyle(
                            fontSize: 32.0, fontWeight: FontWeight.bold)),
                    minWidth: 100.0,
                    height: 90.0,
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}
