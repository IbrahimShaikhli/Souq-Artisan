import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../config/auth.dart';
import 'components/purchase_history.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  static String routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User? user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _uploadImage(XFile imageFile) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('users/${user!.uid}/profile_picture/image.jpg');

    final uploadTask = storageRef.putFile(File(imageFile.path));
    final snapshot = await uploadTask.whenComplete(() {});

    if (snapshot.state == TaskState.success) {
      final downloadURL = await snapshot.ref.getDownloadURL();

      print("Download URL: $downloadURL");

      await _firestore
          .collection('users')
          .doc(user!.uid)
          .set({'profilePictureUrl': downloadURL}, SetOptions(merge: true));
    }
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      await _uploadImage(pickedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _firestore.collection('users').doc(user!.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error fetching data');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData) {
          return const Text('No data available');
        }

        final userData = snapshot.data!.data();

        final profilePictureUrl = userData?['profilePictureUrl'];
        final ImageProvider<Object>? backgroundImage = profilePictureUrl != null
            ? NetworkImage(profilePictureUrl) // Use the URL directly
            : const AssetImage('asset/images/placeholder.png')
                as ImageProvider<Object>?;

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey, // Set a background color for the avatar
                      child: ClipOval(
                        child: SizedBox(
                          width: 100, // Adjust the size as needed
                          height: 100,
                          child: backgroundImage != null
                              ? Image(
                            image: backgroundImage,
                            fit: BoxFit.cover, // Make the image fit properly
                          )
                              : Image.asset(
                            'asset/images/placeholder.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 35,
                        width: 35,
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.deepOrangeAccent,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () async {
                            await _pickImage();
                            // Refresh the UI after image update
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Text(userData?['name'], style: const TextStyle(fontSize: 20)),
                Text(userData?['email'], style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 20),
                Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                        width: 1, color: Colors.deepOrangeAccent),
                  ),
                  child: SizedBox(
                    height: 380,
                    child: ListView(
                      children: <Widget>[
                        ProfileListItem(
                          icon: Icons.lock,
                          text: 'Privacy',
                          onTap: () {},
                        ),
                        ProfileListItem(
                          icon: Icons.history,
                          text: 'Purchase History',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OrderHistoryScreen(user: user),
                              ),
                            );
                          },
                        ),
                        ProfileListItem(
                          icon: Icons.help,
                          text: 'Help & Support',
                          onTap: () {},
                        ),
                        ProfileListItem(
                          icon: Icons.settings,
                          text: 'Settings',
                          onTap: () {},
                        ),
                        ProfileListItem(
                          icon: Icons.person_add,
                          text: 'Invite a Friend',
                          onTap: () {},
                        ),
                        ProfileListItem(
                          icon: Icons.exit_to_app,
                          text: 'Logout',
                          onTap: () {
                            Authentication().logout();
                            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ProfileListItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 35,
        color: Colors.deepOrange,
      ),
      title: Text(text, style: const TextStyle(fontSize: 18)),
      onTap: onTap,
    );
  }
}
