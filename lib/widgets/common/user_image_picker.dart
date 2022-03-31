import 'dart:io';

import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/common/round_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProfile extends StatefulWidget {
  final Function(String imageUrl, bool isSet) onFileChanged;

  const UserProfile({Key? key, required this.onFileChanged}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Service service = Service();
  var currentUser = FirebaseAuth.instance.currentUser!.email;

  final ImagePicker _picker = ImagePicker();

  String? imageUrl;
  late bool isSet = false;
  String defaultProfile =
      "https://firebasestorage.googleapis.com/v0/b/chat-app---eng4003-37561.appspot.com/o/images%2FdefaultProfilePicture.png?alt=media&token=b398791c-2351-45c5-a850-ebaaccd11c48";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isSet
            ? Image.asset(
                "assets/images/defaultProfilePicture.png",
                height: 180,
              )
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("emailusers")
                    .where('email', isEqualTo: currentUser)
                    .snapshots(),
                builder: (context, snapshot) {
                  var url = '';
                  if (snapshot.hasData) {
                    url = (snapshot.data! as dynamic).docs[0]["imageUrl"];
                  } else {
                    url = defaultProfile;
                  }
                  if (url == "") {
                    url = defaultProfile;
                  }
                  return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () => _selectPhoto(),
                      child: AppRoundImage.url(url, height: 160, width: 160));
                },
              ),
        SizedBox(
          height: isSet ? 20 : 10,
        ),
        InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => _selectPhoto(),
            child: Text(
              imageUrl != null ? 'Change Photo' : 'Select Photo',
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold),
            ))
      ],
    );
  }

  Future _selectPhoto() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheet(
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text("Camera"),
                    onTap: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text("Pick a photo"),
                    onTap: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.gallery);
                    },
                  )
                ],
              ),
              onClosing: () {},
            ));
  }

  Future _pickImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 50);
    if (pickedFile == null) {
      return;
    }

    var file = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1));
    if (file == null) {
      return;
    }

    file = await compressImage(file.path, 35);

    await _uploadFile(file!.path);
  }

  Future<File?> compressImage(String path, int quality) async {
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');

    final result = await FlutterImageCompress.compressAndGetFile(path, newPath,
        quality: quality);

    return result;
  }

  Future _uploadFile(String path) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('images')
        .child(DateTime.now().toIso8601String() + p.basename(path));

    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();

    service.updateImage(context, await ref.getDownloadURL(), true);

    setState(() {
      imageUrl = fileUrl;
      isSet = true;
    });

    widget.onFileChanged(fileUrl, isSet);
  }
}
