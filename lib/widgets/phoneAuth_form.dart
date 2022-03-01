import 'dart:async';

import 'package:chat_app/screens/authentication_screen.dart';
import 'package:chat_app/screens/main_screen.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:page_transition/page_transition.dart';



class PhoneAuthForm extends StatefulWidget {
  PhoneAuthForm(this.proccessingAuth);
  bool proccessingAuth;

  @override
  _PhoneAuthFormState createState() => _PhoneAuthFormState();
}

class _PhoneAuthFormState extends State<PhoneAuthForm> {
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
    var _isLogin = false;
    final _formkey = GlobalKey<FormState>();
    final _formkeyOTP = GlobalKey<FormState>();
    var _OTPFormCode = '';
    var _sentCode = '';

    bool _isResendAgain = false;
    bool _isVerified = false;
    bool _isLoading = false;
    bool _isOTPScreen = false;


    late Timer _timer;
    int _start = 60;
    int _currentIndex = 0;
    


    PhoneNumber _userPhoneNumber = PhoneNumber(countryISOCode: 'CA', countryCode: '+1', number: '1234567890');

    


    void resend(){
      setState(() {
        _isResendAgain = true;
      });
      const sec = Duration(seconds: 1);
      _timer = Timer.periodic(sec, (timer) { 
        setState(() {
          if(_start == 0){
            _start = 60;
            _isResendAgain = false;
            timer.cancel();
          }else{
            _start--;
          }
        });
      });
    }


  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
  
    ScreenLogo sl = ScreenLogo(screenWidth, screenHeight, false);
    Service s = new Service();
    
