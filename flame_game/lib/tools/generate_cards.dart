import 'dart:math';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;

class CardGenerator {
  static final Random _random = Random();
  
  // 科技前綴
  static final List<String> _techPrefixes = [
    '量子', 'AI', '雲端', '區塊鏈', '元宇宙', '虛擬', '數位', '智能', '數據', '演算法',
    '機器學習', '深度學習', '神經網絡', '大數據', '物聯網', '5G', '邊緣計算', '雲原生', '微服務', '容器化'
  ];

  // 奇幻前綴
  static final List<String> _fantasyPrefixes = [
    '魔法', '元素', '能量', '靈魂', '星辰', '時空', '次元', '異界', '虛空', '混沌',
    '光明', '黑暗', '風暴', '火焰', '冰霜', '雷電', '大地', '海洋', '天空', '森林'
  ];

  // 熱血前綴
  static final List<String> _passionPrefixes = [
    '鬥志', '勇氣', '信念', '夢想', '熱血', '激情', '決心', '意志', '毅力', '堅持',
    '奮鬥', '拼搏', '挑戰', '突破', '超越', '進化', '覺醒', '覺悟', '覺醒', '覺悟'
  ];

  // 職業類型（更新為更具科技感的職業）
  static final List<String> _professions = [
    '工程師', '架構師', '科學家', '研究員', '開發者', '設計師', '分析師', '專家', '大師', '導師',
    '先驅', '探索者', '開拓者', '創新者', '變革者', '引領者', '守護者', '創造者', '實踐者', '夢想家'
  ];

  // 職業對應的圖標
  static final Map<String, String> _professionIcons = {
    '工程師': 'code',
    '架構師': 'architecture',
    '科學家': 'science',
    '研究員': 'biotech',
    '開發者': 'devices',
    '設計師': 'palette',
    '分析師': 'analytics',
    '專家': 'psychology',
    '大師': 'stars',
    '導師': 'school',
    '先驅': 'explore',
    '探索者': 'travel_explore',
    '開拓者': 'public',
    '創新者': 'lightbulb',
    '變革者': 'auto_awesome',
    '引領者': 'leaderboard',
    '守護者': 'security',
    '創造者': 'brush',
    '實踐者': 'handyman',
    '夢想家': 'auto_awesome_motion',
    '量子': 'science',
    'AI': 'smart_toy',
    '雲端': 'cloud',
    '區塊鏈': 'currency_bitcoin',
    '元宇宙': 'view_in_ar',
    '虛擬': 'view_in_ar',
    '數位': 'digital_out_of_home',
    '智能': 'psychology',
    '數據': 'analytics',
    '演算法': 'functions',
    '機器學習': 'smart_toy',
    '深度學習': 'psychology',
    '神經網絡': 'hub',
    '大數據': 'analytics',
    '物聯網': 'devices',
    '5G': 'wifi',
    '邊緣計算': 'cloud',
    '雲原生': 'cloud',
    '微服務': 'apps',
    '容器化': 'inventory',
    '魔法': 'auto_awesome',
    '元素': 'water_drop',
    '能量': 'bolt',
    '靈魂': 'psychology',
    '星辰': 'stars',
    '時空': 'schedule',
    '次元': 'view_in_ar',
    '異界': 'public',
    '虛空': 'dark_mode',
    '混沌': 'auto_awesome',
    '光明': 'light_mode',
    '黑暗': 'dark_mode',
    '風暴': 'air',
    '火焰': 'local_fire_department',
    '冰霜': 'ac_unit',
    '雷電': 'bolt',
    '大地': 'landscape',
    '海洋': 'water',
    '天空': 'air',
    '森林': 'forest',
  };

  // 形容詞
  static final List<String> _adjectives = [
    '熱情的', '認真的', '創新的', '細心的', '專業的',
    '有經驗的', '充滿活力的', '沉穩的', '靈活的', '專注的',
    '有創意的', '善於溝通的', '邏輯清晰的', '富有想像力的', '追求完美的'
  ];

