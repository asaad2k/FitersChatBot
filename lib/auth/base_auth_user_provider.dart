class AuthUserInfo {
  String? uid;
  String? email;
  String? displayName;
  String? photoUrl;
  String? phoneNumber;

  AuthUserInfo({
    this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
  });

  AuthUserInfo.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    displayName = json['name'];
  }

  Map<String, dynamic> toJson() => {
        'name': displayName,
        'email': email,
        'uid': uid,
      };
}

abstract class BaseAuthUser {
  bool get loggedIn;

  bool get emailVerified;

  AuthUserInfo get authUserInfo;

  Future? delete();

  Future? sendEmailVerification();

  String? get uid => authUserInfo.uid;

  String? get email => authUserInfo.email;

  String? get displayName => authUserInfo.displayName;

  String? get photoUrl => authUserInfo.photoUrl;

  String? get phoneNumber => authUserInfo.phoneNumber;
}

BaseAuthUser? currentUser;

bool get loggedIn => currentUser?.loggedIn ?? false;
