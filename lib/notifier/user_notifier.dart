import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:tfg/modelo/user.dart';

class UserNotifier with ChangeNotifier{
  List<Usuario> _userList = [];
  Usuario _currentUser;

  UnmodifiableListView<Usuario> get userList => UnmodifiableListView(_userList);

  Usuario get currentUsuario => _currentUser;

  set userList(List<Usuario> userList){
    _userList = userList;
    notifyListeners();
  }

  set currentUser(Usuario user){
    _currentUser = user;
    notifyListeners();
  }
}