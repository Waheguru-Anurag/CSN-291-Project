import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_colorizer_app/view/image_colorizer_results.dart';
import 'package:image_colorizer_app/view/image_colorizer_view.dart';

import 'locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );

  await setUpLocator();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(GetMaterialApp(
            home: MyApp(),
          )));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Color(0x2980B9).withOpacity(1), //or set color with: Color(0xFF0000FF)
    ));
    ScreenUtil.init(context, width: 360, height: 746, allowFontScaling: true);
    return MaterialApp(
      title: 'AQI Survey App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: ImageColorizerView(),
    );
  }
}
