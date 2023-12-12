import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? fullName;
  final String? photoUrl;
  final String? email;
  final String? createdAt;
  final String? lastLogin;
  final String? aboutMe;
  final String? googleId;
  final String? googleServerAuthCode;
  final String? platform;
  final String? provider;


  UserModel({
    this.id,
    this.fullName,
    this.photoUrl,
    this.email,
    this.createdAt,
    this.lastLogin,
    this.aboutMe,
    this.googleId,
    this.googleServerAuthCode,
    this.platform,
    this.provider,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nickname'] = fullName;
    data['photoUrl'] = photoUrl;
    data['email'] = email;
    data['createdAt'] = createdAt;
    data['lastLogin'] = lastLogin;
    data['aboutMe'] = aboutMe;
    data['googleId'] = googleId;
    data['googleServerAuthCode'] = googleServerAuthCode;
    data['platform'] = platform;
    data['provider'] = provider;
    return data;
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      id: doc.id,
      photoUrl: doc['photoUrl'],
      email: doc['email'],
      fullName: doc['nickname'],
      createdAt: doc['createdAt'],
      lastLogin: doc['lastLogin'],
      aboutMe: doc['aboutMe'],
      googleId: doc['googleId'],
      googleServerAuthCode: doc['googleServerAuthCode'],
      platform: doc['platform'],
      provider: doc['provider'],
    );
  }
}