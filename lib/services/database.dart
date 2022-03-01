
// ignore_for_file: unnecessary_null_comparison

import 'package:chat_app/models/userModel.dart';
import 'package:chat_app/screens/authentication_screen.dart';
import 'package:chat_app/screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Service{

  Service();
  var authOk = false;

  final _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var outputMessage = 'An error occured while processing the request, please check your credentials';


  void loginUser(ctx, email, password, username) async {

    try{
      authOk = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password).then((res) {
        Navigator.push(
          ctx,
          PageTransition(
            curve: Curves.linear,
            type: PageTransitionType.fade,
            child: const MainScreen(),
          ),
        );
        
      });

    }on FirebaseException  catch(pe){
      authOk = false;

      if(pe.message != null){
        outputMessage = pe.message!;
      }
      
      showErrorMessage(ctx, outputMessage);

     } catch (e){
      authOk = false;

       showErrorMessage(ctx, e);
    }
  }

  void signupUser(ctx, email, password, username)async{
    try{
      //authOk = true;
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then((res) {
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
      await _firestore.collection('onlineusers').doc(_auth.currentUser?.uid).set({
        'username' : username,
        'email' : email,
      });
    }on FirebaseException  catch(pe){

      authOk = false;
      if(pe.message != null){
        outputMessage = pe.message!;
      }
      
      showErrorMessage(ctx, outputMessage);
     } catch (e){
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
    }on FirebaseException  catch(pe){

      if(pe.message != null){
        outputMessage = pe.message!;
      }
      
      showErrorMessage(ctx, outputMessage);
     } catch (e){
       showErrorMessage(ctx, e);
    }
  }

  // Future<UserModel> userInfo(String uid) async{
  //   UserModel user = UserModel();

  //   try {
  //     DocumentSnapshot _documentSnapshot = await _firestore.collection("onlineusers").doc(uid).get();
  //     //user = UserModel.fromDocumentSnapshot(doc: _documentSnapshot);    
  //     return user;

  //   } catch (e){
  //   }
    
  //   return user;
  // }

  void showErrorMessage(ctx, outputMessage){
    ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(outputMessage),
          backgroundColor: Colors.red,
        )
      );
  }

  

  
}