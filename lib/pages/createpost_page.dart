import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kilogram_app/models/user.dart';
import 'package:kilogram_app/repositories/post_repository.dart';
import 'package:kilogram_app/repositories/user_repository.dart';

class CreatePostPage extends StatefulWidget {
  final UserRepository _userRepository;

  const CreatePostPage({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  _CreatePostPage createState() => _CreatePostPage();
}

class _CreatePostPage extends State<CreatePostPage> {
  File _image;
  TextEditingController _captionController = TextEditingController();
  String _caption = '';
  bool _isLoading = false;
  String _imageBase64Encode;
  User _user;

  @override
  Future<void> initState() {
    super.initState();
    getuserID();
  }

  void getuserID() async {
    _user = await widget._userRepository.getInfoUser();
  }

  _showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog();
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('Add Photo'),
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
          title: Text('Add Photo'),
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

  _submit(context) async {
    FocusScope.of(context).unfocus();
    if (!_isLoading && _image != null && _caption.isNotEmpty)
      setState(() {
        _isLoading = true;
      });

    final bytes = _image.readAsBytesSync();
    _imageBase64Encode = base64Encode(bytes);
    await PostRepository().createAPostInUser(_imageBase64Encode, _caption, _user.userID);
    setState(() {
      _caption = '';
      _image = null;
      _isLoading = false;
    });
    _captionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          'Create Post',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
         if(_isLoading==true)Center(child: CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation<Color>(Colors.green)))
          else  IconButton(
           icon: Icon(Icons.add),
           onPressed: () {
             _submit(context);
           },
         ),
        ],
      ),
      body: Container(
          color: Colors.black87,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Container(
                height: height,
                child: Column(
                  children: <Widget>[
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.blue[200],
                              valueColor: AlwaysStoppedAnimation(Colors.blue),
                            ),
                          )
                        : SizedBox.shrink(),
                    GestureDetector(
                      onTap: _showSelectImageDialog,
                      child: Container(
                        height: width,
                        width: width,
                        color: Colors.grey[300],
                        child: _image == null
                            ? Icon(
                                Icons.add_a_photo,
                                color: Colors.white70,
                                size: 150.0,
                              )
                            : Image(
                                image: FileImage(_image),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: TextField(
                        controller: _captionController,
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                        decoration: InputDecoration(
                            labelText: 'Caption',
                            labelStyle: TextStyle(color: Colors.white)),
                        onChanged: (input) => _caption = input,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
