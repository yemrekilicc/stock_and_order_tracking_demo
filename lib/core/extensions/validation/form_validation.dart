import '../../constants/regexp_constants.dart';

extension StringValidatorExtensions on String {
  bool get isValidAlpha => RegExpConstans.instance!.alpha.hasMatch(this);
  bool get isValidNumeric => RegExpConstans.instance!.numeric.hasMatch(this);
  bool get isValidAlphaNumeric =>
      RegExpConstans.instance!.alphaNumeric.hasMatch(this);
  bool get isValidAlphaAlternative =>
      RegExpConstans.instance!.alphaAlternative.hasMatch(this);
  bool get isValidName => RegExpConstans.instance!.nameExp.hasMatch(this);
  bool get isValidEmail => RegExpConstans.instance!.emailExp.hasMatch(this);
  bool get isValidPhoneNumber =>
      RegExpConstans.instance!.phoneExp.hasMatch(this);
  bool get isValidBirthDate =>
      RegExpConstans.instance!.birthDate.hasMatch(this);

  ///  Adı soyadı giriş alanı için [Onaylama] kontrolü
  String? validateNameAndSurname(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen isim alanını doldurun.';
      //
    }
    if (value.length < 2 || value.length > 50 || !value.isValidName) {
      return 'Soyadınız 3-50 karakter olabilir. Adınız a-z ve boşluk içerebilir.';
    }
    return null;
  }

  ///  Boşluk kontrolü sadece
  String? emptyIs(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen alanı doldurun.';
      //
    }
    return null;
  }

  ///  Boşluk kontrolü sadece
  String? validateTcNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen alanı doldurun.';
      //
    }
    if (value.length < 11) {
      return 'Lütfen alanı doldurun.';
    }
    return null;
  }

  ///  E-posta giriş alanı için [Onaylama] kontrolü
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen e-posta adresi alanını doldurun.';
      //
    }
    if (!value.isValidEmail) {
      return 'Lütfen doğru bir eposta adresi yazınız.';
      //Lütfen e-postanı dikkatlice kontrol et.
      // Lütfen e-posta adresine bir "@" işareti ekleyin. "$_email" adresinde "@" eksik.
    }
    return null;
  }

  ///  Telefon giriş alanı için [Onaylama] kontrolü
  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen cep telefonu alanını doldurun.';
    }
    if (value.length < 17) {
      return 'Lütfen cep telefonu alanını doldurun.';
    }
    return null;
  }

  ///  Doğum Tarihi giriş alanı için [Onaylama] kontrolü
  String? validateBirthDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen doğum tarihi alanını doldurun.';
      //
    }
    if (!value.isValidBirthDate) {
      return 'Lütfen doğru bir doğum tarihi yazınız.';
    }
    return null;
  }

  /// Şifre giriş alanı için [Onaylama] kontrolü
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen şifre alanını doldurun.';
      //
    }
    if (value.length < 6 || value.length > 20) {
      return 'Şifreniz en az 6, en fazla 20 karakter olabilir.';
    }
    if (!value.isValidAlphaNumeric) {
      return 'Şifreniz sadece harf(Türkçe hariç) ve rakam içerebilir.';
    }
    return null;
  }

  String? validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen yıl alanını doldurun.';
      //
    }
    if (value.length != 4) {
      return 'Şifreniz en az 6, en fazla 20 karakter olabilir.';
    }
    return null;
  }

  String? validateReTypePassword(String? confirmPassword, String? password) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Lütfen şifre alanını doldurun.';
      //
    }
    if (confirmPassword.length < 6 || confirmPassword.length > 20) {
      return 'Şifreniz en az 6, en fazla 20 karakter olabilir.';
    }
    if (!confirmPassword.isValidAlphaNumeric) {
      return 'Şifreniz sadece harf(Türkçe hariç) ve rakam içerebilir.';
    }
    if (password != confirmPassword) {
      return 'Şifreler eşleşmiyor';
    }
    return null;
  }

  ///  Null yada Boş mu?
  String? validateEmptyOrNull(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen bu boş alanı doldurun.';
    } else {
      return null;
    }
  }
}
