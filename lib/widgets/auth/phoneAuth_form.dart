// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison

import 'dart:async';

import 'package:chat_app/screens/authentication_screen.dart';
import 'package:chat_app/screens/main_screen.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/common/logo.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:page_transition/page_transition.dart';

class PhoneAuthForm extends StatefulWidget {
  PhoneAuthForm(this.proccessingAuth, {Key? key}) : super(key: key);
  bool proccessingAuth;

  @override
  _PhoneAuthFormState createState() => _PhoneAuthFormState();
}

class _PhoneAuthFormState extends State<PhoneAuthForm> {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var _isLogin = false;
  final _formkey = GlobalKey<FormState>();
  final _formkeyOTP = GlobalKey<FormState>();
  var _OTPFormCode = '';
  var _sentCode = '';

  bool _isResendAgain = false;
  bool _isOTPScreen = false;

  late Timer _timer;
  int _start = 60;

  final TextEditingController _usernameController = TextEditingController();

  PhoneNumber _userPhoneNumber = PhoneNumber(
      countryISOCode: 'CA', countryCode: '+1', number: '1234567890');

  void resend() {
    setState(() {
      _isResendAgain = true;
    });
    const sec = Duration(seconds: 1);
    _timer = Timer.periodic(sec, (timer) {
      setState(() {
        if (_start == 0) {
          _start = 60;
          _isResendAgain = false;
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Service s = Service();

    return _isOTPScreen
        ? OTPForm(context, s)
        : RegisterSignupSCreen(context, s);
  }

  Widget RegisterSignupSCreen(BuildContext context, Service s) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  duration: const Duration(milliseconds: 500),
                  child: ScreenLogo(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      isSetting: false),
                ),
                const SizedBox(
                  height: 10,
                ),
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    _isLogin ? 'SIGN IN' : 'REGISTER',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    !_isLogin
                        ? "Enter your phone number,\nyou'll receive a 6-digit code to verify."
                        : '',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ),
                ),
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  duration: const Duration(milliseconds: 500),
                  child: Form(
                    key: _formkey,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          if (!_isLogin)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: TextFormField(
                                key: const ValueKey("username"),
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 4) {
                                    return 'Please enter at least 4 characters';
                                  }
                                  return null;
                                },
                                controller: _usernameController,
                                onSaved: (value) {
                                  _usernameController.text = value!;
                                },
                                keyboardType: TextInputType.text,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: "Username",
                                  contentPadding: const EdgeInsets.all(15.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade200, width: 2),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          IntlPhoneField(
                            decoration: InputDecoration(
                              hintText: "Phone Number",
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            initialCountryCode: 'CA',
                            onChanged: (phone) {
                              _userPhoneNumber = phone;
                            },
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: ButtonTheme(
                              minWidth: 200,
                              height: 45,
                              child: MaterialButton(
                                elevation: 0,
                                onPressed: () async {
                                  if (_isLogin) {
                                    setState(() {
                                      _isOTPScreen = true;
                                    });

                                    if (_formkey.currentState!.validate()) {
                                      await signinUserWithPhone();
                                    }
                                  } else {
                                    setState(() {
                                      sigupUserWithPhone();
                                      _isOTPScreen = true;
                                    });
                                  }
                                },
                                color: Theme.of(context).colorScheme.primary,
                                child: Text(
                                  _isLogin ? 'Sign In' : "Request OTP",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                      color: Color.fromRGBO(255, 255, 0, 0.5)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: _isLogin ? 122 : 55,
                          ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    "Use Email",
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
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
                                                child: const Authentication(),
                                              ),
                                            );
                                          },
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.5),
                                          child: Row(
                                            children: const [
                                              Icon(Icons.email),
                                              SizedBox(
                                                width: 5.0,
                                              ),
                                              Text(
                                                "Email",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            side: const BorderSide(
                                                color: Color.fromRGBO(
                                                    255, 255, 0, 100)),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Column(
                                children: [
                                  Text(
                                    _isLogin
                                        ? 'No Account?'
                                        : "Already have an account?",
                                    style: const TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.5),
                                          child: Text(
                                            _isLogin ? 'Sign up' : "Sign In",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            side: const BorderSide(
                                                color: Color.fromRGBO(
                                                    255, 255, 0, 100)),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ],
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

  Widget OTPForm(BuildContext context, Service s) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                ScreenLogo(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    isSetting: false),
                const Text(
                  "VERIFICATION",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Please enter the 6-digit code sent to\n' +
                      _userPhoneNumber.completeNumber,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Form(
                  key: _formkeyOTP,
                  child: FadeInDown(
                    delay: const Duration(milliseconds: 500),
                    duration: const Duration(milliseconds: 500),
                    child: VerificationCode(
                      length: 6,
                      underlineColor: Colors.black,
                      keyboardType: TextInputType.number,
                      textStyle: const TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      onCompleted: (value) {
                        setState(() {
                          _OTPFormCode = value;
                        });
                      },
                      onEditing: (value) {},
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                FadeInDown(
                    delay: const Duration(milliseconds: 500),
                    duration: const Duration(milliseconds: 500),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Didn\'t received?',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: () async {
                            if (_isResendAgain) return;
                            resend();
                            await sigupUserWithPhone();
                          },
                          child: Text(
                              _isResendAgain
                                  ? "Try again in " + _start.toString()
                                  : 'Resend',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              )),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 50.0,
                ),
                FadeInDown(
                  delay: const Duration(milliseconds: 500),
                  duration: const Duration(milliseconds: 500),
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: ButtonTheme(
                        minWidth: 250,
                        height: 45,
                        child: MaterialButton(
                          elevation: 0,
                          onPressed: () async {
                            if (_formkeyOTP.currentState!.validate()) {
                              setState(() {
                                _isResendAgain = false;
                              });
                              try {
                                await _auth
                                    .signInWithCredential(
                                      PhoneAuthProvider.credential(
                                        verificationId: _sentCode,
                                        smsCode: _OTPFormCode.toString(),
                                      ),
                                    )
                                    .then((value) async => {
                                          if (value != null)
                                            {
                                              await _firestore
                                                  .collection('phoneusers')
                                                  .doc(_auth.currentUser!.uid)
                                                  .set({
                                                'username':
                                                    _usernameController.text,
                                                'phonenumber': _userPhoneNumber
                                                    .completeNumber
                                                    .trim(),
                                                'imageUrl': '',
                                                'uid': FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                'status': 'Online'
                                              }, SetOptions(merge: true)).then(
                                                      (value) => {
                                                            setState(() {
                                                              _isResendAgain =
                                                                  false;
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
                                                  child: const MainScreen(),
                                                ),
                                              )
                                            }
                                        });
                              } catch (e) {
                                s.showErrorMessage(context, e.toString());
                              }
                            }
                          },
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5),
                          child: const Text(
                            "Verify",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(
                                color: Color.fromRGBO(255, 255, 0, 100)),
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signinUserWithPhone() async {
    Service s = Service();
    var outputMessage =
        'An error occured while processing the request, please check your credentials';

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: _userPhoneNumber.completeNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            UserCredential result =
                await _auth.signInWithCredential(credential);
            User? user = result.user;

            if (user != null) {
              Navigator.push(
                context,
                PageTransition(
                  curve: Curves.linear,
                  type: PageTransitionType.fade,
                  child: const MainScreen(),
                ),
              );
            }
          },
          verificationFailed: (FirebaseAuthException exception) {
            s.showErrorMessage(context, exception.message);
          },
          codeSent: (verificationID, [foreResendingToken]) {
            _sentCode = verificationID;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _sentCode = verificationId;
          });
    } on FirebaseException catch (pe) {
      if (pe.message != null) {
        outputMessage = pe.message!;
      }

      s.showErrorMessage(context, outputMessage);
    } catch (e) {
      s.showErrorMessage(context, e);
    }
  }

  Future sigupUserWithPhone() async {
    Service s = Service();
    var outputMessage =
        'An error occured while processing the request, please check your credentials';

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: _userPhoneNumber.completeNumber,
          verificationCompleted: (PhoneAuthCredential crediential) {
            _auth.signInWithCredential(crediential).then((user) async => {
                  if (user != null)
                    {
                      await _firestore
                          .collection('phoneusers')
                          .doc(_auth.currentUser?.uid)
                          .set({
                        'username': _usernameController.text,
                        'phonenumber': _userPhoneNumber.completeNumber,
                        'imageUrl': '',
                        'uid': FirebaseAuth.instance.currentUser!.uid,
                        'status': 'Online'
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
                    }
                  else
                    {s.showErrorMessage(context, outputMessage)}
                });
          },
          verificationFailed: (FirebaseAuthException exception) {
            s.showErrorMessage(context, exception.message);
          },
          codeSent: (verificationID, [foreResendingToken]) {
            _sentCode = verificationID;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _sentCode = verificationId;
          });
    } on FirebaseException catch (pe) {
      if (pe.message != null) {
        outputMessage = pe.message!;
      }

      s.showErrorMessage(context, outputMessage);
    } catch (e) {
      s.showErrorMessage(context, e);
    }
  }
}
