enum AchievementType {
  collection,    // 收集成就
  level,         // 等級成就
  event,         // 事件成就
  special        // 特殊成就
}

enum GachaType {
  normal,    // 普通抽卡
  premium,   // 高級抽卡
  limited,   // 限定抽卡
  event      // 活動抽卡
}

enum CardRank {
  N,    // 普通
  R,    // 稀有
  SR,   // 超稀有
  SSR;  // 特殊超稀有

  String toLowerCase() => name.toLowerCase();
} 