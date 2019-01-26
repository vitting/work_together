class ValidatorHelper {
  static String isPassword(String value) {
    String returnValue;
    if (value.trim().isEmpty) {
      returnValue = "Udfyld kodeord";
    } else if (value.trim().length < 6) {
      returnValue = "Kodeordet skal være på mindst 6 tegn";
    } else if (value.trim().contains(" ")) {
      returnValue = "Kodeordet må ikke indeholde mellemrum";
    }

    return returnValue;
  }
}
