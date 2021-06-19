import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_tts_improved/flutter_tts_improved.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import 'data_list.dart';

// ignore: must_be_immutable
class DataSheet extends StatefulWidget {
  String heading;
  String detail;
  int index;
  Data data;
  DataSheet({this.data, this.index, this.heading, this.detail});

  @override
  _DataSheetState createState() => _DataSheetState();
}

class _DataSheetState extends State<DataSheet> {

  final headingController = TextEditingController();
  final detailController = TextEditingController();

  FlutterTtsImproved tts = new FlutterTtsImproved();

  bool _hasSpeech = false;
  String lastWords = "";
  final SpeechToText speech = SpeechToText();

  setDataSheet() async {
    headingController.text = widget.heading;
    detailController.text = widget.detail;
  }

  @override
  void initState() {
    setDataSheet();
    initSpeechState();
    // TODO: implement initState
    super.initState();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize();

    if (!mounted) return;
    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  var detailIns;
  void startListening() {
    detailIns = detailController.text;
    lastWords = "";
    speech.listen(onResult: resultListener);
    setState(() {});
  }

  void stopListening() {
    speech.stop( );
  }

  Future<void> resultListener(SpeechRecognitionResult result) async {
    setState(() {
      lastWords = result.recognizedWords;
      print(lastWords);
    });

    if(result.finalResult == true) {
      widget.data.updateInStorage(widget.index, headingController.text, detailController.text);
      setState(() {
        detailIns = null;
      });
    }
    else {
      setState(() {
        if(detailIns == '') {
          detailController.text = detailIns + lastWords;
        }
        else {
          detailController.text = detailIns + ' ' + lastWords;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xff41458d),
      body: Container(
        height: h,
        width: w * .97,
        margin: EdgeInsets.all(w / 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: w * .97,
              height: h * .1,
              child: Center(
                child: Text(
                  'NOTE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w / 15,
                    letterSpacing: w / 180,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RobotoMono',
                  ),
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxHeight: h * .1175,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(w / 20), topRight: Radius.circular(w / 20)),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(w / 45),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Your Heading',
                    hintStyle: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: w / 15,
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontFamily: 'RobotoMono',
                    fontSize: w / 15,
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: headingController,
                  onChanged: (String value) {
                    widget.data.updateInStorage(widget.index, value, detailController.text);
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(18.0), bottomRight: Radius.circular(18.0)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(w / 45),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Type your note here...",
                      hintStyle: TextStyle(
                        fontFamily: 'RobotoMono',
                        fontSize: w / 20,
                      ),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: w / 20,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: detailController,
                    onChanged: (String value) {
                      widget.data.updateInStorage(widget.index, headingController.text, value);
                    },
                  ),
                ),
              ),
            ),
            Container(
              height: h * .1,
              width: w * .97,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.speaker_notes_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      Fluttertoast.showToast(
                          msg: "Starts speaking",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black54,
                          textColor: Colors.white,
                          fontSize: 13.0);
                      await tts.speak(detailController.text.trim());
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.copy_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      FlutterClipboard.copy(headingController.text + '\n' + '\n' + detailController.text);
                      Fluttertoast.showToast(
                          msg: "Copied",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black54,
                          textColor: Colors.white,
                          fontSize: 13.0);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.mic_none_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        Fluttertoast.showToast(
                            msg: "Go ahead, I'm listening",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black54,
                            textColor: Colors.white,
                            fontSize: 13.0);
                        startListening();
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.share_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Share.text('Secure Notes ${DateTime.now()}', headingController.text + '\n' + '\n' + detailController.text, 'text/plain');
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Fluttertoast.showToast(
                          msg: "Deleted",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black54,
                          textColor: Colors.white,
                          fontSize: 13.0);
                      widget.data.updateInStorage(widget.index, '**deleted**' + widget.data.headings[widget.index], widget.data.details[widget.index]);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
