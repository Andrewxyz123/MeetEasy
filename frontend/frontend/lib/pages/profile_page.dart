import 'package:frontend/pages/profile_views/update_profile_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/controllers/UserController.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    // String? nameValue = _userController.currentUser.value?.fullname;

    // String? currentUserRole = _userController.currentUser.value?.user_role;

    return Scaffold(
      body: Column(
        children: [
          const Expanded(flex: 2, child: _TopPortion()),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        // nameValue!,
                        'Jake',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      // Other profile details here
                      ListTile(
                        // leading: Container(
                        //   width: 40,
                        //   height: 40,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(100),
                        //     color: Colors.blueGrey[100]
                        //   ),
                        //   child: ,
                        // ),
                        title: Text("User's Story Reel"),
                        onTap: (){
                          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const UserReelScreen()));
                        },
                        trailing: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.blueGrey[100]
                          ),
                          child: const Icon(LineAwesomeIcons.angle_right_solid, size: 18, color: Colors.black),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: Text("Edit Profile"),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const UpdateProfilePage()));
                        },
                        trailing: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.blueGrey[100]
                          ),
                          child: const Icon(LineAwesomeIcons.angle_right_solid, size: 18, color: Colors.black),
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                    ),
                    child: OutlinedButton(
                      onPressed: () {
                        // _userController.logout().then((value) => {
                          // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginPage()), (route) => false)
                        // });
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black), // Black border
                      ),
                      child: Text(
                        "Logout",
                        style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xff0043ba), Color(0xff006df1)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
