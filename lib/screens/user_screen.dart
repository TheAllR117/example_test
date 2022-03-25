import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:users_app/providers/user_form_provider.dart';

import 'package:users_app/services/services.dart';

import 'package:users_app/ui/input_decorations.dart';
import 'package:users_app/widgets/widgets.dart';

class UserScreen extends StatefulWidget {
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);

    return ChangeNotifierProvider(
      create: (_) => UserFormProvider(userService.selectedUser),
      child: _UserScreenBody(productService: userService),
    );
  }
}

class _UserScreenBody extends StatelessWidget {
  const _UserScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final UserService productService;

  @override
  Widget build(BuildContext context) {
    final userForm = Provider.of<UserFormProvider>(context);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (currentFocus.canRequestFocus) {
            FocusScope.of(context).requestFocus(new FocusNode());
          }
        },
        child: SingleChildScrollView(
          // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                  ),
                  UserImage(url: productService.selectedUser.picture),
                  Positioned(
                      top: 60,
                      left: 20,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.arrow_back_ios_new,
                            size: 30, color: Colors.black),
                      )),
                  Positioned(
                      top: 60,
                      right: 20,
                      child: IconButton(
                        onPressed: () async {
                          final picker = new ImagePicker();
                          final PickedFile? pickedFile = await picker.getImage(
                              // source: ImageSource.gallery,
                              source: ImageSource.camera,
                              imageQuality: 100);

                          if (pickedFile == null) {
                            print('No seleccionó nada');
                            return;
                          }

                          productService
                              .updateSelectedUserImage(pickedFile.path);
                        },
                        icon: Icon(Icons.camera_alt_outlined,
                            size: 30, color: Colors.black),
                      ))
                ],
              ),
              _UserForm(),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: productService.isSaving
            ? CircularProgressIndicator(color: Colors.white)
            : Icon(Icons.save_outlined),
        onPressed: productService.isSaving
            ? null
            : () async {
                if (!userForm.isValidForm()) return;

                final String? imageUrl = await productService.uploadImage();

                if (imageUrl != null) userForm.user.picture = imageUrl;

                await productService.saveOrCreateUser(userForm.user);
              },
      ),
    );
  }
}

class _UserForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userForm = Provider.of<UserFormProvider>(context);
    final user = userForm.user;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: Form(
          key: userForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                initialValue: user.name,
                onChanged: (value) => user.name = value,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'El nombre es obligatorio';
                  return null;
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Nombre del producto', labelText: 'Nombre:'),
              ),
              SizedBox(height: 30),
              TextFormField(
                initialValue: '${user.lastname}',
                onChanged: (value) => user.lastname = value,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'El Apellido es obligatorio';
                  return null;
                },
                keyboardType: TextInputType.name,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Apellidos', labelText: 'Apellidos'),
              ),
              SizedBox(height: 30),
              TextFormField(
                initialValue: '${user.email}',
                onChanged: (value) => user.email = value,
                validator: (value) {
                  Pattern pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = new RegExp(pattern.toString());
                  if (!regExp.hasMatch(value!)) {
                    return 'Este correo se ve algo raro.';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'example@mail.com', labelText: 'Email:'),
              ),
              SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }
}
