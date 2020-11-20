import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_colorizer_app/enums/viewstate.dart';
import 'package:image_colorizer_app/view/image_colorizer_results.dart';
import 'package:image_colorizer_app/viewmodel/image_colorizer_viewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../locator.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageColorizerView extends StatefulWidget {
  @override
  ImageColorizerViewState createState() => ImageColorizerViewState();
}

class ImageColorizerViewState extends State<ImageColorizerView> {
  ImageColorizerViewModel model = locator<ImageColorizerViewModel>();
  File blackAndWhiteImage;
  var imagePicker = ImagePicker();
  int step;

  Future getImage() async {
    try {
      final pickedFile = await imagePicker.getImage(
          source: ImageSource.camera, imageQuality: 100);
      setState(() {
        blackAndWhiteImage = File(pickedFile.path);
        step++;
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> uploadImage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        blackAndWhiteImage = File(result.files.single.path);
        step++;
      });
    }
  }

  void submitImage() async {
    await model.setState(ViewState.Busy);
    Map<String, dynamic> map = {};
    var image = img.decodeImage(blackAndWhiteImage.readAsBytesSync());
    image = img.grayscale(image);
    String tempPath = (await getTemporaryDirectory()).path;
    File file = File('$tempPath/testing.jpg');
    await file.writeAsBytesSync(img.encodeJpg(image));
    map['image'] = file.path;
    var result = await model.postData(map);
    if (result == false) {
      await showToast('Process failed');
    } else {
      disposeImage();
      setState(() {
        step = 0;
      });
      await Navigator.push(context,
          MaterialPageRoute(builder: (context) => ImageColorizerResults()));
    }
  }

  void disposeImage() {
    blackAndWhiteImage = null;
  }

  Widget captureWidget() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: ScreenUtil().setHeight(30),
        ),
        Container(
          width: ScreenUtil().setWidth(312),
          height: ScreenUtil().setHeight(370),
          child: Center(
            child: Text('Capture Image'),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(20),
        ),
        Container(
            width: ScreenUtil().setWidth(312),
            height: ScreenUtil().setHeight(50),
            child: FlatButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                getImage();
              },
              child: Text(
                'Capture',
                style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        ScreenUtil().setSp(20, allowFontScalingSelf: true)),
              ),
            )),
        SizedBox(
          height: ScreenUtil().setHeight(20),
        ),
        Container(
            width: ScreenUtil().setWidth(312),
            height: ScreenUtil().setHeight(50),
            child: FlatButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                uploadImage();
              },
              child: Text(
                'Upload Image',
                style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        ScreenUtil().setSp(20, allowFontScalingSelf: true)),
              ),
            ))
      ],
    );
  }

  Widget retakeWidget() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: ScreenUtil().setHeight(30),
        ),
        Container(
          width: ScreenUtil().setWidth(312),
          height: ScreenUtil().setHeight(370),
          child: FittedBox(
            fit: blackAndWhiteImage != null ? BoxFit.fitWidth : BoxFit.none,
            child: blackAndWhiteImage != null
                ? Image.file(blackAndWhiteImage)
                : Text('Image not clicked'),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(50),
        ),
        Container(
            width: ScreenUtil().setWidth(312),
            height: ScreenUtil().setHeight(50),
            child: FlatButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                disposeImage();
                setState(() {
                  step--;
                });
              },
              child: Text(
                'Retake',
                style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        ScreenUtil().setSp(20, allowFontScalingSelf: true)),
              ),
            )),
        SizedBox(
          height: ScreenUtil().setHeight(20),
        ),
        Container(
            width: ScreenUtil().setWidth(312),
            height: ScreenUtil().setHeight(50),
            child: FlatButton(
              color: Theme.of(context).primaryColor,
              onPressed: submitImage,
              child: Text(
                'Submit',
                style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        ScreenUtil().setSp(20, allowFontScalingSelf: true)),
              ),
            ))
      ],
    );
  }

  Widget showWidget() {
    if (step == 0) {
      return captureWidget();
    } else {
      return retakeWidget();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    step = 0;
  }

  Future<bool> showToast(String toastMessage) {
    return Fluttertoast.showToast(
        msg: toastMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[500],
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ImageColorizerViewModel>.value(
      value: model,
      child: Consumer<ImageColorizerViewModel>(
          builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                title: Text(
                  'Image Colorizer App',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              body: model.state == ViewState.Busy
                  ? SafeArea(
                      child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircularProgressIndicator(
                                value: null,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(15),
                              ),
                              Text('Processing'),
                            ]),
                      ),
                    )
                  : SafeArea(
                      child: Center(
                          child: Padding(
                        padding: EdgeInsets.all(
                            ScreenUtil().setSp(10, allowFontScalingSelf: true)),
                        child: SingleChildScrollView(
                          child: showWidget(),
                        ),
                      )),
                    ))),
    );
  }
}
