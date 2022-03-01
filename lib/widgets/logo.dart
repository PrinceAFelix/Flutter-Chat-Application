import 'package:chat_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ScreenLogo {

  ScreenLogo(this.screenWidth, this.screenHeight, this.isSetting);
  var screenWidth;
  var screenHeight;
  double logoHW = 0.0;
  bool isSetting;


  Widget logoImage(BuildContext context){
  //To Create Responsive application
    if(screenHeight == 568 && screenWidth == 320){ //Ipod Touch, 5, 6, 7Gen, Iphone 5C, 5S, 5
      logoHW = 0.45;
    }else if(screenHeight == 736 && screenWidth == 414){ //Iphone 8 Plus
      logoHW = 0.48;
    }else if(screenHeight == 667 && screenWidth == 375){ //Iphone 8, 7, 6s, 6, SE //Iphone 13 mini, 12 mini, 11 pro, XS, X
      logoHW = 0.49;
    }else if(screenHeight == 844 && screenWidth == 390 || screenHeight == 896 && screenWidth == 414 || screenHeight == 926 && screenWidth == 428){ //Iphpne 13, 13 Pro, 12, 12 Pro //Iphone 11 Pro Malszx, 11, XR, XS Max
      logoHW = 0.41;
    }else if(screenHeight == 812  && screenWidth == 375){
      logoHW = 0.41;
    }
    return 
    isSetting ? 
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
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
              padding: EdgeInsets.only(left: 0, right: 50.0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                            context,
                            PageTransition(
                              curve: Curves.linear,
                              type: PageTransitionType.topToBottom,
                              child: MainScreen(),
                            ),
                          );
                },
                icon: Icon(Icons.keyboard_arrow_down_rounded),
                iconSize: 50.0,
              ),
            ),
            ),
            Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Image.asset("assets/images/defaultProfilePicture.png", height: 180,),
                  ),
                ),
                SizedBox(height: 20.0,),
                Text("Username", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),),
              ],
            ),
            
            //UserName
            
          ],
        ),
    )
    :
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
    );
  }
}