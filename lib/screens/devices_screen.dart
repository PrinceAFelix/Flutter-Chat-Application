import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat_app/controller/message_controller.dart';
import 'package:chat_app/models/advertiser.dart';
import 'package:chat_app/models/browser.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/screens/bluetooth_login_screen.dart';
import 'package:chat_app/screens/message_screen.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:page_transition/page_transition.dart';

enum DeviceType { advertiser, browser }

class DevicesListSCreen extends StatefulWidget {
  final DeviceType deviceType;
  final String chatterName;
  final bool isBrowser;
  const DevicesListSCreen(
      {Key? key,
      required this.deviceType,
      required this.chatterName,
      required this.isBrowser})
      : super(key: key);

  @override
  _DevicesListSCreenState createState() => _DevicesListSCreenState();
}

class _DevicesListSCreenState extends State<DevicesListSCreen> {
  MessageController controller = MessageController();

  List<Device> devices = [];
  List<Device> connectedDevices = [];
  NearbyService nearbyService = NearbyService();
  late StreamSubscription subscription;
  late StreamSubscription receivedDataSubscription;

  String ptrData = "***** Initial Message *****";

  late MessageModel receivedMessage;
  late MessageModel sendMessage;

  // late Advertiser advertiser = Advertiser(advertiserGivenName: "Advertiser", advertiserId: "Initial Id", advertiserName: "Initial name");
  // late Browser browser = Browser(browserGivenName: "Browser", browserId: "Initial Id", browserName:  "Initial name");

  var messages = List<String>.empty();

  var username = '';
  String toName = '';
  String fromName = '';

