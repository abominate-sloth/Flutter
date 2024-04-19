import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'item.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FishScreen extends StatelessWidget {
  final Item item;

  FishScreen({required this.item});

  Future<List<String>> loadImages() async {

      firebase_storage.Reference imRef = firebase_storage.FirebaseStorage.instance.ref('FishImages').child(item.title);
      firebase_storage.ListResult result = await imRef.listAll();

      List<String> imageUrls = [];
      for (int i = 0; i < result.items.length; i++) {
        firebase_storage.Reference ref = result.items[i];
        String imageUrl = await ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      return imageUrls;
  }

  Future<void> makeFav()
  async {
    String? uid;
    User? user = FirebaseAuth.instance.currentUser;
    uid = user?.uid;
    bool? res = false;

    DatabaseReference ref = FirebaseDatabase.instance.ref("users").child(uid!).child("Favorites");

    DataSnapshot snapshot = await ref.child(item.title).get();

    if (snapshot.exists) {
         res = snapshot.value as bool;
      }

    ref.child(item.title).set(!(res!));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: Column(
        children: [
          Container(
            height: 150,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Text(
                item.text,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              makeFav();
            },
            child: Text('Добавить в избранное'),
          ),
          SizedBox(height: 10),
          FutureBuilder<List<String>>(
            future: loadImages(),
            builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.hasData && snapshot.data!.isEmpty) {
                return Text('Нет доступных изображений');
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0), // Задайте желаемые значения отступов здесь
                      child: Image.network(snapshot.data![index]),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}