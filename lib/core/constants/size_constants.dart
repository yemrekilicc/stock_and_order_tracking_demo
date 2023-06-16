class SizeConstant{

  static SizeConstant? _instance;
  static SizeConstant? get instance {
    _instance ??= SizeConstant._init();
    return _instance;
  }
  SizeConstant._init();

  final double wideScreenWidth = 800;
  final double veryWideScreenWidth=1200;

}