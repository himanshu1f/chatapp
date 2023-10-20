import 'dart:convert';
import 'dart:developer';

import 'package:chat/Widgets/ProgressWidget.dart';
import 'package:chat/util/colors.dart';
import 'package:chat/utility/asset_path.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SSOLogin extends StatefulWidget {
  const SSOLogin({super.key});

  @override
  State<SSOLogin> createState() => _SSOLoginState();
}

class _SSOLoginState extends State<SSOLogin> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBg,
      body: GestureDetector(
        onTap: controlSignIn,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: isLoading ? circularProgress() : Container(),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(AssetPath().google, fit: BoxFit.fill, width: double.infinity, height: 80),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  controlSignIn() async {
    setState(() {
      isLoading = true;
    });


    setState(() {
      isLoading = false;
    });
  }




  Future<UserSSOResponseModel?> signInWithGoogle() async {
    String clientID = '217050266362-a3qcg8qjnak4jc36v5rs00lbit9mul7r.apps.googleusercontent.com';
    // clientID = Platfor mSpecificData.getClientID();

    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      clientId: clientID,
      scopes: [
        'email',
        'profile',
        'https://www.googleapis.com/auth/fitness.activity.read'
      ],
      serverClientId: Constants.serverGoogleClientID,
    ).signIn().onError((error, stackTrace) {
      log(error.toString());
    });
    // Obtain the auth details from the request

    try {
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
      // print('.toString()');
      if (googleAuth != null) {
        // print('.toString()');
        if (googleAuth.idToken != null) {
          return await userSSO(
            googleAuth.idToken!,
            GoogleAuthentication(),
            false,
          );
        }
      }
      return null;
    } catch (ex) {
      log("This is error $ex");
      rethrow;
    }
  }

  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = math.Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<UserSSOResponseModel?> signInWithApple() async {
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      String userName = '';
      if (appleCredential.identityToken != null) {
        if (appleCredential.givenName != null) {
          userName += appleCredential.givenName ?? '';
          userName += ' ';
        }
        if (appleCredential.familyName != null) {
          userName += appleCredential.familyName ?? '';
        }
        Constants.userName = userName;
        return await userSSO(
            appleCredential.identityToken!, AppleAuthentication(), false);
      }
      return null;
      // // print(appleCredential.identityToken);
      // final oauthCredential = OAuthProvider("apple.com").credential(
      //   idToken: appleCredential.identityToken,
      //   rawNonce: rawNonce,
      // );

      // final authResult = await auth.signInWithCredential(oauthCredential);
      // final User? firebaseUser = authResult.user;
      // if (firebaseUser != null) {
      //   if (appleCredential.givenName != null) {
      //     final displayName =
      //         '${appleCredential.givenName} ${appleCredential.familyName}';

      //     firebaseUser.updateDisplayName(displayName);
      //   }
      // }

      // return firebaseUser;
    } catch (exception) {
      return null;
    }
  }
}
