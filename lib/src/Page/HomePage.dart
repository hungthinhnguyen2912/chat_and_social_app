import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/src/database/firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController postController = TextEditingController();
  final fireStoreDatabase fsdb = fireStoreDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'W A L L',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Icon(
                Icons.favorite,
                size: 76,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('H O M E'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.supervised_user_circle),
              title: Text('U S E R S'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/UserPage');
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('P R O F I L E'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/ProfilePage');
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('L O G O U T'),
                onTap: logOut,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: postController,
              decoration: InputDecoration(
                  hintText: 'Say some thing',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16))),
            ),
          ),
          TextButton(
            onPressed: () {
              if (postController.text.isNotEmpty) {
                String message = postController.text;
                fsdb.addPost(message);
              }
              postController.clear();
            },
            child: Text('Post'),
          ),
          StreamBuilder(
            stream: fsdb.getPostStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Something went wrong: ${snapshot.error}'),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('No Data'),
                );
              }
              final posts = snapshot.data!.docs;
              return Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return ListTile(
                      title: Text(post['postMessage']),
                      subtitle: Text(post['email']),
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void logOut() {
    FirebaseAuth.instance.signOut();
  }
}
