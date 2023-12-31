class RegExpConstans {
  static RegExpConstans? _instance;
  static RegExpConstans? get instance {
    _instance ??= RegExpConstans._init();
    return _instance;
  }

  RegExpConstans._init();

  /// Sadece Küçük-Büyük [Harf] içerebilir
  final alpha = RegExp(r'^[A-Za-z]+$');

  /// Sadece Küçük-Büyük [Harf] içerebilir. Noktolama işaretleri içermez.
  final alphaAlternative = RegExp("[0-9a-zA-Z]");

  /// Sadece [Rakam] içerebilir
  final numeric = RegExp(r'^-?[0-9]+$');

  /// Sadece [Alfa Numerik] => Harf yada Rakam içerebilir
  final alphaNumeric = RegExp(r'^[a-zA-Z0-9]+$');

  /// Sadece [Harf ve Boşluk] içerebilir
  final nameExp = RegExp('.*[A-zöçğışü].');

  /// E-posta
  final emailExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  /// Cep Telefonu Numarası
  final phoneExp = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');

  ///(\+?( |-|\.)?\d{1,2}( |-|\.)?)?(\(?\d{3}\)?|\d{3})( |-|\.)?(\d{3}( |-|\.)?\d{4})
  /////  final phoneExp = RegExp(r'^\(\d\d\d\) \d\d\d\-\d\d\d\d$');
  final birthDate =
      RegExp(r'^([0-2][0-9]|(3)[0-1])(\/)(((0)[0-9])|((1)[0-2]))(\/)\d{4}$');
}
