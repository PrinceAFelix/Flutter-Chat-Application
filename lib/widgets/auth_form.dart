import 'package:chat_app/screens/phoneAuth_screen.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';


class AuthForm extends StatefulWidget {
  AuthForm(this._sbmtForm, this.proccessingAuth);

  

  bool proccessingAuth;
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) _sbmtForm;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
    var _isLogin = true;
  
  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double textfieldH = 0.0, signBtnH = 0.0, signBtnW = 0.0, logCreateBtnH = 0.0, logCreateBtnW = 0.0,whiteSpace = 0.0;    
    
    
    final _formkey = GlobalKey<FormState>();
    final TextEditingController _userEmailController = TextEditingController();
    final TextEditingController _userPasswordController = TextEditingController();
    final TextEditingController _userNameController = TextEditingController();

    logCreateBtnW = 250.0;
    textfieldH = 45;
    signBtnH = 30.0;
    signBtnW = 170.0;

    //To Create Responsive application
    if(screenHeight == 568 && screenWidth == 320){ //Iphone 5C, 5S, 5 - Ipod Touch 5, 6, 7
      logCreateBtnH = 20.0;
      _isLogin ? whiteSpace = 0.08 : whiteSpace = 0.0;
    }else if(screenHeight == 667 && screenWidth == 375){ //Iphone 8, 7, 6s, 6, SE
      logCreateBtnH = 45.0;
      _isLogin ? whiteSpace = 0 : whiteSpace = 0;
    }else if(screenHeight == 812 && screenWidth == 375){ //Iphone 13 mini, 12 mini, 11 pro, XS, X
      logCreateBtnH = 45.0;
      _isLogin ? whiteSpace = 0.10 : whiteSpace = 0.04;
    }else if(screenHeight == 844 && screenWidth == 390){ //Iphpne 13, 13 Pro, 12, 12 Pro
      logCreateBtnH = 45.0;
      _isLogin ? whiteSpace = 0.185 : whiteSpace = 0.13;
    }else if(screenHeight == 736 && screenWidth == 414){ //Iphone 8 Plus
      logCreateBtnH = 45.0;
      _isLogin ? whiteSpace = 0.05 : whiteSpace = 0;
    }else if(screenHeight == 896 && screenWidth == 414){ //Iphone 11 Pro Max, 11, XR, XS Max
      logCreateBtnH = 45.0;
      _isLogin ? whiteSpace = 0.19 : whiteSpace = 0.14;
    }else if(screenHeight == 926 && screenWidth == 428){ //Iphone 13 Pro Max, 12 Pro Max
      logCreateBtnH = 45.0;
      _isLogin ? whiteSpace = 0.15 : whiteSpace = 0.10;
    }
    //Not Tested Yet
    else if(screenHeight == 847 && screenWidth == 476){ //Iphone 7 Plus, 6S Plus, 6Plus
      logCreateBtnH = 45.0;
      _isLogin ? whiteSpace = 0.19 : whiteSpace = 0.14;
    }
   

    ScreenLogo sl = ScreenLogo(screenWidth, screenHeight, false);

    void _sbmtPress(){
      //FocusScope.of(context).unfocus();
      final isValid = _formkey.currentState!.validate();
      if(isValid){
        _formkey.currentState!.save();
        widget._sbmtForm(
          _userEmailController.text.trim(),
          _userPasswordController.text.trim(),
          _userNameController.text.trim(),
          _isLogin,
          context,
        );
      }
      

    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                sl.logoImage(context),
                const SizedBox(height: 10,),
                Form(
                  key: _formkey,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if(!_isLogin)
                        Container(
                          height: textfieldH,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: TextFormField(
                              key: const ValueKey("username"),
                              validator: (value) {
                                if(value!.isEmpty || value.length < 4) {
                                  return 'Please enter at least 4 characters';
                                }
                                return null;
                              },
                              controller: _userNameController,
                              onSaved: (value) {
                                _userNameController.text = value!;
                              },
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.black, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: "Username" ,
                                contentPadding: const EdgeInsets.all(15.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Container(
                          height: textfieldH,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: TextFormField(
                              key: const ValueKey("email"),
                              validator: (value){
                                if(value!.isEmpty|| !value.contains('@')){
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              controller: _userEmailController,
                              onSaved: (value) {
                                _userEmailController.text = value!;
                              },
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: Colors.black, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: "Email",
                                contentPadding: const EdgeInsets.all(15.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Container(
                          height: textfieldH,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: TextFormField(
                              key: const ValueKey("password"),
                              validator: (String? value) {
                                if(value!.isEmpty || value.length < 7){
                                  return 'Password must be at least 7 characters long';
                                }
                                return null;
                              },
                              controller: _userPasswordController,
                              onSaved: (value) {
                                _userPasswordController.text = value!;
                              },
                              obscureText: true,
                              style: TextStyle(color: Colors.black, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: "Password",
                                contentPadding: const EdgeInsets.all(15.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if(widget.proccessingAuth) 
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: ButtonTheme(
                              minWidth: signBtnW,
                              height: signBtnH,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        if(!widget.proccessingAuth)
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: ButtonTheme(
                              minWidth: signBtnW,
                              height: signBtnH,
                              child: MaterialButton(
                                elevation: 0,
                                onPressed: _sbmtPress,
                                color: Theme.of(context).colorScheme.primary,
                                child: Text(_isLogin ?  "Login" : "Sign up", style: TextStyle(color:  Colors.white, fontSize: 13),),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(color: Color.fromRGBO(255, 255, 0, 0.5)),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: MediaQuery.of(context).size.height * whiteSpace),
                        TextButton(onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              curve: Curves.linear,
                              type: PageTransitionType.fade,
                              child: PhoneAuth(),
                            ),
                          );
                        }, 
                          child: Text("Go Bluetooth Mode", style: TextStyle(fontSize: 15),),
                        ),
                        Text(_isLogin ? "OR\nDon't have an account?" :"OR\nAlready have an account?", style: TextStyle(fontSize: 12), textAlign: TextAlign.center,),
                        SizedBox(height: 5,),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: ButtonTheme(
                            minWidth: logCreateBtnW,
                            height: logCreateBtnH,
                            child: MaterialButton(
                              elevation: 0,
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                              child: Text(_isLogin ? "Sign up" : "Login", style: TextStyle(color: Colors.black, fontSize: 18),),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: Color.fromRGBO(255, 255, 0, 100)),
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // return Center(
    //   child: Card(
    //     margin: EdgeInsets.all(20.0),
    //     child: SingleChildScrollView(
    //       child: Padding(
    //         padding: EdgeInsets.all(10.0),
    //         child: Form(
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: <Widget>[
    //               Padding(
    //                 padding: const EdgeInsets.all(10.0),
    //                 child: TextFormField(
    //                   keyboardType: TextInputType.text,
    //                   decoration: InputDecoration(
    //                     labelText: 'Username',
    //                     contentPadding: const EdgeInsets.all(15.0),
    //                     border: OutlineInputBorder(
    //                     borderRadius: BorderRadius.circular(10.0),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.all(10.0),
    //                 child: TextFormField(
    //                   keyboardType: TextInputType.text,
    //                   decoration: InputDecoration(
    //                     labelText: 'Email',
    //                     contentPadding: const EdgeInsets.all(15.0),
    //                     border: OutlineInputBorder(
    //                     borderRadius: BorderRadius.circular(10.0),
    //                     ),
    //                   ),),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.all(10.0),
    //                 child: TextFormField(
    //                   keyboardType: TextInputType.text,
    //                   decoration: InputDecoration(
    //                     labelText: 'Password',
    //                     contentPadding: const EdgeInsets.all(15),
    //                     border: OutlineInputBorder(
    //                     borderRadius: BorderRadius.circular(10),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}