  // 事件標題（更新為更具科技感和奇幻感的事件）
  static final List<String> _eventTitles = [
    '量子躍遷', '數據覺醒', '代碼重構', '系統優化', '架構革新',
    '雲端部署', '區塊鏈共識', 'AI訓練', '神經網絡進化', '深度學習突破',
    '元宇宙探索', '虛擬實境開發', '邊緣計算優化', '容器化部署', '微服務重構',
    '5G應用開發', '物聯網整合', '大數據分析', '機器學習模型', '智能系統升級'
  ];

  // L 級獨特事件
  static final List<Map<String, dynamic>> _lUniqueEvents = [
    {
      'title': '世界變革',
      'description': '引領世界級技術革命\n體力 -60\n專業 +200\n靈感 +150\n創造力 +120\n人氣 +100',
      'mpEffect': 150,
      'hpEffect': -60,
      'pointEffect': 200,
      'createEffect': 120,
      'popularEffect': 100,
      'professionalEffect': 100,
      'randomAble': false,
    },
    {
      'title': '傳奇突破',
      'description': '實現傳奇級技術突破\n體力 -55\n專業 +180\n靈感 +140\n創造力 +110\n人氣 +90',
      'mpEffect': 140,
      'hpEffect': -55,
      'pointEffect': 180,
      'createEffect': 110,
      'popularEffect': 90,
      'professionalEffect': 90,
      'randomAble': false,
    },
  ];

  // UR 級獨特事件
  static final List<Map<String, dynamic>> _urUniqueEvents = [
    {
      'title': '究極革新',
      'description': '完成究極級技術革新\n體力 -50\n專業 +160\n靈感 +130\n創造力 +100\n人氣 +80',
      'mpEffect': 130,
      'hpEffect': -50,
      'pointEffect': 160,
      'createEffect': 100,
      'popularEffect': 80,
      'professionalEffect': 80,
      'randomAble': false,
    },
    {
      'title': '巔峰突破',
      'description': '達到技術巔峰\n體力 -45\n專業 +150\n靈感 +120\n創造力 +90\n人氣 +70',
      'mpEffect': 120,
      'hpEffect': -45,
      'pointEffect': 150,
      'createEffect': 90,
      'popularEffect': 70,
      'professionalEffect': 70,
      'randomAble': false,
    },
  ];

  // SSR 級獨特事件
  static final List<Map<String, dynamic>> _ssrUniqueEvents = [
    {
      'title': '技術革新',
      'description': '引領團隊完成重大技術突破\n體力 -45\n專業 +140\n靈感 +110\n創造力 +80\n人氣 +60',
      'mpEffect': 110,
      'hpEffect': -45,
      'pointEffect': 140,
      'createEffect': 80,
      'popularEffect': 60,
      'professionalEffect': 60,
      'randomAble': false,
    },
    {
      'title': '架構重生',
      'description': '成功完成系統架構重建\n體力 -40\n專業 +130\n靈感 +100\n創造力 +70\n人氣 +50',
      'mpEffect': 100,
      'hpEffect': -40,
      'pointEffect': 130,
      'createEffect': 70,
      'popularEffect': 50,
      'professionalEffect': 50,
      'randomAble': false,
    },
    {
      'title': '技術專利',
      'description': '獲得重要技術專利\n體力 -35\n專業 +120\n靈感 +90\n創造力 +60\n人氣 +40',
      'mpEffect': 90,
      'hpEffect': -35,
      'pointEffect': 120,
      'createEffect': 60,
      'popularEffect': 40,
      'professionalEffect': 40,
      'randomAble': false,
    },
  ];

  // SR 級獨特事件
  static final List<Map<String, dynamic>> _srUniqueEvents = [
    {
      'title': '技術突破',
      'description': '實現關鍵技術突破\n體力 -30\n專業 +100\n靈感 +80\n創造力 +50\n人氣 +30',
      'mpEffect': 80,
      'hpEffect': -30,
      'pointEffect': 100,
      'createEffect': 50,
      'popularEffect': 30,
      'professionalEffect': 30,
      'randomAble': false,
    },
    {
      'title': '創新方案',
      'description': '提出創新解決方案\n體力 -25\n專業 +90\n靈感 +70\n創造力 +45\n人氣 +25',
      'mpEffect': 70,
      'hpEffect': -25,
      'pointEffect': 90,
      'createEffect': 45,
      'popularEffect': 25,
      'professionalEffect': 25,
      'randomAble': false,
    },
  ];

