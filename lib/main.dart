import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:animator/animator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:otp_text_field/style.dart';
import 'sheet.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animate_icons/animate_icons.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // ignore: deprecated_member_use
        textSelectionHandleColor: Colors.transparent,
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: Colors.transparent,
          cursorColor: Color(0xffdbddfa),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: App_Launch(),
    );
  }
}

bool isAuthenticated = false;
final storage = new FlutterSecureStorage();
List<String> months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];
var h;
var w;

class App_Launch extends StatefulWidget {
  @override
  _App_LaunchState createState() => _App_LaunchState();
}

class _App_LaunchState extends State<App_Launch> {
  void pop() {
    Navigator.pop(context);
  }

  GetIt locator = GetIt();
  final _auth = LocalAuthentication();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> authenticate() async {
    try {
      isAuthenticated = await _auth.authenticateWithBiometrics(
        localizedReason: 'Authenticate to Access',
        useErrorDialogs: true,
        stickyAuth: true,
      );
      setState(() {
        if (isAuthenticated == true) {
          Navigator.pushReplacement(
            context,
            PageTransition(
                child: MyHomePage(),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 1000)),
          );
        }
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void setupLocator() {
    locator.registerLazySingleton(() {
      authenticate();
    });
  }

  void pin() {
    showModalBottomSheet(
        backgroundColor: Colors.black,
        isScrollControlled: true,
        //barrierColor: Color(0xff476ffa).withOpacity(.2),
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: .45 * h,
              color: Colors.black,
              child: Column(
                children: [
                  SizedBox(height: .03 * h),
                  Text(
                    'Pin Authentication',
                    style: TextStyle(color: Colors.white, fontSize: w / 20),
                  ),
                  Text(
                    'Touch sensor',
                    style: TextStyle(color: Colors.white, fontSize: w / 20),
                  ),
                  Text(
                    'Authenticate to Access',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: .004 * h),
                  Text(
                    'Type the pin',
                    style: TextStyle(
                      color: Color(0xff5f5f5f),
                    ),
                  ),
                  SizedBox(height: .025 * h),
                  Container(
                    height: h / 20.5,
                    width: w / 2.1176,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color(0xff476ffa),
                            width: w / 360,
                            style: BorderStyle.solid),
                        borderRadius:
                            BorderRadius.all(Radius.circular(w / 30))),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(w / 15)),
                      color: Colors.black,
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                            color: Color(0xff476ffa), fontSize: w / 30),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(height: .07 * h),
                  SizedBox(
                    height: h / 15.375,
                    width: w / 1.5,
                    child: MaterialApp(
                      debugShowCheckedModeBanner: false,
                      theme: ThemeData(
                          // ignore: deprecated_member_use
                          textSelectionHandleColor: Colors.transparent,
                          inputDecorationTheme: InputDecorationTheme(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2.0, color: Color(0xff80cbc4))),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2.0, color: Color(0xff80cbc4))),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2.0, color: Color(0xff80cbc4))),
                          )),
                      home: OTPTextField(
                        length: 4,
                        fieldWidth: w / 7.2,
                        style: TextStyle(
                            fontSize: w / 20, color: Color(0xff80cbc4)),
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldStyle: FieldStyle.underline,
                        onCompleted: (pin) {
                          if (pin == '9415') {
                            isAuthenticated = true;
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: MyHomePage(),
                                  type: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 1000)),
                            );
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<Null> count() async {
    final all = await storage.readAll();
    int ref = 0;
    for (var k in all.keys) {
      if (int.parse(k) > ref) ref = int.parse(k);
    }
    curl = ref;
  }