  bool isInit = false;
  bool isSent = false;

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void dispose() {
    subscription.cancel();
    receivedDataSubscription.cancel();
    nearbyService.stopBrowsingForPeers();
    nearbyService.stopAdvertisingPeer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(children: <Widget>[
        Container(
          height: 100.0,
          padding: const EdgeInsets.only(top: 50.0, right: 0, left: 50),
          child: Column(
            children: <Widget>[
              Row(
                children: const [
                  Text(
                    'Chats',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  SizedBox(
                    width: 0,
                  ),
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
                  ],
                ),
                child: ListView.builder(
                    itemCount: getItemCount(),
                    itemBuilder: (context, index) {
                      final device = widget.deviceType == DeviceType.advertiser
                          ? connectedDevices[index]
                          : devices[index];

                      // toName = connectedDevices[index].deviceName;

                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey, width: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 3)),
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () =>
                                            _onTabItemListener(device, context),
                                        child: Column(
                                          children: [
                                            Text(device.deviceName),
                                            Text(
                                              getStateName(device.state),
                                              style: TextStyle(
                                                  color: getStateColor(
                                                      device.state)),
                                            ),
                                          ],
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                        ),
                                      )),
                                      // Request connect
                                      GestureDetector(
                                        onTap: () => _onButtonClicked(device),
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          padding: const EdgeInsets.all(8.0),
                                          height: 35,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color:
                                                  getButtonColor(device.state),
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: Center(
                                            child: Text(
                                              getButtonStateName(device.state),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 200.0,
                              ),

                              // const Divider(
                              //   height: 1,
                              //   color: Colors.grey,
                              // )
                            ],
                          ),
                        ),
                      );
                    }))),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 500,
            color: Colors.white,
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        curve: Curves.linear,
                        type: PageTransitionType.fade,
                        child: const BluetoothLoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Go Back",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  String getStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return "disconnected";
      case SessionState.connecting:
        return "waiting";
      default:
        return "connected";
    }
  }

  String getButtonStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
      case SessionState.connecting:
        return "Connect";
      default:
        return "Disconnect";
    }
  }

  Color getStateColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return Colors.black;
      case SessionState.connecting:
        return Colors.grey;
      default:
        return Colors.green;
    }
  }

  Color getButtonColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
      case SessionState.connecting:
        return Colors.blue;
      default:
        return Colors.red;
    }
  }

  _onTabItemListener(Device device, BuildContext contextThis) {
    if (device.state == SessionState.connected) {
      Advertiser advertiser = widget.isBrowser == false
          ? Advertiser(
              advertiserGivenName: widget.chatterName,
              message: ptrData,
            )
          : Advertiser(
              advertiserGivenName: widget.chatterName,
              message: ptrData,
            );

      Browser browser = widget.isBrowser
          ? Browser(
              browserGivenName: widget.chatterName,
              message: ptrData,
            )
          : Browser(
              browserGivenName: widget.chatterName,
              message: ptrData,
            );

      receivedMessage = MessageModel(
          isSent: false,
          toName: device.deviceId,
          fromName: device.deviceName,
          message: "****Initial Message****");
      widget.isBrowser
          ? Navigator.push(
              context,
              PageTransition(
                curve: Curves.linear,
                type: PageTransitionType.fade,
                child: MessageScreen(
                  messageController: controller,
                  messageModel: receivedMessage,
                  user: device.deviceId,
                  username: fromName,
                  device: device,
                  deviceType: widget.deviceType,
                  nearbyService: nearbyService,
                  advertiserModel: advertiser,
                  browserModel: browser,
                  isBrowser: true,
                  context: contextThis,
                ),
              ),
            )
          : Navigator.push(
              context,
              PageTransition(
                curve: Curves.linear,
                type: PageTransitionType.fade,
                child: MessageScreen(
                  messageController: controller,
                  messageModel: receivedMessage,
                  user: device.deviceId,
                  username: fromName,
                  device: device,
                  deviceType: widget.deviceType,
                  nearbyService: nearbyService,
                  advertiserModel: advertiser,
                  browserModel: browser,
                  isBrowser: false,
                  context: contextThis,
                ),
              ),
            );
    }
  }

  int getItemCount() {
    if (widget.deviceType == DeviceType.advertiser) {
      return connectedDevices.length;
    } else {
      return devices.length;
    }
  }

  _onButtonClicked(Device device) {
    switch (device.state) {
      case SessionState.notConnected:
        nearbyService.invitePeer(
          deviceID: device.deviceId,
          deviceName: device.deviceName,
        );
        break;
      case SessionState.connected:
        nearbyService.disconnectPeer(deviceID: device.deviceId);
        break;
      case SessionState.connecting:
        break;
    }
  }

  void init() async {
    nearbyService = NearbyService();
    String devInfo = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      devInfo = androidInfo.model;
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      devInfo = iosInfo.localizedModel;
    }
    await nearbyService.init(
        serviceType: 'mpconn',
        deviceName: devInfo,
        strategy: Strategy.P2P_CLUSTER,
        callback: (isRunning) async {
          if (isRunning) {
            if (widget.deviceType == DeviceType.browser) {
              await nearbyService.stopBrowsingForPeers();
              await Future.delayed(const Duration(microseconds: 200));
              await nearbyService.startBrowsingForPeers();
            } else {
              await nearbyService.stopAdvertisingPeer();
              await nearbyService.stopBrowsingForPeers();
              await Future.delayed(const Duration(microseconds: 200));
              await nearbyService.startAdvertisingPeer();
              await nearbyService.startBrowsingForPeers();
            }
          }
        });
    subscription =
        nearbyService.stateChangedSubscription(callback: (devicesList) {
      devicesList.forEach((element) {
        if (Platform.isAndroid) {
          if (element.state == SessionState.connected) {
            nearbyService.stopBrowsingForPeers();
          } else {
            nearbyService.startBrowsingForPeers();
          }
        }
      });

      setState(() {
        devices.clear();
        devices.addAll(devicesList);
        connectedDevices.clear();
        connectedDevices.addAll(devicesList
            .where((d) => d.state == SessionState.connected)
            .toList());
      });
    });

    receivedDataSubscription =
        nearbyService.dataReceivedSubscription(callback: (data) {
      ptrData = jsonEncode(data);
      var temp1 = ptrData.replaceAll("\"", '');
      var temp2 = temp1.replaceAll(":", '');
      var temp3 = temp2.replaceAll("{", '');
      var temp4 = temp3.replaceAll("}", '');
      var temp5 = temp4.replaceAll(",", '');
      var temp6 = temp5.replaceAll("iPhone", '');
      var temp7 = temp6.replaceAll("message", '');
      var temp8 = temp7.replaceAll("deviceId", '');

      ptrData = temp8;

      setState(() {
        receivedMessage = MessageModel(
            isSent: true, toName: "John", fromName: "Dode", message: ptrData);
        isSent = true;
      });

      controller.onSend(
          toUsername: receivedMessage.toName,
          fromUsername: receivedMessage.fromName,
          message: receivedMessage.message);
    });
  }
}
