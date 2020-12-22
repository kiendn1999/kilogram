import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kilogram_app/models/user.dart';
import 'package:kilogram_app/repositories/user_repository.dart';

class EditProfile extends StatefulWidget {
  User _owner;

  EditProfile(this._owner);

  @override
  _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {


  @override
  void initState() {
    super.initState();
  }

  bool showPassword = false;
  File _image;
  bool _isLoading = false;
  bool _isAvaChange=false;
  String _imageBase64Encode;
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
        _isAvaChange=true;
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
    print(_firstname);print(_lastname);print(_email);
    //UserRepository().updateUser(_firstname, _firstname, user.userID);
    UserRepository().updateUser(_firstname, _lastname, _email, _imageBase64Encode, UserRepository.getUserID);
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
              child: ListView(
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
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: widget._owner.avatar.isEmpty?avatardefault():avatar(widget._owner.avatar)),
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
                  buildTextField("First Name", widget._owner.firstName, false, _firstnameController,1),
                  buildTextField("Last Name", widget._owner.lastName, false,_lastnameController,2),
                  buildTextField("Email",widget._owner.email, false,_emailController,3),
                  //buildTextField("Password", "*************", true),
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
                                  if (_lastname=='') _lastname = widget._owner.lastName;
                                  if (_firstname=='') _firstname =  widget._owner.firstName;
                                  if (_email=='') _email =  widget._owner.email;
                                  submit();
                                  FocusScope.of(context).unfocus();
                                  Navigator.of(context).pop();
                                  Navigator.pop(context);
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
              ),
            ),
          ),
        ));
  }

  ImageProvider avatardefault() {
    if(_isAvaChange && _image!=null) {
      final bytes = _image.readAsBytesSync();
      _imageBase64Encode = base64Encode(bytes);
      return FileImage(_image);
    }
    ho();
      return AssetImage("assets/default_avatar.jpg");
  }
  Future<void> ho() async {
    ByteData bytes = await rootBundle.load('assets/default_avatar.jpg');
    var buffer = bytes.buffer;
    _imageBase64Encode= base64.encode(Uint8List.view(buffer));
  }

  ImageProvider avatar(String stringAva)
  {
    if(_isAvaChange && _image!=null) {
      final bytes = _image.readAsBytesSync();
      _imageBase64Encode = base64Encode(bytes);
    return FileImage(_image);
    }
    _imageBase64Encode=stringAva;
    Uint8List imagebytes=base64Decode(stringAva);
    return Image.memory(imagebytes).image;
  }


  Widget buildTextField(
      String labelText, String palaceholder, bool isPassword, TextEditingController textEditingController, int type) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: textEditingController,
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        obscureText: isPassword?!this.showPassword:false,
        onChanged: (input) {
          if(type==1) return _firstname = input;
          if(type==2) return _lastname = input;
          if(type==3) return _email=input;
        },
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