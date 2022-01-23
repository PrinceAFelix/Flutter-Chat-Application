import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  
  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double logoHW = 0.0, textfieldH = 0.0, buttonH = 0.0, buttonW = 0.0, whiteSpace = 0.0;
    
    //To Create Responsive application
    if(screenHeight <= 736 && screenHeight >= 667 && screenWidth <= 414 && screenWidth >= 375){ //Normal iPhone
      logoHW = 0.46;
      textfieldH = 45;
      whiteSpace = 0.05;
      buttonH = 30.0;
      buttonW = 170.0;
    }else if(screenHeight <= 844 && screenHeight >= 812 && screenWidth <= 428 && screenWidth >= 375){ //Pro iPhone
      logoHW = 0.41;
      textfieldH = 50;
      whiteSpace = 0.10;
      buttonH = 40.0;
      buttonW = 170.0;
    }else if(screenHeight <= 926 && screenHeight >= 896 && screenWidth <= 428 && screenWidth >= 414){ //Max and Pro Max
      logoHW = 0.41;
      textfieldH = 60;
      whiteSpace = 0.13;
      buttonH = 45.0;
      buttonW = 200.0;
    }

    final _formkey = GlobalKey<FormState>();
    final TextEditingController _userEmailController = TextEditingController();
    final TextEditingController _userPasswordController = TextEditingController();
    final TextEditingController _userNameController = TextEditingController();
 


    void _sbmtPress(){
      //FocusScope.of(context).unfocus();
      final isValid = _formkey.currentState!.validate();
      if(isValid){
        _formkey.currentState!.save();
        print(_userEmailController.text);
        print(_userPasswordController.text);
        print(_userNameController.text);
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
                Container(
                  height: MediaQuery.of(context).size.height * logoHW,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: -30,
                        right: -30,
                        bottom: 0,
                        child: Image.asset("assets/images/logo.png"),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                Form(
                  key: _formkey,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: textfieldH,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: TextFormField(
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
                        Container(
                          height: textfieldH,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: TextFormField(
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
                        Container(
                          height: textfieldH,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: TextFormField(
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
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: ButtonTheme(
                            minWidth: buttonW,
                            height: buttonH,
                            child: MaterialButton(
                              elevation: 0,
                              onPressed: _sbmtPress,
                              color: Color.fromRGBO(255, 255, 0, 100),
                              child: Text("Sign up", style: TextStyle(color:  Colors.black, fontSize: 13),),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Color.fromRGBO(255, 255, 0, 0.5)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * whiteSpace),
                        Text("Already have an account", style: TextStyle(fontSize: 12),),
                        SizedBox(height: 10,),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: ButtonTheme(
                            minWidth: 250,
                            height: 45,
                            child: MaterialButton(
                              elevation: 0,
                              onPressed: () {},
                              color: Color.fromRGBO(255, 255, 0, 0.5),
                              child: Text("Login", style: TextStyle(color: Colors.black, fontSize: 18),),
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

