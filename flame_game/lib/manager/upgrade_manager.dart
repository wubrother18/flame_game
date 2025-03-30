import 'dart:math';

class UpgradeManager {
  Map<String, Map<String, dynamic>> availableUpgrades = {};
  Map<String, int> currentLevels = {};

  UpgradeManager() {
    _initUpgrades();
  }

  void _initUpgrades() {
    availableUpgrades = {
      'hp': {
        'name': '體力提升',
        'description': '增加最大體力值',
        'baseCost': 100,
        'costMultiplier': 1.5,
        'effectMultiplier': 1.2,
      },
      'mp': {
        'name': '靈感提升',
        'description': '增加最大靈感值',
        'baseCost': 100,
        'costMultiplier': 1.5,
        'effectMultiplier': 1.2,
      },
      'point': {
        'name': '專業提升',
        'description': '增加專業度獲取',
        'baseCost': 150,
        'costMultiplier': 1.8,
        'effectMultiplier': 1.3,
      },
      'create': {
        'name': '創意提升',
        'description': '增加創意點數獲取',
        'baseCost': 150,
        'costMultiplier': 1.8,
        'effectMultiplier': 1.3,
      },
      'popular': {
        'name': '人氣提升',
        'description': '增加人氣值獲取',
        'baseCost': 200,
        'costMultiplier': 2.0,
        'effectMultiplier': 1.4,
      },
    };
  }

  Map<String, Map<String, dynamic>> getAvailableUpgrades() {
    return availableUpgrades;
  }

  Map<String, int> getCurrentLevels() {
    return currentLevels;
  }

  int getCurrentLevel(String upgradeId) {
    return currentLevels[upgradeId] ?? 0;
  }

  int getUpgradeCost(String upgradeId) {
    final upgrade = availableUpgrades[upgradeId];
    if (upgrade == null) return 0;

    final currentLevel = getCurrentLevel(upgradeId);
    return (upgrade['baseCost'] * pow(upgrade['costMultiplier'], currentLevel)).round();
  }

  bool canUpgrade(String upgradeId, int currentPoints) {
    return currentPoints >= getUpgradeCost(upgradeId);
  }

  bool upgrade(String upgradeId) {
    if (!availableUpgrades.containsKey(upgradeId)) return false;

    currentLevels[upgradeId] = (currentLevels[upgradeId] ?? 0) + 1;
    return true;
  }

  double getEffectMultiplier(String upgradeId) {
    final upgrade = availableUpgrades[upgradeId];
    if (upgrade == null) return 1.0;

    final currentLevel = getCurrentLevel(upgradeId);
    return pow(upgrade['effectMultiplier'], currentLevel).toDouble();
  }

  void resetUpgrades() {
    currentLevels.clear();
  }

  Map<String, dynamic> getUpgradeInfo(String upgradeId) {
    return availableUpgrades[upgradeId] ?? {};
  }
} 