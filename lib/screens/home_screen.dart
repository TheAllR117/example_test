import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:users_app/models/models.dart';
import 'package:users_app/screens/screens.dart';

import 'package:users_app/services/services.dart';
import 'package:users_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);

    if (userService.isLoading) return LoadingScreen();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Usuarios'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50))),
        child: ListView.builder(
            itemCount: userService.users.length,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
                  onTap: () {
                    userService.selectedUser = userService.users[index].copy();

                    Navigator.pushNamed(context, 'user');
                  },
                  child: UserCard(
                    product: userService.users[index],
                  ),
                )),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Lottie.asset('assets/60086-arrow-plus-x.json', reverse: true),
        onPressed: () {
          userService.selectedUser = new User(
            email: '',
            lastname: '',
            name: '',
          );
          Navigator.pushNamed(context, 'user');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
