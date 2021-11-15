class AppAssets {
  AppAssets._();

  static const String _imagePath = "assets/images/";

  static String getImagePath(String imageName) {
    return _imagePath + imageName;
  }
}