import 'dart:io';

import 'package:flutter/material.dart';

class UserImage extends StatelessWidget {
  final String? url;

  const UserImage({Key? key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment(0, 0),
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: _buildBoxDecoration(),
            width: 100,
            height: 100,
            child: Opacity(
              opacity: 0.9,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  child: getImage(url)),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45), topRight: Radius.circular(45)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 5))
          ]);

  Widget getImage(String? picture) {
    if (picture == null)
      return Image(
        image: AssetImage('assets/no-image.png'),
        fit: BoxFit.cover,
      );

    if (picture.startsWith('http'))
      return FadeInImage(
        image: NetworkImage(this.url!),
        placeholder: AssetImage('assets/animation_500_l15z5005.gif'),
        fit: BoxFit.cover,
      );

    return Image.file(
      File(picture),
      fit: BoxFit.cover,
    );
  }
}
