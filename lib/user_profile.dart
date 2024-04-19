import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'log_in.dart';
import 'user_info.dart';

class UserScreen extends StatefulWidget {
  final MyUserInfo userInfo;

  UserScreen({required this.userInfo});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late MyUserInfo _userInfo;

  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _favoriteFishController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userInfo = widget.userInfo;

    _nicknameController.text = _userInfo.nickname;
    _nameController.text = _userInfo.name;
    _surnameController.text = _userInfo.surname;
    _ageController.text = _userInfo.age;
    _genderController.text = _userInfo.gender;
    _phoneController.text = _userInfo.phone;
    _countryController.text = _userInfo.country;
    _birthDateController.text = _userInfo.birthDate;
    _favoriteFishController.text = _userInfo.favoriteFish;
  }

  void _logout() {
    FirebaseAuth.instance.signOut();
  }

  void _deleteAccount() {
    String? uid;
    User? user = FirebaseAuth.instance.currentUser;
    uid = user?.uid;

    DatabaseReference ref = FirebaseDatabase.instance.reference().child('users').child(uid!);
    ref.set({});
    user?.delete();
  }

  void _saveProfile() {
    String? uid;
    User? user = FirebaseAuth.instance.currentUser;
    uid = user?.uid;

    DatabaseReference ref = FirebaseDatabase.instance.reference().child('users').child(uid!).child('UserInfo');
    ref.set(
        {
          "nickname": _userInfo.nickname,
          "email": _userInfo.email,
          "name": _userInfo.name,
          "surname": _userInfo.surname,
          "age": _userInfo.age,
          "gender": _userInfo.gender,
          "phone": _userInfo.phone,
          "country": _userInfo.country,
          "birthDate": _userInfo.birthDate,
          "favoriteFish": _userInfo.favoriteFish,
        }
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль пользователя'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed:()
                  {
                    _logout();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyLoginPage()),
                    );
                  },
                  icon: Icon(Icons.exit_to_app),
                ),
                Spacer(),
                IconButton(
                  onPressed:()
                  {
                    _deleteAccount();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyLoginPage()),
                    );
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Ник пользователя'),
                      controller: _nicknameController,
                      onChanged: (value) {
                        setState(() {
                          _userInfo.nickname = value;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    Text('Почта пользователя: ${_userInfo.email}'),
                    SizedBox(height: 16.0),
                    TextField(
                      decoration: InputDecoration(labelText: 'Имя'),
                      controller: _nameController,
                      onChanged: (value) {
                        setState(() {
                          _userInfo.name = value;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      decoration: InputDecoration(labelText: 'Фамилия'),
                      controller: _surnameController,
                      onChanged: (value) {
                        setState(() {
                          _userInfo.surname = value;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      decoration: InputDecoration(labelText: 'Возраст'),
                      controller: _ageController,
                      onChanged: (value) {
                        setState(() {
                          _userInfo.age = value;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      decoration: InputDecoration(labelText: 'Пол'),
                      controller: _genderController,
                      onChanged: (value) {
                        setState(() {
                          _userInfo.gender = value;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      decoration: InputDecoration(labelText: 'Мобильный номер'),
                      controller: _phoneController,
                      onChanged: (value) {
                        setState(() {
                          _userInfo.phone = value;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      decoration: InputDecoration(labelText: 'Страна'),
                      controller: _countryController,
                      onChanged: (value) {
                        setState(() {
                          _userInfo.country = value;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      decoration: InputDecoration(labelText: 'Дата рождения'),
                      controller: _birthDateController,
                      onChanged: (value) {
                        setState(() {
                          _userInfo.birthDate = value;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      decoration: InputDecoration(labelText: 'Любимая рыба'),
                      controller: _favoriteFishController,
                      onChanged: (value) {
                        setState(() {
                          _userInfo.favoriteFish = value;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _saveProfile,
              icon: Icon(Icons.save),
              label: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}