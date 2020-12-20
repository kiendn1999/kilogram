import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kilogram_app/models/user.dart';
import 'package:kilogram_app/repositories/user_repository.dart';

class EditProfile extends StatefulWidget {
  final UserRepository _userRepository;

  const EditProfile({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);
  @override
  _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {

  Future<User> futureUser;
  User user;

  @override
  void initState() {
    super.initState();
    futureUser = widget._userRepository.getInfoUser();
    getuserID();
  }

  void getuserID() async{
    user = await widget._userRepository.getInfoUser();
  }

  bool showPassword = false;
  File _image;
  String _imageBase64Encode;
  bool _isLoading = false;
  String _firstname = '';
  String _lastname = '';
  String _email = '';
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  _showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog();
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('Change Avatar'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('Take Photo'),
              onPressed: () => _handleImage(ImageSource.camera),
            ),
            CupertinoActionSheetAction(
              child: Text('Choose From Gallery'),
              onPressed: () => _handleImage(ImageSource.gallery),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        );
      },
    );
  }

  _androidDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Change Avatar'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Take Photo'),
              onPressed: () => _handleImage(ImageSource.camera),
            ),
            SimpleDialogOption(
              child: Text('Choose From Gallery'),
              onPressed: () => _handleImage(ImageSource.gallery),
            ),
            SimpleDialogOption(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  _handleImage(ImageSource source) async {
    Navigator.pop(context);
    final _picker = ImagePicker();
    PickedFile pickedFile = await _picker.getImage(source: source);
    File imageFile = File(pickedFile.path);
    if (imageFile != null) {
      imageFile = await _cropImage(imageFile);
      setState(() {
        _image = imageFile;
      });
    }
  }

  _cropImage(File imageFile) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
    return croppedImage;
  }

  submit() {
    final bytes = _image.readAsBytesSync();
    _imageBase64Encode = base64Encode(bytes);
    print(_firstname);print(_lastname);print(_email);
    //UserRepository().updateUser(_firstname, _firstname, user.userID);
    UserRepository().updateUser(_firstname, _lastname, _email, _imageBase64Encode, user.userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Profile", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black87,
        ),
        body: Container(
          color: Colors.black87,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: FutureBuilder<User>(
                  future: futureUser,
                  builder: (context, snapshot){
                    if (snapshot.hasData) {
                      Uint8List imagebytes = base64Decode(snapshot.data.avatar);
                      return
                        ListView(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: Stack(
                                children: [
                                  //avatar
                                  Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 4,
                                          color:
                                          Theme.of(context).scaffoldBackgroundColor),
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 2,
                                            blurRadius: 10,
                                            color: Colors.black.withOpacity(0.1),
                                            offset: Offset(0, 10)),
                                      ],
                                      shape: BoxShape.circle,
                                      image:
                                      DecorationImage(
                                          fit: BoxFit.cover,
                                          image: snapshot.data.avatar.isEmpty
                                              ? AssetImage("assets/default_avatar.jpg")
                                              : Image.memory(imagebytes).image),
                                    ),
                                  ),
                                  //edit avatar
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                        onTap: _showSelectImageDialog,
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  width: 4,
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor),
                                              color: Colors.green),
                                          child: Icon(
                                            Icons.camera_enhance,
                                            color: Colors.white,
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 35,
                            ),
                            buildTextField("First Name", snapshot.data.firstName, false),
                            buildTextField1("Last Name", snapshot.data.lastName, false),
                            buildTextField2("Email", snapshot.data.email, false),
                            //buildTextField("Password", "*************", true),// fix sau
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RaisedButton(
                                  padding: EdgeInsets.symmetric(horizontal: 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: Colors.redAccent,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel",
                                      style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 2,
                                          color: Colors.white)),
                                ),
                                RaisedButton(
                                  padding: EdgeInsets.symmetric(horizontal: 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: Colors.lightGreen,
                                  onPressed: () {
                                    showAnimatedDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return ClassicGeneralDialogWidget(
                                          titleText: 'Saving change ?',
                                          contentText:
                                          "Would you like to cotinue saving this change info ?",
                                          onPositiveClick: () {
                                            if (_lastname=='') _lastname = snapshot.data.lastName;
                                            if (_firstname=='') _firstname = snapshot.data.firstName;
                                            if (_email=='') _email = snapshot.data.email;
                                            submit();
                                            //Navigator.of(context).pop();
                                          },
                                          onNegativeClick: () {
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                      animationType: DialogTransitionType.scaleRotate,
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(seconds: 1),
                                    );
                                  },
                                  child: Text("Save",
                                      style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 2,
                                          color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        );}
                    else if (snapshot.hasError) return Text("${snapshot.error}");
                    return Center(
                          child: CircularProgressIndicator(),
                    );
                  }
              ),
            ),
          ),
        ));
  }

  Widget buildTextField(
      String labelText, String palaceholder, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: _firstnameController,
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        obscureText: isPassword?!this.showPassword:false,
        onChanged: (input) => _firstname = input,
        decoration: InputDecoration(
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: this.showPassword ? Colors.redAccent : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
            )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.white),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: palaceholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
      ),
    );
  }

  Widget buildTextField1(
      String labelText, String palaceholder, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: _lastnameController,
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        obscureText: isPassword?!this.showPassword:false,
        onChanged: (input) => _lastname = input,
        decoration: InputDecoration(
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: this.showPassword ? Colors.redAccent : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
            )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.white),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: palaceholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
      ),
    );
  }


  Widget buildTextField2(
      String labelText, String palaceholder, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: _emailController,
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        obscureText: isPassword?!this.showPassword:false,
        onChanged: (input) => _email = input,
        decoration: InputDecoration(
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: this.showPassword ? Colors.redAccent : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
            )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.white),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: palaceholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
      ),
    );
  }

}