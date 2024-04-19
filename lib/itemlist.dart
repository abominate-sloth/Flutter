import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lab2/my_list_item.dart';
import 'package:lab2/user_profile.dart';
import 'user_info.dart';
import 'item.dart';

class ItemScreen extends StatefulWidget {
  @override
  _ItemScreenState createState() => _ItemScreenState();
}

Future<bool> IsFav(title)
async {
  String? uid;
  User? user = FirebaseAuth.instance.currentUser;
  uid = user?.uid;
  bool? res = false;

  DatabaseReference ref = FirebaseDatabase.instance.ref("users").child(uid!).child("Favorites");

  DataSnapshot snapshot = await ref.child(title).get();

  if (snapshot.exists) {
    res = snapshot.value as bool;
  }
  return res;
}

Future<List<Item>> fetchItems(bool isFavNow) async {
  DatabaseReference refFish = FirebaseDatabase.instance.reference().child('fishBook');

  final allFishSnapshot = await refFish.once();
  final allData =
  Map<String, dynamic>.from(allFishSnapshot.snapshot.value as Map);
  List<Item> items = [];
  for (final fish in allData.values.toList())
  {

    if(isFavNow)
      {
        if(await IsFav(fish['title']))
          items.add(Item(fish['title'],fish['desc'],fish['text']));
      }
    else
      {
        items.add(Item(fish['title'],fish['desc'],fish['text']));
      }
  }
  return items;
}

class _ItemScreenState extends State<ItemScreen> {
  Future<List<Item>>? _itemsFuture;
  bool isFavNow = false;

  @override
  void initState() {
    super.initState();
    _itemsFuture = fetchItems(isFavNow);
  }

  void _reloadData() {
    setState(() {
      isFavNow = !isFavNow;
      _itemsFuture = fetchItems(isFavNow);
    });
  }

   Future<MyUserInfo> ReadUser()
   async {
     String? uid;
     User? user = FirebaseAuth.instance.currentUser;
     uid = user?.uid;

     DatabaseReference ref = FirebaseDatabase.instance.reference().child('users').child(uid!).child('UserInfo');

     final allFishSnapshot = await ref.once();
     final data = Map<String, dynamic>.from(allFishSnapshot.snapshot.value as Map);

     String nickname = data.containsKey('nickname') ? data['nickname'] : '';
     String email = data.containsKey('email') ? data['email'] : '';
     String name = data.containsKey('name') ? data['name'] : '';
     String surname = data.containsKey('surname') ? data['surname'] : '';
     String age = data.containsKey('age') ? data['age'] : '';
     String gender = data.containsKey('gender') ? data['gender'] : '';
     String phone = data.containsKey('phone') ? data['phone'] : '';
     String country = data.containsKey('country') ? data['country'] : '';
     String birthDate = data.containsKey('birthDate') ? data['birthDate'] : '';
     String favoriteFish = data.containsKey('favoriteFish') ? data['favoriteFish'] : '';

     MyUserInfo res = MyUserInfo(nickname, email, name, surname, age, gender, phone, country, birthDate, favoriteFish);

     return res;
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Screen'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () async {

                  MyUserInfo info = await ReadUser();

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserScreen(userInfo: info,)),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  _reloadData();
                },
              ),
            ],
          ),
          FutureBuilder(
            future: _itemsFuture,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                List<Item>? items = snapshot.data;

                return Expanded
                  (
                  child: ListView.builder(
                    itemCount: items?.length,
                    itemBuilder: (context, index)
                    {
                      Item item = items![index];
                      return MyItem(item);
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}