  // R 級獨特事件
  static final List<Map<String, dynamic>> _rUniqueEvents = [
    {
      'title': '技術改進',
      'description': '成功改進現有技術\n體力 -20\n專業 +70\n靈感 +50\n創造力 +35\n人氣 +20',
      'mpEffect': 50,
      'hpEffect': -20,
      'pointEffect': 70,
      'createEffect': 35,
      'popularEffect': 20,
      'professionalEffect': 20,
      'randomAble': false,
    },
    {
      'title': '流程優化',
      'description': '優化工作流程\n體力 -15\n專業 +60\n靈感 +40\n創造力 +30\n人氣 +15',
      'mpEffect': 40,
      'hpEffect': -15,
      'pointEffect': 60,
      'createEffect': 30,
      'popularEffect': 15,
      'professionalEffect': 15,
      'randomAble': false,
    },
  ];

  // N 級獨特事件
  static final List<Map<String, dynamic>> _nUniqueEvents = [
    {
      'title': '初次突破',
      'description': '首次解決複雜問題\n體力 -10\n專業 +40\n靈感 +30\n創造力 +25\n人氣 +10',
      'mpEffect': 30,
      'hpEffect': -10,
      'pointEffect': 40,
      'createEffect': 25,
      'popularEffect': 10,
      'professionalEffect': 10,
      'randomAble': false,
    },
    {
      'title': '能力提升',
      'description': '技能水平顯著提升\n體力 -15\n專業 +35\n靈感 +25\n創造力 +20\n人氣 +5',
      'mpEffect': 25,
      'hpEffect': -15,
      'pointEffect': 35,
      'createEffect': 20,
      'popularEffect': 5,
      'professionalEffect': 5,
      'randomAble': false,
    },
  ];

  // 根據稀有度生成基礎屬性
  static Map<String, dynamic> _generateBaseStats(String rank) {
    int baseValue;
    switch (rank) {
      case 'L':
        baseValue = 100;
        break;
      case 'UR':
        baseValue = 85;
        break;
      case 'SSR':
        baseValue = 80;
        break;
      case 'SR':
        baseValue = 75;
        break;
      case 'R':
        baseValue = 70;
        break;
      default: // N
        baseValue = 65;
    }

    return {
      'hp': baseValue + _random.nextInt(10),
      'mp': baseValue + _random.nextInt(10),
      'point': baseValue + _random.nextInt(10),
      'create': baseValue + _random.nextInt(10),
      'popular': baseValue + _random.nextInt(10),
    };
  }

  // 生成事件
  static List<Map<String, dynamic>> _generateEvents(String rank, int count) {
    List<Map<String, dynamic>> events = [];
    for (int i = 0; i < count; i++) {
      String title = _eventTitles[_random.nextInt(_eventTitles.length)];
      int effectMultiplier;
      switch (rank) {
        case 'L':
          effectMultiplier = 5;
          break;
        case 'UR':
          effectMultiplier = 3;
          break;
        case 'SSR':
          effectMultiplier = 2;
          break;
        case 'SR':
          effectMultiplier = 1;
          break;
        case 'R':
          effectMultiplier = 1;
          break;
        default: // N
          effectMultiplier = 1;
      }

      events.add({
        'title': title,
        'description': '進行$title\n體力 -${20 + _random.nextInt(10)}\n專業 +${30 * effectMultiplier}\n靈感 +${20 * effectMultiplier}',
        'mpEffect': 20 * effectMultiplier,
        'hpEffect': -(20 + _random.nextInt(10)),
        'pointEffect': 30 * effectMultiplier,
        'createEffect': 20 * effectMultiplier,
        'popularEffect': 15 * effectMultiplier,
        'professionalEffect': 0,
        'randomAble': false,
      });
    }
    return events;
  }

