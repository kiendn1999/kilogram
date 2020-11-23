import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
          child: ListView(
            children: [
              Text('Edit Profile',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
              SizedBox(height: 15,),
              Center(
                child: Stack(
                  children: [
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
                        child: Icon(Icons.edit, color: Colors.white,),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

}