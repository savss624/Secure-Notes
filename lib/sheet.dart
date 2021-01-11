import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:page_transition/page_transition.dart';
import 'main.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Edit extends StatefulWidget {
  int curkey;
  String note = '';
  Edit({this.curkey, this.note});
  @override
  _EditState createState() =>
      _EditState(title: note.split('|')[0], data: note.split('|')[1]);
}

class _EditState extends State<Edit> {
  String title;
  String data;
  String mode = 'preview';
  String total = '';

  _EditState({this.title, this.data});

  @override
  void initState() {
    total = widget.note;
    get();
    // TODO: implement initState
    super.initState();
  }

  final controller1 = TextEditingController();
  final controller2 = TextEditingController();

  void get() async {
    controller1.text = title;
    controller2.text = data;
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;

    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          return Navigator.pushReplacement(
            context,
            PageTransition(
                child: MyHomePage(),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 800)),
          );
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: MyHomePage(),
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 1000)),
                );
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.check,
                  color: mode == 'edit' ? Colors.white : Colors.transparent,
                ),
                onPressed: mode == 'edit'
                    ? () {
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: Edit(curkey: widget.curkey, note: total),
                              type: PageTransitionType.fade,
                              duration: Duration(milliseconds: 500)),
                        );
                      }
                    : null,
              )
            ],
          ),
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: h / 24.6,
                    right: w / 22.5,
                    bottom: h / 11.53,
                    left: w / 22.5),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xff101320),
                      border: Border.all(
                          color: Color(0xffdbddfa),
                          width: 0.5,
                          style: BorderStyle.solid),
                      borderRadius:
                          BorderRadius.all(Radius.circular(w / 16.3636))),
                  child: Padding(
                    padding: EdgeInsets.all(w / 22.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxHeight: h * .1,
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Input title",
                              hintStyle: TextStyle(
                                fontSize: w / 15,
                                color: Color(0xffdbddfa).withOpacity(0.2),
                                fontFamily: 'Overpass',
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                                fontSize: w / 15,
                                color: Colors.white,
                                fontFamily: 'Overpass'),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: controller1,
                            onTap: () {
                              setState(() {
                                mode = 'edit';
                              });
                            },
                            onChanged: (String value) async {
                              setState(() {
                                title = value;
                                total = widget.note.contains('|favourites')
                                    ? value +
                                        '|' +
                                        data +
                                        '|' +
                                        DateTime.now().toString() +
                                        '|favourites'
                                    : value +
                                        '|' +
                                        data +
                                        '|' +
                                        DateTime.now().toString();
                              });
                              if (title != '') {
                                await storage.write(
                                  key: widget.curkey.toString(),
                                  value: widget.note.contains('|favourites')
                                      ? value +
                                          '|' +
                                          data +
                                          '|' +
                                          DateTime.now().toString() +
                                          '|favourites'
                                      : value +
                                          '|' +
                                          data +
                                          '|' +
                                          DateTime.now().toString(),
                                );
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Title is necessary sir!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black54,
                                    textColor: Colors.white,
                                    fontSize: 13.0);
                                total = widget.note.contains('|favourites')
                                    ? widget.note.split('|')[0] +
                                        '|' +
                                        data +
                                        '|' +
                                        DateTime.now().toString() +
                                        '|favourites'
                                    : widget.note.split('|')[0] +
                                        '|' +
                                        data +
                                        '|' +
                                        DateTime.now().toString();
                                await storage.write(
                                  key: widget.curkey.toString(),
                                  value: widget.note.contains('|favourites')
                                      ? widget.note.split('|')[0] +
                                          '|' +
                                          data +
                                          '|' +
                                          DateTime.now().toString() +
                                          '|favourites'
                                      : widget.note.split('|')[0] +
                                          '|' +
                                          data +
                                          '|' +
                                          DateTime.now().toString(),
                                );
                              }
                            },
                          ),
                        ),
                        Text(
                          widget.note.split('|')[2].substring(8, 11) +
                              months[int.parse(widget.note
                                      .split('|')[2]
                                      .substring(5, 7)) -
                                  1] +
                              ' ' +
                              widget.note.split('|')[2].substring(0, 4) +
                              ',  ' +
                              widget.note.split('|')[2].substring(11, 16) +
                              '  |  ' +
                              data.length.toString() +
                              ' words',
                          style: TextStyle(
                              color: Color(0xff80cbc4), fontFamily: 'Overpass'),
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Enter your note here",
                              hintStyle: TextStyle(
                                fontSize: w / 20,
                                color: Color(0xffdbddfa).withOpacity(0.2),
                                fontFamily: 'Overpass',
                              ),
                              border: InputBorder.none,
                            ),
                            onTap: () {
                              setState(() {
                                mode = 'edit';
                              });
                            },
                            style: TextStyle(
                                fontSize: w / 20,
                                color: Colors.white,
                                fontFamily: 'Overpass'),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: controller2,
                            onChanged: (String value) async {
                              setState(() {
                                data = value;
                                total = widget.note.contains('|favourites')
                                    ? title +
                                        '|' +
                                        value +
                                        '|' +
                                        DateTime.now().toString() +
                                        '|favourites'
                                    : title +
                                        '|' +
                                        value +
                                        '|' +
                                        DateTime.now().toString();
                              });
                              await storage.write(
                                key: widget.curkey.toString(),
                                value: widget.note.contains('|favourites')
                                    ? title +
                                        '|' +
                                        value +
                                        '|' +
                                        DateTime.now().toString() +
                                        '|favourites'
                                    : title +
                                        '|' +
                                        value +
                                        '|' +
                                        DateTime.now().toString(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              mode == 'preview'
                  ? Padding(
                      padding: EdgeInsets.only(right: w / 9),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: w / 12,
                          child: RotatedBox(
                            quarterTurns: 2,
                            child: IconButton(
                              iconSize: w / 10,
                              icon: GlowIcon(
                                !widget.note.contains('|favourites')
                                    ? Icons.lightbulb_outline
                                    : Icons.lightbulb,
                                color: !widget.note.contains('|favourites')
                                    ? Color(0xffdbddfa)
                                    : Colors.yellow,
                                glowColor: !widget.note.contains('|favourites')
                                    ? Colors.transparent
                                    : Colors.yellow,
                                blurRadius: 15,
                              ),
                              splashRadius: 4,
                              onPressed: () async {
                                if (widget.note.contains('|favourites')) {
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: Edit(
                                            curkey: widget.curkey,
                                            note: widget.note.substring(
                                                0, widget.note.length - 11)),
                                        type: PageTransitionType.fade,
                                        duration: Duration(milliseconds: 1500)),
                                  );
                                  await storage.write(
                                      key: widget.curkey.toString(),
                                      value: widget.note.substring(
                                          0, widget.note.length - 11));
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: Edit(
                                            curkey: widget.curkey,
                                            note: widget.note + '|favourites'),
                                        type: PageTransitionType.fade,
                                        duration: Duration(milliseconds: 1500)),
                                  );
                                  await storage.write(
                                      key: widget.curkey.toString(),
                                      value: widget.note + '|favourites');
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              mode == 'preview'
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.black,
                        height: .075 * h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.post_add_sharp,
                                  color: Color(0xffdbddfa),
                                ),
                                splashRadius: 2,
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: Data(),
                                        type: PageTransitionType.fade,
                                        duration: Duration(milliseconds: 475)),
                                  );
                                }),
                            IconButton(
                                icon: Icon(
                                  Icons.copy_sharp,
                                  color: Color(0xffdbddfa),
                                ),
                                splashRadius: 2,
                                onPressed: () {
                                  FlutterClipboard.copy(
                                      widget.note.split('|')[0] +
                                          '\n' +
                                          '\n' +
                                          widget.note.split('|')[1]);
                                  Fluttertoast.showToast(
                                      msg: "Copied",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black54,
                                      textColor: Colors.white,
                                      fontSize: 13.0);
                                }),
                            IconButton(
                                icon: Icon(
                                  Icons.share_sharp,
                                  color: Color(0xffdbddfa),
                                ),
                                splashRadius: 2,
                                onPressed: () {
                                  Share.text(
                                      'Notes ${DateTime.now()}',
                                      widget.note.split('|')[0] +
                                          '\n' +
                                          '\n' +
                                          widget.note.split('|')[1],
                                      'text/plain');
                                }),
                            IconButton(
                                icon: Icon(
                                  Icons.delete_outline_sharp,
                                  color: Color(0xffdbddfa),
                                ),
                                splashRadius: 2,
                                onPressed: () async {
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
                                                  'Are you sure you want to delete this note?',
                                                  style: TextStyle(
                                                      color: Color(0xffdbddfa),
                                                      fontFamily: 'Overpass',
                                                      fontSize: w / 22.5),
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
                                                          await storage.delete(
                                                              key: widget.curkey
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
                                                                        800)),
                                                          );
                                                        },
                                                        child: Text(
                                                          'Delete',
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
                                        );
                                      });
                                }),
                          ],
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}

