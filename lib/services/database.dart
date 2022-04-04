import 'package:chat_app/screens/authentication_screen.dart';
import 'package:chat_app/screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Service {
  Service();
  var authOk = false;

  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DocumentReference docRef;

  var outputMessage =
      'An error occured while processing the request, please check your credentials';

  getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<Stream<QuerySnapshot>> showEmailUsers() async {
    return FirebaseFirestore.instance.collection("emailusers").snapshots();
  }

  Future<Stream<QuerySnapshot>> showPhoneUsers() async {
    return _firestore.collection("phoneUsers").snapshots();
  }

  void loginUser(ctx, email, password, username) async {
    try {
      authOk = true;
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((res) {
        Navigator.push(
          ctx,
          PageTransition(
            curve: Curves.linear,
            type: PageTransitionType.fade,
            child: const MainScreen(),
          ),
        );
      });
    } on FirebaseException catch (pe) {
      authOk = false;

      if (pe.message != null) {
        outputMessage = pe.message!;
      }

      showErrorMessage(ctx, outputMessage);
    } catch (e) {
      authOk = false;

      showErrorMessage(ctx, e);
    }
  }

  void signupUser(ctx, email, password, username) async {
    try {
      //authOk = true;
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((res) {
        Navigator.push(
          ctx,
          PageTransition(
            curve: Curves.linear,
            type: PageTransitionType.fade,
            child: const MainScreen(),
          ),
        );
      });
      //Storing User's username
      await _firestore
          .collection('emailusers')
          .doc(_auth.currentUser?.uid)
          .set({
        'username': username,
        'email': email,
        'imageUrl': '',
        'uid': _auth.currentUser!.uid,
        'status': 'Online'
      });
    } on FirebaseException catch (pe) {
      authOk = false;
      if (pe.message != null) {
        outputMessage = pe.message!;
      }

      showErrorMessage(ctx, outputMessage);
    } catch (e) {
      authOk = false;

      showErrorMessage(ctx, e);
    }
  }

  Future<void> signoutUser(ctx) async {
    try {
      await _auth.signOut().then((res) {
        Navigator.push(
          ctx,
          PageTransition(
            curve: Curves.linear,
            type: PageTransitionType.fade,
            child: Authentication(),
          ),
        );
      });
    } on FirebaseException catch (pe) {
      if (pe.message != null) {
        outputMessage = pe.message!;
      }

      showErrorMessage(ctx, outputMessage);
    } catch (e) {
      showErrorMessage(ctx, e);
    }
  }

  void showErrorMessage(ctx, outputMessage) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(outputMessage),
      backgroundColor: Colors.red,
    ));
  }

  String? getDocId() {
    var documentId = '';

    var snapshot = _firestore
        .collection("emailusers")
        .where('email', isEqualTo: getCurrentUser())
        .get()
        .then((QuerySnapshot snapshot) => {
              snapshot.docs.forEach((element) {
                documentId = element.id;
              })
            });

    return documentId;
  }

  void updateImage(ctx, imageUrl, bool isEmailUser) async {
    isEmailUser
        ? await _firestore
            .collection("emailusers")
            .doc(_auth.currentUser?.uid)
            .update({'imageUrl': imageUrl})
        : await _firestore
            .collection("phoneusers")
            .doc(_auth.currentUser?.uid)
            .update({'imageUrl': imageUrl});
  }

  void setUserStatus(String status, bool isEmailUser) async {
    isEmailUser
        ? await _firestore
            .collection("emailusers")
            .doc(_auth.currentUser?.uid)
            .update({'status': status})
        : await _firestore
            .collection("phoneusers")
            .doc(_auth.currentUser?.uid)
            .update({'status': status});
  }

  Future<bool> sendEmail(ctx, firstName, lastName, subject, concerns) async {
    try {
      await _firestore
          .collection('usersconcerns')
          .doc(_auth.currentUser?.uid)
          .set({
        'firstname': firstName,
        'lastname': lastName,
        'subject': subject,
        'concerns': concerns,
        'resolved': 'false'
      });
      return true;
    } on FirebaseException catch (pe) {
      authOk = false;
      if (pe.message != null) {
        outputMessage = pe.message!;
      }

      showErrorMessage(ctx, outputMessage);
      return false;
    } catch (e) {
      showErrorMessage(ctx, e);
      return false;
    }
  }

  Future<bool> sendRate(ctx, first, second, third, fourth, fifth) async {
    try {
      await _firestore
          .collection('appratings')
          .doc(_auth.currentUser?.uid)
          .set({
        'Was the app Responsive': first,
        'How well was messages online': second,
        'How well was messages offline': third,
        'Would you recommend this app?': fourth,
        'Overall Rate': fifth,
      });
      return true;
    } on FirebaseException catch (pe) {
      authOk = false;
      if (pe.message != null) {
        outputMessage = pe.message!;
      }

      showErrorMessage(ctx, outputMessage);
      return false;
    } catch (e) {
      showErrorMessage(ctx, e);
      return false;
    }
  }

  Future<bool> changePassword(currentPass, newPass) async {
    try {
      final thisUser = FirebaseAuth.instance.currentUser;
      final credential = EmailAuthProvider.credential(
        email: thisUser!.email as String,
        password: currentPass,
      );

      thisUser.reauthenticateWithCredential(credential).then((value) {
        thisUser.updatePassword(newPass).then((_) {
          return true;
        }).catchError((e) {
          return false;
        });
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
