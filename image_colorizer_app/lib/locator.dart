import 'package:get_it/get_it.dart';
import 'package:image_colorizer_app/service/image_colorizer_service.dart';
import 'package:image_colorizer_app/viewmodel/image_colorizer_viewmodel.dart';

GetIt locator = GetIt.instance;
Future<void> setUpLocator() {
  locator.registerSingleton<ImageColorizerService>(ImageColorizerService());
  locator.registerFactory(() => ImageColorizerViewModel());
  return null;
}