int kb = 0;

class Data extends StatefulWidget {
  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  @override
  void initState() {
    Timer(Duration(milliseconds: 480), () {
      setState(() {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(focusNode);
        });
      });
    });
    // TODO: implement initState
    super.initState();
  }

  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  FocusNode focusNode = FocusNode();
  String title = '';
  String data = '';
  String total = '';

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
          context,
          PageTransition(
              child: MyHomePage(),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 800)),
        );
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: MyHomePage(),
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 1000)),
                );
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                onPressed: () async {
                  Map<String, String> allValues = await storage.readAll();
                  if (allValues.length > 0 && title != '') {
                    curl++;
                    await storage.write(
                        key: curl.toString(),
                        value: title +
                            '|' +
                            data +
                            '|' +
                            DateTime.now().toString());
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: Edit(curkey: curl, note: total),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 1500)),
                    );
                  } else if (allValues.length == 0 && title != '') {
                    curl++;
                    await storage.write(
                        key: '0',
                        value: title +
                            '|' +
                            data +
                            '|' +
                            DateTime.now().toString());
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: Edit(curkey: 0, note: total),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 1500)),
                    );
                  } else if (title == '')
                    Fluttertoast.showToast(
                        msg: "Title is necessary sir!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black54,
                        textColor: Colors.white,
                        fontSize: 13.0);
                },
              )
            ],
          ),
          backgroundColor: Colors.black,
          body: Padding(
            padding: EdgeInsets.only(
                top: h / 24.6,
                right: w / 22.5,
                bottom: h / 11.531,
                left: w / 22.5),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xff101320),
                  border: Border.all(
                      color: Color(0xffdbddfa),
                      width: 0.5,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(w / 16.36))),
              child: Padding(
                padding: EdgeInsets.all(w / 22.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: h * .1,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Input title",
                          hintStyle: TextStyle(
                            fontSize: w / 15,
                            color: Color(0xffdbddfa).withOpacity(0.2),
                            fontFamily: 'Overpass',
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                            fontSize: w / 15,
                            color: Colors.white,
                            fontFamily: 'Overpass'),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: controller1,
                        onChanged: (String value) async {
                          setState(() {
                            title = value;
                            total = value +
                                '|' +
                                data +
                                '|' +
                                DateTime.now().toString();
                          });
                        },
                      ),
                    ),
                    Text(
                      DateTime.now().day.toString() +
                          ' ' +
                          months[
                              int.parse(DateTime.now().month.toString()) - 1] +
                          ' ' +
                          DateTime.now()
                              .year
                              .toString() /*+
                          ', ' +
                          current_Time.hour.toString() +
                          ':' +
                          current_Time.second.toString()*/
                          +
                          '  |  ' +
                          data.length.toString() +
                          ' words',
                      style: TextStyle(
                          color: Color(0xff80cbc4), fontFamily: 'Overpass'),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter your note here",
                          hintStyle: TextStyle(
                            fontSize: w / 20,
                            color: Color(0xffdbddfa).withOpacity(0.2),
                            fontFamily: 'Overpass',
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                            fontSize: w / 20,
                            color: Colors.white,
                            fontFamily: 'Overpass'),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        focusNode: focusNode,
                        controller: controller2,
                        onChanged: (String value) async {
                          setState(() {
                            data = value;
                            total = title +
                                '|' +
                                value +
                                '|' +
                                DateTime.now().toString();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
