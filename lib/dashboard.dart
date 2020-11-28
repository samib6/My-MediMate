import 'package:flutter/material.dart';
import 'prescription_logs.dart';
import 'Prescription.dart';
import 'MedicineBill.dart';
import 'Profile.dart';

class Dashboard extends StatelessWidget {
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
                    'Username',
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
                                      builder: (context) => PrescriptionPage(title:'MyMediMate'),
                                    ));
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
                                    Text('Upload Prescription')
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
                                      builder: (context) => MedicineBillPage(title:'My MediMate'),
                                    ));
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
                                    Text('Upload Medical Bill')
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
                                      builder: (context) => Prescription_Logs(),
                                    ));
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
                                      builder: (context) => Prescription_Logs(),
                                    ));
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
                                      builder: (context) => ProfilePage(title:'My MediMate'),
                                    ));
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
                                      builder: (context) => Prescription_Logs(),
                                    ));
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
