class OfflineUserModel{

  final String uid;
  final String username;
  final String phoneNumber;
  final DateTime dateTime;

  OfflineUserModel({
    required this.uid,
    required this.username,
    required this.phoneNumber,
    required this.dateTime,
  });

  factory OfflineUserModel.fromMap(Map<String, dynamic> json) => OfflineUserModel(
    uid: json['uid'], 
    username:  json['username'], 
    phoneNumber: json['phoneNumber'], 
    dateTime: json['dateTime']
    );

    Map<String, dynamic> toMap(){
      return{
        'uid': uid,
        'username': username,
        'phoneNumber': phoneNumber,
        'dateTime': dateTime,
      };
    }
}