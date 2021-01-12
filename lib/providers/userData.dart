class UserData {
  final String _id;
  final String _userName;
  final String _userEmail;
  final String _userPhone;
  static String _copyId;
  static String _copyUserName;
  static String _copyUserEmail;
  static String _copyUserPhone;
  UserData(
    this._id,
    this._userName,
    this._userEmail,
    this._userPhone,
  ) {
    _copyId = _id;
    _copyUserName = _userName;
    _copyUserEmail = _userEmail;
    _copyUserPhone = _userPhone;
  }
  static String getUserName() {
    return _copyUserName;
  }

  static String getUserEmail() {
    return _copyUserEmail;
  }

  static String getUserPhone() {
    return _copyUserPhone;
  }

  static String getUserId() {
    return _copyId;
  }
}
