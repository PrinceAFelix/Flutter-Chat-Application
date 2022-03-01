
import 'package:chat_app/screens/setting_screen.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({ Key? key }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isMessage = true;
  Service service = Service();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: <Widget>[
          Container(
            height: 100.0,
            padding: EdgeInsets.only(top: 50.0, right: 0, left: 50),
            child: Column(
              children: <Widget>[
                Row(
                  children: const <Widget>[
                    Text('Chats', style: TextStyle(color: Colors.white, fontSize: 30),),
                    SizedBox(width: 150,),
                  ],
                ),
                
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 0.5),
                    blurRadius: 10.0,
                  )
                ]
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: <Widget>[
                        TextButton(onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              curve: Curves.linear,
                              type: PageTransitionType.bottomToTop,
                              child: const SettingScreen(),
                            ),
                          );
                        }, 
                          child: Text("Profile"),
                        ),
                        SizedBox(width: 110,),
                        Text('App Name'),
                        SizedBox(width: 110,),
                        Text('Icon'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: isMessage == false ? 
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("No Messages", style: TextStyle(fontSize: 20, color: Colors.black.withOpacity(0.7)),),
                          SizedBox(height: 10,),
                          Text("New messages will appear here", style: TextStyle(fontSize: 14, color: Colors.grey),),
                        ],
                      )
                      : ListView.builder(
                        itemBuilder: (ctx, index){
                          return Container(
                            height: 100.0,
                            child: Card(
                              margin: EdgeInsets.all(20),
                              child: Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Row(
                                  children: const <Widget>[
                                    Text("Test User"),
                                    SizedBox(width: 50,),
                                    Text("Username")
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     centerTitle: false,
    //     title: Transform(
    //       transform: Matrix4.translationValues(20.0, 0.0, 0.0),
    //       child: Text('Chats', style: TextStyle(color: Colors.black, fontSize: 30),),
    //     ),
    //     backgroundColor: Colors.yellow,
    //   ),
    //   body: Container(
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.vertical(top: Radius.circular(30.0))
    //     ),
    //     child: Column(
    //       children: <Widget>[
    //         Row(
    //           children: [
    //             Text('tegded'),
    //           ],
    //           ),
              
    //       ],
    //     ),
    //   ),
      
    // );
  }
}