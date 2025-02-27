import 'package:flutter/material.dart';
import 'package:frontend/controllers/BookingController.dart';
import '../controllers/loginController.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LoginPage extends StatelessWidget {
  // const LoginPage({super.key});
  // text field controller
  final companyIdController = TextEditingController();
  final employeeIdController = TextEditingController();
  final passwordController = TextEditingController();
  final LoginController loginController = LoginController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  

  void _requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
    if (await Permission.scheduleExactAlarm.isDenied) {
      openAppSettings(); // Direct user to settings
    }
  }

  void _initializeNotifications() async {
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: null);
    
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  



  void _showNotification() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    _requestNotificationPermission();
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your_channel_name',
      'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(), // Prevents potential issues
    );

    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //       0,
    //   'scheduled title',
    //   'scheduled body',
    //   tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
    //   platformChannelSpecifics,
    //   uiLocalNotificationDateInterpretation:UILocalNotificationDateInterpretation.absoluteTime, 
    //   androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    // );
    
    await flutterLocalNotificationsPlugin.show(
      0,
      'Booking Approved!',
      'Your booking for Room 101 at 13:00 has been approved.',
      platformChannelSpecifics,
    );

    print('Notification triggered');
    print(tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)));
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the current theme
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.meeting_room_outlined,
                size: 64.0,
                color: theme.primaryColor, // Use primary color from theme
              ),
              SizedBox(height: 16.0),
              Text(
                'Meeting Room',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: theme.primaryColor, // Modify color if necessary
                ),
              ),
              SizedBox(height: 32.0),
              TextField(
                controller: companyIdController,
                decoration: InputDecoration(
                  labelText: 'Company ID',
                  border: theme.inputDecorationTheme.border, // Use border style from theme
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: employeeIdController,
                decoration: InputDecoration(
                  labelText: 'Employee ID',
                  border: theme.inputDecorationTheme.border, // Use border style from theme
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: theme.inputDecorationTheme.border, // Use border style from theme
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  // Handle login action
                  loginController.loginUser(
                    company_id: companyIdController.text,
                    employee_id: employeeIdController.text,
                    password: passwordController.text,
                    context: context,
                  );
                },
                style: theme.elevatedButtonTheme.style?.copyWith(
                  minimumSize: MaterialStateProperty.all(Size(double.infinity, 48.0)),
                ),
                child: Text(
                  'Login',
                  style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      // Handle forgot password
                    },
                    child: Text(
                      'Forgot Password?',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.primaryColor, // Match theme primary color
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  TextButton(
                    onPressed: _showNotification,
                    child: Text(
                      'Contact Support',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.primaryColor, // Match theme primary color
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
