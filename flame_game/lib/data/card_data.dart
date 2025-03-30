import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/model/enums.dart';

class CardData {
  static final List<CardModel> programmerCards = [
    CardModel.createProgrammerCard(
      name: '資深工程師',
      rank: CardRank.SSR,
      connect: 5,
      hpAdd: 100,
      mpAdd: 100,
      pointAdd: 100,
      createAdd: 100,
      popularAdd: 100,
    ),
    CardModel.createProgrammerCard(
      name: '中級工程師',
      rank: CardRank.SR,
      connect: 3,
      hpAdd: 50,
      mpAdd: 50,
      pointAdd: 50,
      createAdd: 50,
      popularAdd: 50,
    ),
    CardModel.createProgrammerCard(
      name: '初級工程師',
      rank: CardRank.R,
      connect: 2,
      hpAdd: 30,
      mpAdd: 30,
      pointAdd: 30,
      createAdd: 30,
      popularAdd: 30,
    ),
    CardModel.createProgrammerCard(
      name: '實習工程師',
      rank: CardRank.N,
      connect: 1,
      hpAdd: 10,
      mpAdd: 10,
      pointAdd: 10,
      createAdd: 10,
      popularAdd: 10,
    ),
  ];

  static final List<CardModel> designerCards = [
    CardModel.createDesignerCard(
      name: '資深設計師',
      rank: CardRank.SSR,
      connect: 5,
      hpAdd: 100,
      mpAdd: 100,
      pointAdd: 100,
      createAdd: 100,
      popularAdd: 100,
    ),
    CardModel.createDesignerCard(
      name: '中級設計師',
      rank: CardRank.SR,
      connect: 3,
      hpAdd: 50,
      mpAdd: 50,
      pointAdd: 50,
      createAdd: 50,
      popularAdd: 50,
    ),
    CardModel.createDesignerCard(
      name: '初級設計師',
      rank: CardRank.R,
      connect: 2,
      hpAdd: 30,
      mpAdd: 30,
      pointAdd: 30,
      createAdd: 30,
      popularAdd: 30,
    ),
    CardModel.createDesignerCard(
      name: '實習設計師',
      rank: CardRank.N,
      connect: 1,
      hpAdd: 10,
      mpAdd: 10,
      pointAdd: 10,
      createAdd: 10,
      popularAdd: 10,
    ),
  ];

  static final List<CardModel> managerCards = [
    CardModel.createManagerCard(
      name: '資深經理',
      rank: CardRank.SSR,
      connect: 5,
      hpAdd: 100,
      mpAdd: 100,
      pointAdd: 100,
      createAdd: 100,
      popularAdd: 100,
    ),
    CardModel.createManagerCard(
      name: '中級經理',
      rank: CardRank.SR,
      connect: 3,
      hpAdd: 50,
      mpAdd: 50,
      pointAdd: 50,
      createAdd: 50,
      popularAdd: 50,
    ),
    CardModel.createManagerCard(
      name: '初級經理',
      rank: CardRank.R,
      connect: 2,
      hpAdd: 30,
      mpAdd: 30,
      pointAdd: 30,
      createAdd: 30,
      popularAdd: 30,
    ),
    CardModel.createManagerCard(
      name: '實習經理',
      rank: CardRank.N,
      connect: 1,
      hpAdd: 10,
      mpAdd: 10,
      pointAdd: 10,
      createAdd: 10,
      popularAdd: 10,
    ),
  ];

  static final List<CardModel> marketerCards = [
    CardModel.createMarketerCard(
      name: '資深行銷',
      rank: CardRank.SSR,
      connect: 5,
      hpAdd: 100,
      mpAdd: 100,
      pointAdd: 100,
      createAdd: 100,
      popularAdd: 100,
    ),
    CardModel.createMarketerCard(
      name: '中級行銷',
      rank: CardRank.SR,
      connect: 3,
      hpAdd: 50,
      mpAdd: 50,
      pointAdd: 50,
      createAdd: 50,
      popularAdd: 50,
    ),
    CardModel.createMarketerCard(
      name: '初級行銷',
      rank: CardRank.R,
      connect: 2,
      hpAdd: 30,
      mpAdd: 30,
      pointAdd: 30,
      createAdd: 30,
      popularAdd: 30,
    ),
    CardModel.createMarketerCard(
      name: '實習行銷',
      rank: CardRank.N,
      connect: 1,
      hpAdd: 10,
      mpAdd: 10,
      pointAdd: 10,
      createAdd: 10,
      popularAdd: 10,
    ),
  ];

  static final List<CardModel> specialCards = [];

  static List<CardModel> getAllCards() {
    return [
      ...programmerCards,
      ...designerCards,
      ...managerCards,
      ...marketerCards,
      ...specialCards,
    ];
  }
} 