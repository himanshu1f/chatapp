import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? nickname;
  final String? photoUrl;
  final String? createdAt;
  final String? aboutMe;


  UserModel({
    this.id,
    this.nickname,
    this.photoUrl,
    this.createdAt,
    this.aboutMe,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      id: doc.id,
      photoUrl: doc['photoUrl'],
      nickname: doc['nickname'],
      createdAt: doc['createdAt'],
      aboutMe: doc['aboutMe'],
    );
  }
}