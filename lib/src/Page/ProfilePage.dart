import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/src/database/userfirestore.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserdetails() async {
    if (currentUser == null) {
      throw Exception('User is not logged in.');
    }
    print('Current User Email: ${currentUser!.uid}');
    return FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: FutureBuilder(
        future: getUserdetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final user = snapshot.data!.data();
            if (user == null) {
              return Center(child: Text('User data not found.'));
            }
            final email =
                user.containsKey('email') ? user['email'] : 'No email';
            final username =
                user.containsKey('username') ? user['username'] : 'No username';
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.accessibility_sharp, size: 90),
                    SizedBox(height: 20),
                    Text(email, style: TextStyle(fontSize: 18)),
                    SizedBox(height: 20),
                    Text(username,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Expanded(
                      child: StreamBuilder(
                        stream: userFireStore().getByEmailPostStream(email),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            final posts = snapshot.data!.docs;
                            if (posts.isEmpty) {
                              return Center(child: Text('No posts available.'));
                            }
                            return ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                final post =
                                    posts[index].data() as Map<String, dynamic>;
                                return ListTile(
                                  title: Text(post['postMessage']),
                                  subtitle: Text(
                                      post['Timestamp'].toDate().toString()),
                                );
                              },
                            );
                          } else {
                            return Center(child: Text('No data.'));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }
}
