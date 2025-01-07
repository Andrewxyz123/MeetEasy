import 'package:frontend/controllers/UserController.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:frontend/constants/constants.dart';

import 'package:get/get.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {

  final TextEditingController _nameController = TextEditingController();

  final UserController _userController = Get.find<UserController>();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size.width;

    String? nameValue = _userController.currentUser.value?.fullname;
    // String? passwordValue = _userController.currentUser.value?.password;

    _nameController.text = nameValue!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Story Reel',
          style: GoogleFonts.montserrat(
            fontSize: size * 0.060,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(height: 30,),
              Form(child: Column(
                children: [
                  TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _nameController,
                      validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
                      decoration: myInputDecoration('Name')
                  ),
                  // TextFormField(
                  //     keyboardType: TextInputType.name,
                  //     controller: _usernameController,
                  //     validator: (val) => val!.isEmpty ? 'Invalid Password' : null,
                  //     decoration: myInputDecoration('Username')
                  // ),
                  SizedBox(height: 30,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _loading = true;
                        });
                        _userController.updateUser(fullname: _nameController.text.trim());
                        _loading = false;
                        AlertDialog alert = AlertDialog(
                          title: Text("Update Profile"),
                          content: Container(
                            child: Text("Profile Succesfully Updated!"),
                          ),
                          
                          actions: [
                            TextButton(
                              child: Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                                // Get.offAll(() => const HomePage(initialIndex: 2,)); // Navigate to HomePage and remove all previous routes
                              },
                            ),
                          ],
                        );
                        showDialog(context: context, builder: (context) => alert);
                      },
                      child: Text('Edit Profile', style: GoogleFonts.montserrat(
                        fontSize: size * 0.040,
                        color: Colors.white,
                      ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                    ),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}