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
    availableRoles = [
      CardModel.createProgrammerCard(
        name: '程式設計師',
        rank: CardRank.SSR,
        connect: 3,
        hpAdd: 100,
        mpAdd: 150,
        pointAdd: 120,
        createAdd: 80,
        popularAdd: 60,
      ),
      CardModel.createDesignerCard(
        name: '設計師',
        rank: CardRank.SSR,
        connect: 3,
        hpAdd: 90,
        mpAdd: 140,
        pointAdd: 100,
        createAdd: 120,
        popularAdd: 80,
      ),
      CardModel.createManagerCard(
        name: '專案經理',
        rank: CardRank.SSR,
        connect: 4,
        hpAdd: 120,
        mpAdd: 130,
        pointAdd: 110,
        createAdd: 70,
        popularAdd: 100,
      ),
      CardModel.createMarketerCard(
        name: '行銷專員',
        rank: CardRank.SSR,
        connect: 3,
        hpAdd: 80,
        mpAdd: 120,
        pointAdd: 90,
        createAdd: 100,
        popularAdd: 120,
      ),
    ];
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