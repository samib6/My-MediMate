import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'navbar.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:medi_mate/Database.dart';
enum TtsState { playing, stopped }

class Prescription_Image extends StatefulWidget {
  String userName;
  String userPhone;
  Prescription_Image({Key key, @required this.userName,this.userPhone}) : super(key: key);

  @override
  _ImageState createState() => _ImageState(userName: userName,userPhone :userPhone);
}

class _ImageState extends State<Prescription_Image> {
  String userName;
  String userPhone;
  _ImageState({Key key, @required this.userName,this.userPhone});
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
      body: SingleChildScrollView (child : PrescriptionImageForm(userName: userName,userPhone: userPhone,),),
    );
  }

}

class PrescriptionImageForm extends StatefulWidget {
  String userName;
  String userPhone;
  PrescriptionImageForm({Key key, @required this.userName,this.userPhone}) : super(key: key);
  @override
  _PrescriptionImageFormState createState() => _PrescriptionImageFormState(userName: userName,userPhone: userPhone);
}

class _PrescriptionImageFormState extends State<PrescriptionImageForm> {
  String userName;
  String userPhone;
  _PrescriptionImageFormState({Key key, @required this.userName,this.userPhone});
  final _formKey = GlobalKey<FormState>();
  File _image;
  FlutterTts flutterTts;
  final picker = ImagePicker();
  static final String uploadEndPoint = 'http://10.0.2.2/saveFile.php';
  Future<File> file;
  String status = '';
  String base64Image;
  String diseaseName;
  String day;
  var jsonsDataString;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  Database d = new Database();
  chooseImage() async {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);

    });
    setStatus('');

    /*
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(file);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
    setState(() {
      print("Profile Picture uploaded");
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });

     */
  }


  setStatus(String message) {

    setState(() {
      status = message;
    });

  }

  startUpload() {

    setStatus('Uploading Image...');
    if (null == tmpFile) {
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    upload(fileName);
  }


  upload(String fileName) {
    final encoding = Encoding.getByName('utf-8');
    final headers = {'Content-Type': 'application/json'};

    http.post(uploadEndPoint, body: {
      "image": base64Image,
      "name": fileName,

    }).then((result) async {
      if(result.statusCode==200)
      {
        jsonsDataString = result.body; // toString of Response's body is assigned to jsonDataString
        //  print(json.decode(result.body));
        //Map<String, dynamic> map = jsonDecode(jsonsDataString);
        // var pdfText= await json.decode(json.encode(response.databody);

        // Map jsonData = json.decode(jsonsDataString) as Map;
        print("check");
        print(jsonsDataString);
        //print(jsonsDataString.key);
        String mediname="";
        String breakf="";
        String lunch="";
        String dinner="";
        int j=1;
        int fl=1;
        for(int i=0;i<jsonsDataString.length-1;i++)
        {
          if(jsonsDataString[i]=='\'')
          {
            j=i+1;
            mediname="";
            while(jsonsDataString[j]!='\'')
            {
              mediname =mediname+jsonsDataString[j];
              j++;
            }
            i=j+3;
            print(mediname);
            fl=0;
          }
          if(fl==0)
          {
            breakf="";
            lunch="";
            dinner="";
            breakf=jsonsDataString[i+2]+"";
            lunch=jsonsDataString[i+5]+"";
            dinner=jsonsDataString[i+8]+"";

            print(breakf);
            print(lunch);
            print(dinner);
            i=i+6;
            fl=1;
            print(userPhone);
            print(diseaseName);
            print(mediname);
            print((breakf=="0"?false:true).toString());
            print((lunch=="0"?false:true).toString());
            print((dinner=="0"?false:true).toString());
            print(DateTime.now().toString());
            print((day));
            d.savePrescription(userPhone, diseaseName, mediname, breakf=="0"?false:true, lunch=="0"?false:true, dinner=="0"?false:true, DateTime.now().toString().split(' ')[0],int.parse(day));
          }


        }

        /* for(int i=0;i<jsonsDataString.keys.length;i++)
        {
          print("Medicine Name : "+ jsonsDataString.key);
          //savePrescription(userPhone,diseaseName,jsonsDataString[i].key,jsonsDataString.key[i].Value[0])
        }*/
      }
    }).catchError((error) {
      print("hellll ");
      print(error);
    });

  }


  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              height: 200,
              fit: BoxFit.fill,
            ),

          );

        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image Demo"),
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            OutlineButton(
              onPressed: chooseImage,
              child: Text('Choose Image'),
            ),
            SizedBox(
              height: 20.0,
            ),
            showImage(),
            SizedBox(
              height: 20.0,
            ),
            OutlineButton(
              onPressed: startUpload,
              //onLongPress: up_firebase,
              child: Text('Upload Image'),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }*/
  /*
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

  @override
  void initState() {
    super.initState();
  //  initTts();
    //flutterTts.setLanguage("hi-IN");
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
*/

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: RaisedButton(
                color : const Color(0xFFFFC7C7),

                child: Row(children: [
                  Flexible(
                    flex: 1,
                    child:  Icon(Icons.upload_rounded,color : Colors.brown[300]),
                  ),
                  Flexible(
                    flex: 8,
                    child: Center(child: Text("Input Prescription Image")),
                  ),
                ]),
                onPressed: ()
                {showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildAboutDialog(context),
                );}
            ),
          ),

          Container(

            padding: EdgeInsets.all(30.0),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if(file!=null)
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 40,
                      height: 40,
                      child: FlatButton(
                        padding: const EdgeInsets.only(
                            right: 10.0, top: 5.0),
                        color: Colors.black.withOpacity(0.0),
                        child: Icon(
                          Icons.cancel_outlined,
                          color: Colors.red,
                          size: 30,
                        ),
                        onPressed: () {
                          file = null;
                          setState(() {});
                        },
                      ),

                    ),
                  ),

                SizedBox(
                  height: 20.0,
                ),
                showImage(),
                SizedBox(
                  height: 20.0,
                ),
                if (file != null)
                  OutlineButton(

                    onPressed: startUpload,
                    //onLongPress: up_firebase,
                    color : const Color(0xFFFFC7C7),
                    child: Text('Upload Image'),
                  ),
                /*SizedBox(
                  height: 20.0,
                ),*/
                /*Text(
                  status,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                  ),
                ),*/
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),


          ListTile(
            leading: Icon(Icons.medical_services_outlined,color:Colors.brown[300]),
            title: TextFormField(
              decoration: InputDecoration(
                hintText: "Disease Name",
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter Disease Name';
                }
                else
                {
                  diseaseName=value;
                }
                return null;
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.medical_services_outlined,color:Colors.brown[300]),
            title: TextFormField(
              decoration: InputDecoration(
                hintText: "Number of days",
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter Disease Name';
                }
                else
                {
                  day=value;
                }
                return null;
              },
            ),
          ),
          RaisedButton(
            color : const Color(0xFFFFC7C7),
            child: Text("Read Prescription from Image"),
            onPressed: () {
              if (_image!= null)
              {
                //  _newVoiceText="ABC Medicine (No Generics) 250mg capsules, take 1 capsule twice a day, 1 after breakfast, 1 after dinner";
                //_speak();
              }
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Saving Data'),
                ));
                /*for(int i=0;i<jsonsDataString.keys().length;i++)
                {
                  print("Medicine Name : "+ jsonsDataString.key);
                  //savePrescription(userPhone,diseaseName,jsonsDataString[i].key,jsonsDataString.key[i].Value[0])
                }

               */
              }
              startUpload();
            },
            child: Text('Save'),
          )
        ],
      ),
    );
  }


  Widget _buildAboutDialog(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
              leading: const Icon(Icons.photo),
              title: Text("Choose from Gallery"),
              onTap: () {
                _imgFromGallery();
                Navigator.of(context).pop();
              }),
          ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text("Take a Photo"),
              onTap: () {
                _imgFromCamera();
                Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }

  _imgFromCamera() async {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.camera);

    });
    setStatus('');
  }

  _imgFromGallery() async {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);

    });
    setStatus('');
  }


}
