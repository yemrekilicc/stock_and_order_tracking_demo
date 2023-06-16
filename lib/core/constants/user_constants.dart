class UserConstants {
  static UserConstants? _instace;
  static UserConstants? get instance {
    _instace ??= UserConstants._init();

    return _instace;
  }

  UserConstants._init();

  int userId = 0;
  String name = "";
  String username = "";
}