  @override
  void initState() {
    setupLocator();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    count();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;

    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: .4 * h),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset('assets/loading.gif')),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: .725 * h),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        color: Colors.white,
                        size: w / 10,
                      ),
                      SizedBox(width: .05 * w),
                      SizedBox(
                          width: w / 2.88,
                          child: Text(
                            'NOTES',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: w / 10,
                              fontFamily: 'Overpass',
                              fontWeight: FontWeight.bold,
                            ),
                          ) /*RotateAnimatedTextKit(
                          text: ['SECURE', 'NOTES'],
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: w / 10,
                            fontFamily: 'Overpass',
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                          repeatForever: true,
                        ),*/
                          )
                    ],
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: .18 * h),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: h / 18.45,
                  width: w / 1.8,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(0xffdbddfa),
                        width: 0.5,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(w / 15)),
                    /*boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: .1,
                      blurRadius: 18,
                      offset: Offset(0, 1)
                    )
                  ]*/
                  ),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(w / 15)),
                    color: Color(0xff101320),
                    child: Text(
                      'PIN',
                      style: TextStyle(
                          color: Color(0xffdbddfa),
                          fontWeight: FontWeight.bold,
                          fontSize: w / 32.7272,
                          fontFamily: 'Overpass'),
                    ),
                    onPressed: () {
                      pin();
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: .1 * h),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: h / 18.45,
                  width: w / 1.8,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color(0xffdbddfa),
                          width: 0.5,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(w / 15))),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(w / 15)),
                    color: Color(0xff101320),
                    child: Text(
                      'FINGERPRINT',
                      style: TextStyle(
                          color: Color(0xffdbddfa),
                          fontWeight: FontWeight.bold,
                          fontSize: w / 32.7272,
                          fontFamily: 'Overpass'),
                    ),
                    onPressed: () {
                      authenticate();
                    },
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

int curl = -1;
int fol = 0;
double scrollHeight = 0.0;
String bar = 'files';
String search = '';

class _MyHomePageState extends State<MyHomePage> {
  ScrollController _scrollController;
  AnimateIconController _controller;

  @override
  void initState() {
    _scrollController = ScrollController();
    _controller = AnimateIconController();
    if (scrollHeight != 0.0)
      Timer(Duration(milliseconds: 1),
          () => _scrollController.jumpTo(scrollHeight));
    readAll();
    // TODO: implement initState
    super.initState();
  }

  List<String> note = [];
  List<int> key = [];
  List<String> folder = [];
  List<int> f_key = [];
  Future<Null> readAll() async {
    final all = await storage.readAll();
    for (var k in all.keys) {
      key.add(int.parse(k));
      note.add(all[k].toString());
      setState(() {});
      /*if (all[k].contains('folder_')) {
        f_key.add(int.parse(k.toString()));
        folder.add(all[k].toString());
        setState(() {});
      } else {
        key.add(int.parse(k.toString()));
        note.add(all[k].toString());
        setState(() {});
      }*/
    }
    for (int i = 0; i < note.length - 1; i++) {
      for (int j = i + 1; j < note.length; j++) {
        if (note[i].split('|')[0].compareTo(note[j].split('|')[0]) > 0) {
          String c = note[i];
          note[i] = note[j];
          note[j] = c;
          int r = key[i];
          key[i] = key[j];
          key[j] = r;
        }
      }
    }
    //fol = f_key[f_key.length - 1] + 1;
  }

