import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_store/json_store.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data_sheet.dart';

class Data{
  Map<int, String> headings = new Map();
  Map<int, String> details = new Map();

  var path;
  File file;
  Map<String, dynamic> json;
  JsonStore jsonStore;
  storageReference(jsonRef, jsonStoreRef) async {
    json = jsonRef;
    jsonStore = jsonStoreRef;

    path = Directory('/storage/emulated/0/Secure Notes');
    var status = await Permission.storage.status;
    if(!status.isGranted)
      await Permission.storage.request();
    if(!await path.exists())
      await path.create(recursive: true);
    file = File('/storage/emulated/0/Secure Notes/notes.csv');
  }

  updateInStorage(index, heading, detail) async {
    headings[index] = heading;
    details[index] = detail;
    json[index.toString()] = {'heading': heading, 'detail': detail};
    jsonStore.setItem('secure_notes', json);

    List<List<dynamic>> rows = [];
    for(int i = 0;i < headings.length; i++) {
      if(headings[i].startsWith('**deleted**')
          || (headings[i] == '' && details[i] == ''))
        continue;
      rows.add([headings[i], details[i]]);
    }

    String csv = ListToCsvConverter().convert(rows);
    await file.writeAsString(csv);
  }
}

class DataList extends StatefulWidget {
  @override
  _DataListState createState() => _DataListState();
}

class _DataListState extends State<DataList> {

  final searchController = TextEditingController();
  JsonStore jsonStore = JsonStore();
  Map<String, dynamic> json;
  Data data = Data();
  getAllDataHeadings() async {
    json = await jsonStore.getItem('secure_notes');
    if(json != null) {
      for(var i in json.entries) {
        setState(() {
          data.headings[int.parse(i.key)] = i.value['heading'];
          data.details[int.parse(i.key)] = i.value['detail'];
          print(i.key);
          print(i.value);
        });
      }
    } else {
      json = new Map();
    }

    data.storageReference(json, jsonStore);
  }

  clearDatabase() async {
    jsonStore.clearDataBase();
  }

  @override
  void initState() {
    // clearDatabase();
    getAllDataHeadings();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff41458d),
        elevation: 0.0,
        title: Center(
            child: Text(
                'SECURE NOTES',
              style: GoogleFonts.montserrat(
                  color: Colors.white
              ),
            )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.post_add),
        backgroundColor: Color(0xff41458d),
        onPressed: () {
          print(data.headings.length);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DataSheet(
                    data: data,
                    index: data.headings.length,
                    heading: '',
                    detail: '',
                  )
              )
          );
        },
      ),
      body: Column(
        children: [
          Container(
            width: w,
            height: h * .125,
            decoration: BoxDecoration(
              color: Color(0xff41458d),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(w / 12), bottomRight: Radius.circular(w / 12))
            ),
            child: Column(
              children: [
                Text(
                  '( a highly secured note storage )',
                  style: GoogleFonts.montserrat(
                    color: Colors.white
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(w / 30),
                  height: h * .066,
                  child: Theme(
                    data: ThemeData(
                      primaryColor: Colors.white,
                      textSelectionTheme: TextSelectionThemeData(
                        cursorColor: Colors.white,
                        selectionHandleColor: Colors.white,
                      )
                    ),
                    child: TextField(
                      controller: searchController,
                      style: GoogleFonts.montserrat(
                          color: Colors.white
                      ),
                      decoration: InputDecoration(
                        labelText: 'search',
                        labelStyle: GoogleFonts.montserrat(
                          color: Colors.white
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(w / 12)),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.all(w / 45),
                itemCount: data.headings.length,
                itemBuilder: (BuildContext context, int index) {
                  if((data.headings[index].startsWith('**deleted**') && !searchController.text.trim().startsWith('**deleted**'))
                      || (data.headings[index] == '' && data.details[index] == '' && !searchController.text.trim().startsWith('**empty**'))
                          || (searchController.text.trim() != '' && !data.headings[index].toLowerCase().contains(searchController.text.replaceFirst('**deleted**', '').replaceFirst('**empty**', '').toLowerCase().trim()))) {
                    return Container();
                  }

                  return Container(
                    margin: EdgeInsets.all(w / 90),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff41458d), width: w / 180),
                      borderRadius: BorderRadius.all(Radius.circular(w / 22.5))
                    ),
                    child: ListTile(
                      title: Text(
                          data.headings[index],
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                          ),
                      ),
                      subtitle: Text(
                          data.details[index],
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold
                          ),
                      ),
                      dense: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(w / 22.5))
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DataSheet(
                                  data: data,
                                  index: index,
                                  heading: data.headings[index],
                                  detail: data.details[index],
                                )
                            )
                        );
                      },
                      onLongPress: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return Container(
                              margin: EdgeInsets.all(w / 30),
                              height: h * .125,
                              width: w * .8,
                              decoration: BoxDecoration(
                                color: Color(0xff41458d),
                                borderRadius: BorderRadius.all(Radius.circular(w / 20))
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.share_outlined,
                                        ),
                                        onPressed: () {
                                          Share.text('Secure Notes ${DateTime.now()}', data.headings[index] + '\n' + '\n' + data.details[index], 'text/plain');
                                          Navigator.pop(context);
                                        },
                                      ),
                                      Text(
                                        'share',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_forever_outlined,
                                        ),
                                        onPressed: () {
                                          data.updateInStorage(index, '**deleted**' + data.headings[index], data.details[index]);
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                      ),
                                      Text(
                                        'delete',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          }
                        );
                      },
                    ),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}
