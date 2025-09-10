import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/model/enums.dart';
import 'package:uuid/uuid.dart';

class RoleManager {
  static final RoleManager _instance = RoleManager._internal();
  static RoleManager get instance => _instance;
  
  final _uuid = Uuid();
  
  List<CardModel> availableRoles = [];
  CardModel? currentRole;

  RoleManager._internal() {
    _initRoles();
  }

  void _initRoles() {
    availableRoles = [];
  }

  void setCurrentRole(CardModel role) {
    currentRole = role;
  }

  CardModel? getCurrentRole() {
    return currentRole;
  }

  List<CardModel> getAvailableRoles() {
    return availableRoles;
  }

  void resetCurrentRole() {
    currentRole = null;
  }

  bool hasCurrentRole() {
    return currentRole != null;
  }

  Future<void> addCard(CardModel card) async {
    if (!availableRoles.any((role) => role.id == card.id)) {
      availableRoles.add(card);
    }
  }
} 