import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'data_list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await [
    Permission.storage,
    Permission.microphone,
  ].request();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xff41458d),
          selectionHandleColor: Color(0xff41458d),
        )
      ),
      home: DataList(),
    );
  }
}

