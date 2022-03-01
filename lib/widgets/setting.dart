import 'package:chat_app/services/database.dart';

import 'package:chat_app/widgets/logo.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final BuildContext ctx;

  const Settings({ Key? key,
  required this.ctx }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

    var _isOpen1 = false;
    var _isOpen2 = false;
    var _isOpen3 = false;
    var _isOpen4 = false;
  
  @override
  Widget build(BuildContext context) {
    Service service = Service();
  
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    ScreenLogo sl = ScreenLogo(screenWidth, screenHeight, true);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white.withOpacity(1),
        body:  Container(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              sl.logoImage(context),
              SizedBox(height: 20.0,),
              Container(
                width: 370.0,
                height: 310.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0),
                      blurRadius: 5.0
                    )
 
                  ],
                  //border: Border.all(width: 5, color: Colors.red),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 5.0,),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                            child: ButtonTheme(
                            minWidth: 250,
                            height: 45,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 35),
                              child: MaterialButton(
                                elevation: 0,
                                onPressed: () {
                                  setState(() {
                                    _isOpen1 = !_isOpen1;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 140.0),
                                      child: Text("User Info", style: TextStyle(color: Colors.black, fontSize: 18), textAlign: TextAlign.left,),
                                    ),
                                    _isOpen1 ? Icon(Icons.arrow_drop_down_rounded, size: 60.0) : Icon(Icons.arrow_left_rounded, size: 60.0,),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                      Divider(
                        color: Colors.black,
                        height: 0.0,
                        thickness: 1.0,
                        indent: 50.0,
                        endIndent: 50.0,
                      ),
                   Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                          child: ButtonTheme(
                          minWidth: 250,
                          height: 45,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 35),
                            child: MaterialButton(
                              elevation: 0,
                              onPressed: () {
                                  setState(() {
                                    _isOpen2 = !_isOpen2;
                                  });
                                },
                              child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 100.0),
                                      child: Text("Change Color", style: TextStyle(color: Colors.black, fontSize: 18), textAlign: TextAlign.left,),
                                    ),
                                    _isOpen2 ? Icon(Icons.arrow_drop_down_rounded, size: 60.0) : Icon(Icons.arrow_left_rounded, size: 60.0,),
                                  ],
                                ),
                            ),
                          ),
                        )
                      ),
                      Divider(
                        color: Colors.black,
                        height: 0.0,
                        thickness: 1.0,
                        indent: 50.0,
                        endIndent: 50.0,
                      ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                          child: ButtonTheme(
                          minWidth: 250,
                          height: 45,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 35),
                            child: MaterialButton(
                              elevation: 0,
                              onPressed: () {
                                  setState(() {
                                    _isOpen3 = !_isOpen3;
                                  });
                                },
                              child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 180.0),
                                      child: Text("Help", style: TextStyle(color: Colors.black, fontSize: 18), textAlign: TextAlign.left,),
                                    ),
                                    _isOpen3 ? Icon(Icons.arrow_drop_down_rounded, size: 60.0) : Icon(Icons.arrow_left_rounded, size: 60.0,),
                                  ],
                                ),
                            ),
                          ),
                        )
                      ),
                      Divider(
                        color: Colors.black,
                        height: 0.0,
                        thickness: 1.0,
                        indent: 50.0,
                        endIndent: 50.0,
                      ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                          child: ButtonTheme(
                          minWidth: 250,
                          height: 45,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 35),
                            child: MaterialButton(
                              elevation: 0,
                              onPressed: () {
                                  setState(() {
                                    _isOpen4 = !_isOpen4;
                                  });
                                },
                              child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 170.0),
                                      child: Text("About", style: TextStyle(color: Colors.black, fontSize: 18), textAlign: TextAlign.left,),
                                    ),
                                    _isOpen4 ? Icon(Icons.arrow_drop_down_rounded, size: 60.0) : Icon(Icons.arrow_left_rounded, size: 60.0,),
                                  ],
                                ),
                            ),
                          ),
                        )
                      ),
                      Divider(
                        color: Colors.black,
                        height: 0.0,
                        thickness: 1.0,
                        indent: 50.0,
                        endIndent: 50.0,
                      ),
                    ],
                ),
              ),
               SizedBox(height: 70,),
                  ButtonTheme(
                      minWidth: 300,
                      height: 50,
                      child: MaterialButton(
                        elevation: 5,
                        onPressed: () async{
                          service.signoutUser(context);
                        },
                        color: Colors.white,
                        child: Text("Log Out", style: TextStyle(color: Colors.black, fontSize: 18),),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          side: BorderSide(color: Colors.black.withOpacity(0.2)),
                        ),
                      )
                    )
            ],
          ),
        ),
      ),
    );
  }
}