  // 生成獨特事件
  static List<Map<String, dynamic>> _generateUniqueEvents(String rank) {
    List<Map<String, dynamic>> events = [];
    Map<String, dynamic> event;
    
    switch (rank) {
      case 'L':
        event = _lUniqueEvents[_random.nextInt(_lUniqueEvents.length)];
        break;
      case 'UR':
        event = _urUniqueEvents[_random.nextInt(_urUniqueEvents.length)];
        break;
      case 'SSR':
        event = _ssrUniqueEvents[_random.nextInt(_ssrUniqueEvents.length)];
        break;
      case 'SR':
        event = _srUniqueEvents[_random.nextInt(_srUniqueEvents.length)];
        break;
      case 'R':
        event = _rUniqueEvents[_random.nextInt(_rUniqueEvents.length)];
        break;
      default: // N
        event = _nUniqueEvents[_random.nextInt(_nUniqueEvents.length)];
    }
    events.add(event);
    return events;
  }

  // 生成卡片名稱
  static String _generateCardName(String rank) {
    String prefix = '';
    String profession = _professions[_random.nextInt(_professions.length)];
    
    switch (rank) {
      case 'L':
        prefix = _fantasyPrefixes[_random.nextInt(_fantasyPrefixes.length)];
        break;
      case 'UR':
        prefix = _techPrefixes[_random.nextInt(_techPrefixes.length)];
        break;
      case 'SSR':
        prefix = _passionPrefixes[_random.nextInt(_passionPrefixes.length)];
        break;
      case 'SR':
        if (_random.nextBool()) {
          prefix = _techPrefixes[_random.nextInt(_techPrefixes.length)];
        } else {
          prefix = _fantasyPrefixes[_random.nextInt(_fantasyPrefixes.length)];
        }
        break;
      case 'R':
        if (_random.nextBool()) {
          prefix = _passionPrefixes[_random.nextInt(_passionPrefixes.length)];
        } else {
          prefix = _techPrefixes[_random.nextInt(_techPrefixes.length)];
        }
        break;
      default: // N
        prefix = _techPrefixes[_random.nextInt(_techPrefixes.length)];
    }
    
    return '$prefix$profession';
  }

  // 生成卡片描述
  static String _generateCardDescription(String name, String rank) {
    String prefix = name.substring(0, 2);
    String profession = name.substring(2);
    
    switch (rank) {
      case 'L':
        return '掌握$prefix之力的$profession，擁有改變世界的力量。';
      case 'UR':
        return '精通$prefix技術的$profession，引領科技發展的潮流。';
      case 'SSR':
        return '懷抱$prefix信念的$profession，不斷突破自我極限。';
      case 'SR':
        return '擅長$prefix領域的$profession，在團隊中發揮重要作用。';
      case 'R':
        return '具備$prefix能力的$profession，展現出不凡的潛力。';
      default: // N
        return '初入$prefix領域的$profession，正在努力成長中。';
    }
  }

  // 生成單個卡片
  static Map<String, dynamic> generateCard(String rank, int index) {
    String name = _generateCardName(rank);
    final baseStats = _generateBaseStats(rank);
    
    return {
      'id': name.toLowerCase().replaceAll(' ', '_'),
      'name': name,
      'description': _generateCardDescription(name, rank),
      'rank': rank,
      'icon': _professionIcons[name.substring(2)] ?? 'person',
      'image': 'assets/images/cards/$rank/${name.toLowerCase().replaceAll(' ', '_')}.png',
      'baseHp': baseStats['hp'],
      'baseMp': baseStats['mp'],
      'basePoint': baseStats['point'],
      'baseCreate': baseStats['create'],
      'basePopular': baseStats['popular'],
      'connectionNumber': rank == 'L' ? 5 : (rank == 'UR' ? 4 : (rank == 'SSR' ? 3 : (rank == 'SR' ? 2 : 1))),
      'supportEvent': _generateEvents(rank, 3),
      'storyEvent': _generateEvents(rank, 2),
      'uniqueEvent': _generateUniqueEvents(rank),
    };
  }