    return _isOTPScreen ? OTPForm(context,  sl, s) : RegisterSignupSCreen(context, s, sl);
    
  }

  Widget RegisterSignupSCreen(BuildContext context, Service s, ScreenLogo sl){
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                FadeInUp(
                  delay: Duration(milliseconds: 500),
                  duration: Duration(milliseconds: 500),
                  child: sl.logoImage(context),
                ),
                const SizedBox(height: 10,),
                FadeInUp(
                  delay: Duration(milliseconds: 500),
                  duration: Duration(milliseconds: 500),
                  child: Text(_isLogin ? 'SIGN IN' : 'REGISTER', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                ),
                SizedBox(height: 10.0,),
                 FadeInUp(
                  delay: Duration(milliseconds: 500),
                  duration: Duration(milliseconds: 500),
                  child: Text(!_isLogin ? "Enter your phone number,\nyou'll receive a 6-digit code to verify." : '', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300), textAlign: TextAlign.center,),
                 ),

                FadeInUp(
                  delay: Duration(milliseconds: 500),
                  duration: Duration(milliseconds: 500), 
                  child: Form(
                  key: _formkey,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 20.0,),
                        IntlPhoneField(
                          decoration: InputDecoration(
                            hintText: "Phone Number",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          initialCountryCode: 'CA',
                          onChanged: (phone) {
                                _userPhoneNumber = phone;
                              },
                        ),
                        SizedBox(height: 20.0,),
                        Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: ButtonTheme(
                              minWidth: 200,
                              height: 45,
                              child: MaterialButton(
                                elevation: 0,
                                onPressed: () async {

                                  if(_isLogin){
                                    setState(() {
                                      _isOTPScreen = true;
                                     });

                                     if(_formkey.currentState!.validate()) {
                                      await signinUserWithPhone();
                                     }
                                  }else{
                                    setState(() {
                                      sigupUserWithPhone();
                                      _isOTPScreen = true;
                                  });
                                  }
                                  
                                },
                                color: Theme.of(context).colorScheme.primary,
                                child: Text(_isLogin ? 'Sign In' : "Request OTP", style: TextStyle(color:  Colors.white, fontSize: 13),),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(color: Color.fromRGBO(255, 255, 0, 0.5)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 120,),
                        
                        Container(
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text("Switch back to Online", style: TextStyle(fontSize: 12), textAlign: TextAlign.center,),
                                  SizedBox(height: 5,),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    child: ButtonTheme(
                                      minWidth: 150,
                                      height: 45,
                                      child: MaterialButton(
                                        elevation: 0,
                                        onPressed: () {
                                          Navigator.push(
                                          context,
                                          PageTransition(
                                            curve: Curves.linear,
                                            type: PageTransitionType.fade,
                                            child: Authentication(),
                                            ),
                                          );
                                        },
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                        child: Text("Online", style: TextStyle(color: Colors.black, fontSize: 18),),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                          side: BorderSide(color: Color.fromRGBO(255, 255, 0, 100)),
                                        ),
                                      ),
                                    )
                                  ),
                                ],
                              ),
                              SizedBox(width: 30,),
                              Column(
                                children: [
                                  Text(_isLogin ? 'No Account?' : "Already have an account?", style: TextStyle(fontSize: 12), textAlign: TextAlign.center,),
                                  SizedBox(height: 5,),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    child: ButtonTheme(
                                      minWidth: 150,
                                      height: 45,
                                      child: MaterialButton(
                                        elevation: 0,
                                        onPressed: () {
                                          setState(() {
                                            _isLogin = !_isLogin;
                                          });
                                          
                                        },
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                        child: Text(_isLogin ? 'Sign up' : "Sign In", style: TextStyle(color: Colors.black, fontSize: 18),),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                          side: BorderSide(color: Color.fromRGBO(255, 255, 0, 100)),
                                        ),
                                      ),
                                    )
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget OTPForm(BuildContext context, ScreenLogo sl, Service s){
    
    final node = FocusScope.of(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: [
                sl.logoImage(context), 
                Text("VERIFICATION", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                SizedBox(height: 10.0,),
                Text('Please enter the 6-digit code sent to\n' + _userPhoneNumber.completeNumber, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300), textAlign: TextAlign.center,),
                SizedBox(height: 40.0,),
                Form(
                  key: _formkeyOTP,
                  child: FadeInDown(
                    delay: Duration(milliseconds: 500),
                    duration: Duration(milliseconds: 500),
                    child: VerificationCode(
                      length: 6,
                      underlineColor: Colors.black,
                      keyboardType: TextInputType.number,
                      textStyle: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
                      onCompleted: (value){
                        setState(() {
                          _OTPFormCode = value;
                        });
                      },
                      onEditing: (value){

                      },
                    ),
                  ),
                ), 
                SizedBox(height: 50.0,),
                FadeInDown(
                   delay: Duration(milliseconds: 500),
                  duration: Duration(milliseconds: 500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Didn\'t received?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300), textAlign: TextAlign.center,),
                      TextButton(
                        onPressed: () async{
                          if(_isResendAgain) return;
                          resend();
                          await sigupUserWithPhone();
                        },
                        child: Text(_isResendAgain ? "Try again in " + _start.toString() : 'Resend', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueAccent,)),
                      ),
                    ],           
                  )
                ),
                SizedBox(height: 50.0,),
                FadeInDown(
                  delay: Duration(milliseconds: 500),
                  duration: Duration(milliseconds: 500),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: ButtonTheme(
                      minWidth: 250,
                      height: 45,
                      child: MaterialButton(
                        elevation: 0,
                        onPressed: () async{
                          if (_formkeyOTP.currentState!.validate()){
                            setState(() {
                              _isResendAgain = false;
                            });
                            try{
                              await _auth.signInWithCredential(PhoneAuthProvider.credential(
                                verificationId: _sentCode,
                                smsCode: _OTPFormCode.toString(),
                                ),
                              ).then((value) async => {
                                if (value != null){
                                  await _firestore
                                      .collection('offlineusers')
                                      .doc(
                                          _auth.currentUser!.uid)
                                      .set(
                                          {
                                        'phonenumber':
                                            _userPhoneNumber.completeNumber.trim()
                                      },
                                      SetOptions(
                                        merge: true)).then((value) => {
                                          setState(() {
                                            _isResendAgain = false;
                                          })
                                        }),

                                  setState(() {
                                    _isResendAgain = false;
                                  }),
                                  Navigator.push(
                                  context,
                                  PageTransition(
                                    curve: Curves.linear,
                                    type: PageTransitionType.fade,
                                    child: MainScreen(),
                                    ),
                                  )
                                }
                              });
                            }catch (e){
                              s.showErrorMessage(context, e.toString());
                            }
                          }
                          
                        },
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                        child: Text("Verify", style: TextStyle(color: Colors.black, fontSize: 18),),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Color.fromRGBO(255, 255, 0, 100)),
                        ),
                      ),
                    )
                  ),
                ),        
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signinUserWithPhone() async {
    var isValidUser = false;
    Service s = new Service();
    var outputMessage = 'An error occured while processing the request, please check your credentials';

    try{
      await _auth.verifyPhoneNumber(
        phoneNumber: _userPhoneNumber.completeNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {

          UserCredential result = await _auth.signInWithCredential(credential);
          User? user = result.user;

          if(user != null){
            Navigator.push(
                  context,
                  PageTransition(
                    curve: Curves.linear,
                    type: PageTransitionType.fade,
                    child: const MainScreen(),
                  ),
                );
          }

        //  await _auth.signInWithCredential(credential).then((user) async => {
        //       await _firestore.collection('offlineusers').doc(_auth.currentUser?.uid).set({
        //           'phonenumber' : _userPhoneNumber.completeNumber,
        //         }),
        //         Navigator.push(
        //           context,
        //           PageTransition(
        //             curve: Curves.linear,
        //             type: PageTransitionType.fade,
        //             child: const MainScreen(),
        //           ),
        //         )
              
        //     });
        }, 
        verificationFailed: (FirebaseAuthException exception) {
          s.showErrorMessage(context, exception.message); 
        },  
        codeSent: (verificationID, [foreResendingToken]) {
          _sentCode = verificationID;
        }, 
        codeAutoRetrievalTimeout:  (String verificationId){
          _sentCode = verificationId;
        });
    }on FirebaseException catch(pe){
      if(pe.message != null){
        outputMessage = pe.message!;
      }
      
      s.showErrorMessage(context, outputMessage);

     } catch (e){
       s.showErrorMessage(context, e);
    }
    
  }

  Future sigupUserWithPhone() async{
    Service s = new Service();
    var outputMessage = 'An error occured while processing the request, please check your credentials';

    try{
      await _auth.verifyPhoneNumber(
        phoneNumber: _userPhoneNumber.completeNumber, 
        verificationCompleted: (PhoneAuthCredential crediential){
            _auth.signInWithCredential(crediential).then((user) async => {
              if(user != null){
                await _firestore.collection('offlineusers').doc(_auth.currentUser?.uid).set({
                  'phonenumber' : _userPhoneNumber.completeNumber,
                }, SetOptions(merge: true)).then((value) => {
                  setState(() {
                    _isOTPScreen = false;
                  }),
                  Navigator.push(
                  context,
                  PageTransition(
                    curve: Curves.linear,
                    type: PageTransitionType.fade,
                    child: const MainScreen(),
                  ),
                )
                }),
                
              }else{
                s.showErrorMessage(context, outputMessage)
              }
              
            });
        }, 
        verificationFailed: (FirebaseAuthException exception) {
          s.showErrorMessage(context, exception.message); 
        }, 
        codeSent: (verificationID, [foreResendingToken]) {
          _sentCode = verificationID;
        }, 
        codeAutoRetrievalTimeout:  (String verificationId){
          _sentCode = verificationId;
        });

    }on FirebaseException  catch(pe){
      if(pe.message != null){
        outputMessage = pe.message!;
      }
      
      s.showErrorMessage(context, outputMessage);

     } catch (e){
       s.showErrorMessage(context, e);
    }
  }
}

