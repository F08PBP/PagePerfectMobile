class UserData {
  bool isLoggedIn;
  String username;
  int money;

  UserData({required this.isLoggedIn, required this.username, required this.money});
}

UserData loggedInUser = UserData(isLoggedIn: false, username: "Guest", money: 0);