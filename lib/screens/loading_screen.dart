import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.transparent,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
