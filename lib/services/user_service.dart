import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:users_app/models/models.dart';
import 'package:http/http.dart' as http;

class UserService extends ChangeNotifier {
  final String _baseUrl = 'exmplework-44618-default-rtdb.firebaseio.com';
  final List<User> users = [];
  late User selectedUser;

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  UserService() {
    this.loadUsers();
  }

  Future<List<User>> loadUsers() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'users.json');
    final resp = await http.get(url);
    print(json.decode(resp.body));
    final Map<String, dynamic> userMap = json.decode(resp.body);

    userMap.forEach((key, value) {
      final tempUser = User.fromMap(value);
      tempUser.id = key;
      this.users.add(tempUser);
    });

    this.isLoading = false;
    notifyListeners();

    return this.users;
  }

  Future saveOrCreateUser(User user) async {
    isSaving = true;
    notifyListeners();

    if (user.id == null) {
      // Es necesario crear
      await this.createUser(user);
    } else {
      // Actualizar
      await this.updateUser(user);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateUser(User user) async {
    final url = Uri.https(_baseUrl, 'users/${user.id}.json');
    final resp = await http.put(url, body: user.toJson());
    // ignore: unused_local_variable
    final decodedData = resp.body;

    final index = this.users.indexWhere((element) => element.id == user.id);
    this.users[index] = user;

    return user.id!;
  }

  Future<String> createUser(User user) async {
    final url = Uri.https(_baseUrl, 'users.json');
    final resp = await http.post(url, body: user.toJson());
    final decodedData = json.decode(resp.body);

    user.id = decodedData['name'];

    this.users.add(user);

    return user.id!;
  }

  void updateSelectedUserImage(String path) {
    this.selectedUser.picture = path;
    this.newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (this.newPictureFile == null) return null;

    this.isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/diztcxhqb/image/upload?upload_preset=ibpuzr5e');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('algo salio mal');
      print(resp.body);
      return null;
    }

    this.newPictureFile = null;

    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}