  String word = '';
  String folderName = '';

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return isAuthenticated == true
        ? SafeArea(
            child: Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  elevation: 0,
                  leading: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: w / 22.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.menu_sharp, color: Color(0xffdbddfa)),
                            SizedBox(height: h / 184.5),
                            Text(
                              'menu',
                              style: TextStyle(
                                color: Color(0xffdbddfa),
                                fontFamily: 'Overpass',
                              ),
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.menu_sharp, color: Colors.transparent),
                        onPressed: () async {
                          //await storage.deleteAll();
                          scrollHeight = _scrollController.position.pixels;
                        },
                      ),
                    ],
                  ),
                  backgroundColor: Colors.black,
                  title: Animator<double>(
                    tween: Tween<double>(begin: w / 18, end: w / 12.8571),
                    cycles: 0,
                    duration: Duration(seconds: 1),
                    builder: (context, animatorState, child) => Center(
                      child: Container(
                        child: Text(
                          'NOTES',
                          style: TextStyle(
                              fontSize: animatorState.value,
                              letterSpacing: w / 90,
                              color: Color(0xffdbddfa),
                              fontFamily: 'Overpass',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: w / 36),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: AnimateIcons(
                                  startIcon: Icons.note_add_outlined,
                                  startTooltip: 'Icons.note_add_outlined',
                                  endIcon: Icons.create_new_folder_outlined,
                                  endTooltip:
                                      'Icons.create_new_folder_outlined',
                                  size: w / 15,
                                  clockwise: true,
                                  duration: Duration(seconds: 1),
                                  controller: _controller,
                                  color: Color(0xffdbddfa),
                                ),
                              ),
                              bar == 'folders'
                                  ? Text(
                                      'folder',
                                      style: TextStyle(
                                        color: Color(0xffdbddfa),
                                        fontFamily: 'Overpass',
                                      ),
                                    )
                                  : Text(
                                      'file',
                                      style: TextStyle(
                                        color: Color(0xffdbddfa),
                                        fontFamily: 'Overpass',
                                      ),
                                    )
                            ],
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.menu_sharp,
                                color: Colors.transparent),
                            onPressed: () {
                              scrollHeight = _scrollController.position.pixels;
                              if (bar == 'folders') {
                                showModalBottomSheet(
                                    backgroundColor: Colors.black,
                                    isScrollControlled: true,
                                    //barrierColor: Color(0xff476ffa).withOpacity(.2),
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding:
                                            MediaQuery.of(context).viewInsets,
                                        child: Padding(
                                          padding: EdgeInsets.all(w / 20),
                                          child: Container(
                                            height: .2 * h,
                                            decoration: BoxDecoration(
                                                color: Color(0xff101320),
                                                border: Border.all(
                                                    color: Color(0xffdbddfa),
                                                    width: 0.5,
                                                    style: BorderStyle.solid),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(w / 20))),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: h / 73.8,
                                                ),
                                                Text(
                                                  'New folder',
                                                  style: TextStyle(
                                                      color: Color(0xffdbddfa),
                                                      fontFamily: 'Overpass',
                                                      fontSize: w / 22.5),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: w / 20,
                                                      right: w / 20,
                                                      top: h / 73.8),
                                                  child: Container(
                                                    height: h / 16.77,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xff101320),
                                                        border: Border.all(
                                                            color: Color(
                                                                0xffdbddfa),
                                                            width: 0.5,
                                                            style: BorderStyle
                                                                .solid),
                                                        borderRadius: BorderRadius
                                                            .all(Radius
                                                                .circular(w /
                                                                    16.3636))),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: w / 20,
                                                          right: w / 20),
                                                      child: Center(
                                                        child: TextFormField(
                                                          cursorColor:
                                                              Color(0xffdbddfa),
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintText:
                                                                'New folder',
                                                            hintStyle: TextStyle(
                                                                color: Color(
                                                                        0xffdbddfa)
                                                                    .withOpacity(
                                                                        0.2),
                                                                fontFamily:
                                                                    'Overpass'),
                                                          ),
                                                          onChanged:
                                                              (String value) {
                                                            setState(() {
                                                              folderName =
                                                                  value;
                                                            });
                                                          },
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xffdbddfa)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    FlatButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xff476ffa),
                                                            fontFamily:
                                                                'Overpass',
                                                          ),
                                                        )),
                                                    Container(
                                                      height: h / 30.75,
                                                      width: w / 360,
                                                      color: Color(0xffdbddfa),
                                                    ),
                                                    FlatButton(
                                                        onPressed: () async {
                                                          if (folder.length ==
                                                                  0 &&
                                                              folderName !=
                                                                  '') {
                                                            curl++;
                                                            await storage.write(
                                                                key: '10000000',
                                                                value: 'folder_' +
                                                                    folderName +
                                                                    '_' +
                                                                    DateTime.now()
                                                                        .toString());
                                                            Navigator
                                                                .pushReplacement(
                                                              context,
                                                              PageTransition(
                                                                  child:
                                                                      MyHomePage(),
                                                                  type:
                                                                      PageTransitionType
                                                                          .fade,
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          1500)),
                                                            );
                                                          } else if (folderName !=
                                                              '') {
                                                            curl++;
                                                            await storage.write(
                                                                key: fol
                                                                    .toString(),
                                                                value: 'folder_' +
                                                                    folderName +
                                                                    '_' +
                                                                    DateTime.now()
                                                                        .toString());
                                                            Navigator
                                                                .pushReplacement(
                                                              context,
                                                              PageTransition(
                                                                  child:
                                                                      MyHomePage(),
                                                                  type:
                                                                      PageTransitionType
                                                                          .fade,
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          1500)),
                                                            );
                                                          } else if (folderName == '')
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Folder must have some name sir!",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                                backgroundColor:
                                                                    Colors
                                                                        .black54,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 13.0);
                                                        },
                                                        child: Text(
                                                          'Ok',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xff476ffa),
                                                            fontFamily:
                                                                'Overpass',
                                                          ),
                                                        )),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              } else {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      child: Data(),
                                      type: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 475)),
                                );
                              }
                            }),
                      ],
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: w / 20, right: w / 20, top: h / 73.8),
                      child: Container(
                        height: h / 16.77,
                        decoration: BoxDecoration(
                            color: Color(0xff101320),
                            border: Border.all(
                                color: Color(0xffdbddfa),
                                width: 0.5,
                                style: BorderStyle.solid),
                            borderRadius:
                                BorderRadius.all(Radius.circular(w / 16.36))),
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: w / 22.5, right: w / 22.5),
                          child: Center(
                            child: TextFormField(
                              cursorColor: Color(0xffdbddfa),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                    color: Color(0xffdbddfa).withOpacity(0.2),
                                    fontFamily: 'Overpass'),
                              ),
                              initialValue: search,
                              onChanged: (String value) {
                                setState(() {
                                  search = value;
                                });
                              },
                              style: TextStyle(color: Color(0xffdbddfa)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: .07 * h,
                              child: FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      bar = 'files';
                                      scrollHeight = 0.0;
                                      Timer(Duration(milliseconds: 1),
                                          () => _scrollController.jumpTo(0.0));
                                      if (_controller.isEnd())
                                        _controller.animateToStart();
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: h / 49.2,
                                      ),
                                      Text(
                                        'files',
                                        style: TextStyle(
                                            color: Color(0xffdbddfa),
                                            fontFamily: 'Overpass',
                                            fontSize: w / 18),
                                      ),
                                      Container(
                                        height: h / 246,
                                        width: w / 10.2857,
                                        color: bar == 'files'
                                            ? Color(0xff80cbc4)
                                            : Colors.transparent,
                                      )
                                    ],
                                  )),
                            ),
                            Container(
                              height: .07 * h,
                              child: FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      bar = 'favourites';
                                      scrollHeight = 0.0;
                                      Timer(Duration(milliseconds: 1),
                                          () => _scrollController.jumpTo(0.0));
                                      if (_controller.isEnd())
                                        _controller.animateToStart();
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: h / 49.2,
                                      ),
                                      Text(
                                        'favourites',
                                        style: TextStyle(
                                            color: Color(0xffdbddfa),
                                            fontSize: w / 18,
                                            fontFamily: 'Overpass'),
                                      ),
                                      Container(
                                        height: h / 246,
                                        width: w / 10.2857,
                                        color: bar == 'favourites'
                                            ? Color(0xff80cbc4)
                                            : Colors.transparent,
                                      )
                                    ],
                                  )),
                            ),
                            /*Container(
                  height: .07*h,
                  child: FlatButton(
                          onPressed: () {
                            setState(() {
                              bar = 'folders';
                              scrollHeight = 0.0;
                              Timer(Duration(milliseconds: 1), () => _scrollController.jumpTo(0.0));
                              if(_controller.isStart())
                                _controller.animateToEnd();
                            });
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'folders',
                                style: TextStyle(
                                    color: Color(0xffdbddfa),
                                    fontFamily: 'Overpass',
                                    fontSize: 20
                                ),
                              ),
                              Container(
                                height: 3,
                                width: 35,
                                color: bar == 'folders' ? Color(0xff80cbc4) : Colors.transparent,
                              )
                            ],
                          )
                  ),
                ),*/
                          ],
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: h / 30.75, right: w / 36),
                          child: Text(
                            note.length.toString() + ' items',
                            style: TextStyle(
                                color: Color(0xffdbddfa),
                                fontFamily: 'Overpass'),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              controller: _scrollController,
                              itemCount: note.length,
                              itemBuilder: (BuildContext context, int index) {
                                return (bar == 'favourites' &&
                                            note[index]
                                                .contains('|favourites') &&
                                            (search == '' ||
                                                note[index]
                                                    .split('|')[0]
                                                    .contains(search))) ||
                                        (bar == 'files' &&
                                            (search == '' ||
                                                note[index]
                                                    .split('|')[0]
                                                    .contains(search)))
                                    ? Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18)),
                                        color: Color(0xff101320),
                                        child: Stack(
                                          children: [
                                            ListTile(
                                              title: Text(
                                                  note[index].split('|')[0],
                                                  style: TextStyle(
                                                      fontSize: w / 20,
                                                      fontFamily: 'Overpass',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                              subtitle: Text(
                                                note[index]
                                                        .split('|')[2]
                                                        .substring(8, 11) +
                                                    months[int.parse(note[index]
                                                            .split('|')[2]
                                                            .substring(5, 7)) -
                                                        1] +
                                                    ' ' +
                                                    note[index]
                                                        .split('|')[2]
                                                        .substring(0, 4) +
                                                    ',  ' +
                                                    note[index]
                                                        .split('|')[2]
                                                        .substring(11, 16),
                                                style: TextStyle(
                                                    color: Color(0xff80cbc4),
                                                    fontFamily: 'Overpass'),
                                              ),
                                            ),
                                            Positioned.fill(
                                                child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color(0xffdbddfa),
                                                      width: 0.5,
                                                      style: BorderStyle.solid),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              w / 20))),
                                              child: FlatButton(
                                                onPressed: () {
                                                  scrollHeight =
                                                      _scrollController
                                                          .position.pixels;
                                                  Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        child: Edit(
                                                            curkey: key[index],
                                                            note: note[index]),
                                                        type: PageTransitionType
                                                            .fade,
                                                        duration: Duration(
                                                            milliseconds: 800)),
                                                  );
                                                },
                                                onLongPress: () {
                                                  showModalBottomSheet(
                                                      backgroundColor:
                                                          Colors.black,
                                                      isScrollControlled: true,
                                                      //barrierColor: Color(0xff476ffa).withOpacity(.2),
                                                      context: context,
                                                      builder: (context) {
                                                        return Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  w / 20),
                                                          child: Container(
                                                            height: .13 * h,
                                                            decoration: BoxDecoration(
                                                                color: Color(
                                                                    0xff101320),
                                                                border: Border.all(
                                                                    color: Color(
                                                                        0xffdbddfa),
                                                                    width: 0.5,
                                                                    style: BorderStyle
                                                                        .solid),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(w /
                                                                            20))),
                                                            child: Center(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      IconButton(
                                                                          icon:
                                                                              Icon(
                                                                            Icons.delete_outline,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                w / 12.85,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                            showModalBottomSheet(
                                                                                backgroundColor: Colors.black,
                                                                                isScrollControlled: true,
                                                                                //barrierColor: Color(0xff476ffa).withOpacity(.2),
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return Padding(
                                                                                    padding: EdgeInsets.all(w / 20),
                                                                                    child: Container(
                                                                                      height: .13 * h,
                                                                                      decoration: BoxDecoration(color: Color(0xff101320), border: Border.all(color: Color(0xffdbddfa), width: 0.5, style: BorderStyle.solid), borderRadius: BorderRadius.all(Radius.circular(w / 20))),
                                                                                      child: Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          SizedBox(
                                                                                            height: h / 73.8,
                                                                                          ),
                                                                                          Text(
                                                                                            'Are you sure you want to delete this note?',
                                                                                            style: TextStyle(color: Color(0xffdbddfa), fontFamily: 'Overpass', fontSize: w / 22.5),
                                                                                          ),
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                            children: [
                                                                                              FlatButton(
                                                                                                  onPressed: () {
                                                                                                    Navigator.pop(context);
                                                                                                  },
                                                                                                  child: Text(
                                                                                                    'Cancel',
                                                                                                    style: TextStyle(
                                                                                                      color: Color(0xff476ffa),
                                                                                                      fontFamily: 'Overpass',
                                                                                                    ),
                                                                                                  )),
                                                                                              Container(
                                                                                                height: h / 30.75,
                                                                                                width: w / 360,
                                                                                                color: Color(0xffdbddfa),
                                                                                              ),
                                                                                              FlatButton(
                                                                                                  onPressed: () async {
                                                                                                    await storage.delete(key: key[index].toString());
                                                                                                    scrollHeight = _scrollController.position.pixels;
                                                                                                    Navigator.pushReplacement(
                                                                                                      context,
                                                                                                      PageTransition(child: MyHomePage(), type: PageTransitionType.fade, duration: Duration(milliseconds: 800)),
                                                                                                    );
                                                                                                  },
                                                                                                  child: Text(
                                                                                                    'Delete',
                                                                                                    style: TextStyle(
                                                                                                      color: Color(0xff476ffa),
                                                                                                      fontFamily: 'Overpass',
                                                                                                    ),
                                                                                                  )),
                                                                                            ],
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                });
                                                                          }),
                                                                      Text(
                                                                        'Delete',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      IconButton(
                                                                          icon:
                                                                              Icon(
                                                                            Icons.share,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                h / 26.3571,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            Share.text(
                                                                                'Notes ${DateTime.now()}',
                                                                                note[index].split('|')[0] + '\n' + '\n' + note[index].split('|')[1],
                                                                                'text/plain');
                                                                            Navigator.pop(context);
                                                                          }),
                                                                      Text(
                                                                        'Share',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                },
                                              ),
                                            )),
                                            Positioned.fill(
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: RotatedBox(
                                                    quarterTurns: 2,
                                                    child: IconButton(
                                                      icon: GlowIcon(
                                                        !note[index].contains(
                                                                '|favourites')
                                                            ? Icons
                                                                .lightbulb_outline
                                                            : Icons.lightbulb,
                                                        color: !note[index]
                                                                .contains(
                                                                    '|favourites')
                                                            ? Color(0xffdbddfa)
                                                            : Colors.yellow,
                                                        glowColor: !note[index]
                                                                .contains(
                                                                    '|favourites')
                                                            ? Colors.transparent
                                                            : Colors.yellow,
                                                        blurRadius: 15,
                                                      ),
                                                      splashRadius: 4,
                                                      onPressed: () async {
                                                        if (note[index].contains(
                                                            '|favourites')) {
                                                          await storage.write(
                                                              key: key[index]
                                                                  .toString(),
                                                              value: note[index]
                                                                  .substring(
                                                                      0,
                                                                      note[index]
                                                                              .length -
                                                                          11));
                                                        } else {
                                                          await storage.write(
                                                              key: key[index]
                                                                  .toString(),
                                                              value: note[
                                                                      index] +
                                                                  '|favourites');
                                                        }
                                                        scrollHeight =
                                                            _scrollController
                                                                .position
                                                                .pixels;
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          PageTransition(
                                                              child:
                                                                  MyHomePage(),
                                                              type:
                                                                  PageTransitionType
                                                                      .fade,
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      1500)),
                                                        );
                                                      },
                                                    ),
                                                  )),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container();
                              }),
                          bar == 'folders'
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  //controller: _scrollController,
                                  itemCount: folder.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(w / 20)),
                                      color: Color(0xff101320),
                                      child: Stack(
                                        children: [
                                          ListTile(
                                            title: Text(
                                                folder[index].split('_')[1],
                                                style: TextStyle(
                                                    fontSize: w / 20,
                                                    fontFamily: 'Overpass',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            subtitle: Text(
                                              folder[index]
                                                      .split('_')[2]
                                                      .substring(8, 11) +
                                                  months[int.parse(folder[index]
                                                          .split('_')[2]
                                                          .substring(5, 7)) -
                                                      1] +
                                                  ' ' +
                                                  folder[index]
                                                      .split('_')[2]
                                                      .substring(0, 4) +
                                                  ',  ' +
                                                  folder[index]
                                                      .split('_')[2]
                                                      .substring(11, 16),
                                              style: TextStyle(
                                                  color: Color(0xff80cbc4),
                                                  fontFamily: 'Overpass'),
                                            ),
                                          ),
                                          Positioned.fill(
                                              child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xffdbddfa),
                                                    width: 0.5,
                                                    style: BorderStyle.solid),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(18))),
                                            child: FlatButton(
                                              onPressed: () {
                                                scrollHeight = _scrollController
                                                    .position.pixels;
                                              },
                                              onLongPress: () {
                                                showModalBottomSheet(
                                                    backgroundColor:
                                                        Colors.black,
                                                    isScrollControlled: true,
                                                    //barrierColor: Color(0xff476ffa).withOpacity(.2),
                                                    context: context,
                                                    builder: (context) {
                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.all(18),
                                                        child: Container(
                                                          height: .13 * h,
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  0xff101320),
                                                              border: Border.all(
                                                                  color: Color(
                                                                      0xffdbddfa),
                                                                  width: 0.5,
                                                                  style:
                                                                      BorderStyle
                                                                          .solid),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          18))),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    IconButton(
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .delete_outline,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              28,
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          showModalBottomSheet(
                                                                              backgroundColor: Colors.black,
                                                                              isScrollControlled: true,
                                                                              //barrierColor: Color(0xff476ffa).withOpacity(.2),
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return Padding(
                                                                                  padding: EdgeInsets.all(18),
                                                                                  child: Container(
                                                                                    height: .13 * h,
                                                                                    decoration: BoxDecoration(color: Color(0xff101320), border: Border.all(color: Color(0xffdbddfa), width: 0.5, style: BorderStyle.solid), borderRadius: BorderRadius.all(Radius.circular(18))),
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                        Text(
                                                                                          'Are you sure you want to delete this note?',
                                                                                          style: TextStyle(color: Color(0xffdbddfa), fontFamily: 'Overpass', fontSize: 16),
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                          children: [
                                                                                            FlatButton(
                                                                                                onPressed: () {
                                                                                                  Navigator.pop(context);
                                                                                                },
                                                                                                child: Text(
                                                                                                  'Cancel',
                                                                                                  style: TextStyle(
                                                                                                    color: Color(0xff476ffa),
                                                                                                    fontFamily: 'Overpass',
                                                                                                  ),
                                                                                                )),
                                                                                            Container(
                                                                                              height: 24,
                                                                                              width: w / 360,
                                                                                              color: Color(0xffdbddfa),
                                                                                            ),
                                                                                            FlatButton(
                                                                                                onPressed: () async {
                                                                                                  await storage.delete(key: key[index].toString());
                                                                                                  scrollHeight = _scrollController.position.pixels;
                                                                                                  Navigator.pushReplacement(
                                                                                                    context,
                                                                                                    PageTransition(child: MyHomePage(), type: PageTransitionType.fade, duration: Duration(milliseconds: 800)),
                                                                                                  );
                                                                                                },
                                                                                                child: Text(
                                                                                                  'Delete',
                                                                                                  style: TextStyle(
                                                                                                    color: Color(0xff476ffa),
                                                                                                    fontFamily: 'Overpass',
                                                                                                  ),
                                                                                                )),
                                                                                          ],
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              });
                                                                        }),
                                                                    Text(
                                                                      'Delete',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                            ),
                                          )),
                                        ],
                                      ),
                                    );
                                  })
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                )),
          )
        : Scaffold(
            backgroundColor: Colors.black,
            body: Padding(
              padding: EdgeInsets.only(top: h / 3.69),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Sorry, Please Re-Authenticate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: w / 18,
                        fontFamily: 'Overpass',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: h / 36.9),
                    Container(
                      height: h / 15.375,
                      width: w / 1.6,
                      child: FlatButton(
                        color: Colors.white,
                        child: Text(
                          'Go To Authentication',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: w / 18,
                            fontFamily: 'Overpass',
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => App_Launch()),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
