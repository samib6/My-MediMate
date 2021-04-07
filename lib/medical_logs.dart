import 'package:flutter/material.dart';
import 'navbar.dart';
import 'Database.dart';

class Medical_Logs extends StatefulWidget {
  String userName;
  String userPhone;
  Medical_Logs({Key key, @required this.userName,this.userPhone}) : super(key: key);
  @override
  _Medical_LogsState createState() => _Medical_LogsState(userName: userName,userPhone: userPhone);
}

class _Medical_LogsState extends State<Medical_Logs> {
  String userName;
  String userPhone;
  _Medical_LogsState({Key key, @required this.userName,this.userPhone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            title: Image.asset("assets/logo_text.png",width:200,height:100),
            centerTitle: true,
          )),
      drawer:NavDrawer(userName: userName,userPhone: userPhone,),
      body: SingleChildScrollView (child : Logs(userPhone: userPhone,),),
    );
  }

}

class Logs extends StatefulWidget {
  String userPhone;
  Logs({Key key, @required this.userPhone}) : super(key: key);
  @override
  _LogsState createState() => _LogsState(userPhone: userPhone);
}

class _LogsState extends State<Logs> {
  String userPhone;

  _LogsState({Key key, @required this.userPhone});

  Database d = new Database();
  List<String> data;
  bool loaded = false;

  void check() async {
    data = await d.getMedicineQuantity(userPhone);
    print(userPhone);
    loaded = true;
    setState(() {});
  }

  @override
  void initState() {
    check();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loaded) {
      if(data.length>0) {
        return Container(
            child: Column(
                children: <Widget>[
                  ...addLogs(),
                ]
            )
        );
      }
      else{
        return Container(
            color: const Color(0xFFFFE2E2),
            child:Center(
              child: Text("No logs found"),
            )
        );
      }
    }
    else {

        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: const Color(0xFFFFE2E2),
          child: Column(children: [
            /*Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 60.0, top: 70.0, right: 5.0),
                  child: Image.asset('assets/logo_text.png'),
                ),
              ],
            ),*/
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 80.0, right: 20.0),
              child: Row(
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

  List<Widget> addLogs() {
    List<Widget> MedicineList = [];
    for (int i = 0; i < data.length; i += 3) {
      MedicineList.add(Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FlatButton(
            child: Table(
              // textDirection: TextDirection.rtl,
              // defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
              //border: TableBorder.all(width: 2.0, color: Colors.yellow),
                children: [
                  TableRow(children: <Widget>[
                    /*Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                    ),
                    /*Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                    ),*/
                  ]),
                  TableRow(
                      decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  width: 2.0, color: Colors.white)),
                          color: const Color(0xFFFAC7C7)),
                      children: <Widget>[
                        /*Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Image(
                            image: AssetImage('assets/Gallery.png'),
                            height: 90.0,
                            width: 90.0,
                          ),
                        ),*/
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 25.0, bottom: 25.0),
                            child: Center(
                                child: Text(
                                  data[i],
                                  textScaleFactor: 1.2,
                                  textAlign: TextAlign.center,
                                ))),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 25.0, bottom: 25.0),
                            child: Column(
                                  children:[
                                  Text(
                                  "Quantity",
                                  textScaleFactor: 1.2,
                                  textAlign: TextAlign.center,
                                  ), Text(
                                  data[i + 1],
                                  textScaleFactor: 1.2,
                                  textAlign: TextAlign.center,
                                )])),
                        /*Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Image(
                            image: AssetImage('assets/Megaphone.png'),
                            height: 60.0,
                            width: 50.0,
                          ),
                        ),*/
                      ]),
                ]),
            onPressed: () async {},
          ),
        ),
      ]),
      );
    }
    return MedicineList;
  }
}