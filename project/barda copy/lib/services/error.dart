class LoginError {
  static String getErrorMessage(int errorcode) {
    if (errorcode == 404) {
      return 'User doesn\'t exist';
    } else {
      print(errorcode);
      return 'Unidentified server error. Please check console.';
    }
  }
}
