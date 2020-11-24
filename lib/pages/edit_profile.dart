import 'package:app_cnpm/pages/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
          child: GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Text('Edit Profile',
                style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500),),
                SizedBox(height: 15,),
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
                            color: Theme.of(context).scaffoldBackgroundColor
                          ),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2, blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 10)
                            ),
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/a/a0/Pierre-Person.jpg")
                          ),
                        ),
                      ),
                      //edit avatar
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor
                            ),
                            color: Colors.green
                          ),
                          child: Icon(Icons.edit,
                            color: Colors.white,),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 35,),
                buildTextField("User Name", "Huy", false),
                buildTextField("Password", "*************", true),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: [
                    RaisedButton(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.lightGreen,
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text("Cancel",
                      style: TextStyle(fontSize: 14, letterSpacing: 2, color: Colors.white)
                      ),
                    ),
                    RaisedButton(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.lightGreen,
                      onPressed: (){},
                      child: Text("Save",
                          style: TextStyle(fontSize: 14, letterSpacing: 2, color: Colors.white)
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      )
    );
  }

  Widget buildTextField(String labelText, String palaceholder, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextField(
        obscureText: isPassword ? showPassword :true,
        decoration: InputDecoration(
          suffixIcon: isPassword ? IconButton(
            onPressed: (){
              setState(() {
                showPassword = !showPassword;
              });
            },
            icon: Icon(
              Icons.remove_red_eye,
              color: Colors.grey,
            ),
          ) : null,
          contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: palaceholder,
            hintStyle: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold,
              color: Colors.black,
            )
        ),
      ),
    );
  }

}