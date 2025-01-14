import 'package:flutter/material.dart';

const url = 'http://10.0.2.2:8080/api'; //server url

// URLs
const loginURL = url + '/users/login-user';
const registerURL = url + 'register';
const bookingURL = url + '/bookings';
const roomURL = url + '/rooms';
const userURL = url + '/users';

// ----- Errors -----
const serverError = 'Server error.';
const unauthorized = 'Unauthorized Access.';
const somethingWentWrong = 'Something went wrong, try again!';

InputDecoration myInputDecoration(String label) {
  return InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.all(10),
      border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black))
    );
}

TextButton myTextButton(String label, Function onPressed){
  return TextButton(
    child: Text(label, style: TextStyle(color: Colors.white),),
    style: ButtonStyle(
      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
      padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.symmetric(vertical: 10))
    ),
    onPressed: () => onPressed(),
  );
}


