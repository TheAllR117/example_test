import 'package:flutter/material.dart';
import 'package:users_app/models/models.dart';

class UserFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  User user;

  UserFormProvider(this.user);

  updateAvailability(bool value) {
    print(value);
    notifyListeners();
  }

  bool isValidForm() {
    print(user.name);

    return formKey.currentState?.validate() ?? false;
  }
}
