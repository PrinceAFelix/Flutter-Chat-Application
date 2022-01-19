import 'package:flutter/material.dart';
import 'dart:async';

class AuthForm extends StatefulWidget {

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                height: 370,
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
               SizedBox(height: 20,),
               Form(
                 child: Container(
                   width: 300,
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            contentPadding: const EdgeInsets.all(15.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            contentPadding: const EdgeInsets.all(15.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            contentPadding: const EdgeInsets.all(15.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: ButtonTheme(
                          minWidth: 200,
                          height: 45,
                          child: MaterialButton(
                              elevation: 0,
                              onPressed: (){},
                              color: Color.fromRGBO(255, 255, 0, 100),
                              child: Text("Sign up", style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(color: Color.fromRGBO(255, 255, 0, 0.5),)
                          ),
                          ),
                        ),
                      ),
                      SizedBox(height: 180,),
                      Text("Already have an account?"),
                      SizedBox(height: 10,),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: ButtonTheme(
                          minWidth: 250,
                          height: 45,
                          child: MaterialButton(
                              elevation: 0,
                              onPressed: (){},
                              color: Color.fromRGBO(255, 255, 0, 0.5),
                              child: Text("Login", style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Color.fromRGBO(255, 255, 0, 100),)
                          ),
                          ),
                        ),
                      ),
                      
                     ],
                    ),
                 ),
                )
            ],
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