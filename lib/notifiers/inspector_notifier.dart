import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:tfg/modelo/user.dart';

class InspectorNotifier with ChangeNotifier{
  List<Usuario> _inspectorList = [];
  Usuario _currentInspector;

  UnmodifiableListView<Usuario> get inspectorList => UnmodifiableListView(_inspectorList);

  Usuario get currentInspector => _currentInspector;

  set inspectorList(List<Usuario> inspectorList){
    _inspectorList = inspectorList;
    notifyListeners();
  }

  set currentInspector(Usuario inspector){
    _currentInspector = inspector;
    notifyListeners();
  }
}