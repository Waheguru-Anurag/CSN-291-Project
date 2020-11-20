import 'package:flutter/material.dart';
import 'package:image_colorizer_app/enums/viewstate.dart';
import 'package:image_colorizer_app/service/image_colorizer_service.dart';

import '../locator.dart';

class ImageColorizerViewModel extends ChangeNotifier {
  ImageColorizerService imageColorizerService =
      locator<ImageColorizerService>();
  ViewState _viewState = ViewState.Idle;
  String _errorMessage = '';

  ViewState get state => _viewState;
  String get errorMessage => _errorMessage;

  void setState(ViewState viewState) {
    _viewState = viewState;
    notifyListeners();
  }

  void setErrorMessage(String errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
  }

  Future postData(Map<String, dynamic> map) async {
    var result = await imageColorizerService.postData(map);
    if (result == false) {
      setState(ViewState.Error);
      setErrorMessage('Error');
      return false;
      // error;
    } else {
      setState(ViewState.Idle);
      return result;
    }
  }
}