  // 生成想飛的拉多（L）
  static Map<String, dynamic> generateFlutterDash() {
    return {
      'id': 'flutter_dash',
      'name': '想飛的拉多',
      'description': '熱愛 Flutter 的工程師，夢想是讓所有應用都能飛起來。',
      'rank': 'L',
      'icon': 'flutter_dash',
      'image': 'assets/images/cards/L/flutter_dash.png',
      'baseHp': 80,
      'baseMp': 90,
      'basePoint': 85,
      'baseCreate': 95,
      'basePopular': 85,
      'connectionNumber': 5,
      'supportEvent': [
        {
          'title': 'Flutter 社群分享',
          'description': '在社群分享 Flutter 開發經驗\n體力 -20\n專業 +40\n靈感 +30\n人氣 +20',
          'mpEffect': 30,
          'hpEffect': -20,
          'pointEffect': 40,
          'createEffect': 0,
          'popularEffect': 20,
          'professionalEffect': 0,
          'randomAble': false,
        },
        {
          'title': '跨平台開發',
          'description': '使用 Flutter 開發跨平台應用\n體力 -30\n專業 +50\n靈感 +40\n創造力 +30',
          'mpEffect': 40,
          'hpEffect': -30,
          'pointEffect': 50,
          'createEffect': 30,
          'popularEffect': 0,
          'professionalEffect': 0,
          'randomAble': false,
        },
        {
          'title': 'Widget 優化',
          'description': '優化 Flutter Widget 性能\n體力 -25\n專業 +45\n靈感 +35\n創造力 +25',
          'mpEffect': 35,
          'hpEffect': -25,
          'pointEffect': 45,
          'createEffect': 25,
          'popularEffect': 0,
          'professionalEffect': 0,
          'randomAble': false,
        },
      ],
      'storyEvent': [
        {
          'title': 'Flutter 大會演講',
          'description': '在 Flutter 大會上分享開發經驗\n體力 -40\n專業 +80\n靈感 +60\n人氣 +50\n創造力 +40',
          'mpEffect': 60,
          'hpEffect': -40,
          'pointEffect': 80,
          'createEffect': 40,
          'popularEffect': 50,
          'professionalEffect': 0,
          'randomAble': false,
        },
        {
          'title': '開源項目貢獻',
          'description': '為 Flutter 生態系統做出貢獻\n體力 -35\n專業 +70\n靈感 +50\n人氣 +40\n創造力 +35',
          'mpEffect': 50,
          'hpEffect': -35,
          'pointEffect': 70,
          'createEffect': 35,
          'popularEffect': 40,
          'professionalEffect': 0,
          'randomAble': false,
        },
      ],
      'uniqueEvent': [
        {
          'title': 'Flutter 飛翔',
          'description': '實現了讓應用飛起來的夢想\n體力 -50\n專業 +100\n靈感 +800\n人氣 +70\n創造力 +60',
          'mpEffect': 800,
          'hpEffect': -50,
          'pointEffect': 1000,
          'createEffect': 60,
          'popularEffect': 70,
          'professionalEffect': 100,
          'randomAble': false,
        },
      ],
    };
  }

  // 生成所有卡片
  static List<Map<String, dynamic>> generateAllCards() {
    List<Map<String, dynamic>> cards = [];
    
    // 生成想飛的拉多（L）
    cards.add(generateFlutterDash());

    // 生成 L 級卡片 (2張)
    for (int i = 0; i < 2; i++) {
      cards.add(generateCard('L', i));
    }

    // 生成 UR (3張)
    for (int i = 0; i < 3; i++) {
      cards.add(generateCard('UR', i));
    }

    // 生成 SSR (15張)
    for (int i = 0; i < 15; i++) {
      cards.add(generateCard('SSR', i));
    }

    // 生成 SR (30張)
    for (int i = 0; i < 30; i++) {
      cards.add(generateCard('SR', i));
    }

    // 生成 R (50張)
    for (int i = 0; i < 50; i++) {
      cards.add(generateCard('R', i));
    }

    // 生成 N (50張)
    for (int i = 0; i < 50; i++) {
      cards.add(generateCard('N', i));
    }

    return cards;
  }

  // 將卡片寫入 JSON 文件
  static Future<void> writeCardsToFile() async {
    final cards = generateAllCards();
    final jsonString = JsonEncoder.withIndent('  ').convert(cards);
    
    final file = File(path.join('assets', 'data', 'cards.json'));
    await file.writeAsString(jsonString);
    print('Generated ${cards.length} cards and saved to ${file.path}');
  }
}

void main() async {
  await CardGenerator.writeCardsToFile();
} 