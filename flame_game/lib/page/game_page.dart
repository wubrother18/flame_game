import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_game/manager/game_manager.dart';
import 'package:flame_game/model/card_model.dart';
import 'package:flame_game/model/event_model.dart';
import 'package:flame_game/model/achievement_model.dart';
import 'package:flame_game/static.dart';
import 'package:flame_game/page/achievement_page.dart';
import 'package:flame_game/widget/common_app_bar.dart';
import 'package:flame_game/widget/achievement_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../game/main_screen.dart';
import '../model/card_model.dart';

class GamePage extends StatefulWidget {
  final List<CardModel> cardList;

  const GamePage({super.key, required this.cardList});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with SingleTickerProviderStateMixin {
  late GameManager gameManager;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  bool _isTutorialShown = false;
  int _currentTutorialStep = 0;
  OverlayEntry? _achievementOverlay;

  @override
  void initState() {
    super.initState();
    gameManager = GameManager();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(_controller);
    _controller.forward();
    _checkTutorial();

    // 初始化遊戲管理器
    gameManager.init(widget.cardList, (end) {
      if (end == "daily_summary") {
        _showDailySummaryDialog(
          gameManager.day * 10,
          gameManager.day * 10,
          gameManager.random.nextDouble(),
        );
      } else if (end == "pass") {
        Navigator.of(context).pop();
      } else if (end == "fail") {
        _showGameOverDialog();
      }
    });

    // 監聽成就完成事件
    StaticFunction.instance.achieveManager.onAchievementCompleted = (achievement) {
      _showAchievementNotification(achievement);
    };
  }

  void _checkTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    _isTutorialShown = prefs.getBool('tutorial_shown') ?? false;
    if (!_isTutorialShown) {
      _showTutorial();
    }
  }

  void _showTutorial() {
    showDialog(
          context: context,
          barrierDismissible: false,
      builder: (context) => _buildTutorialDialog(),
    );
  }

  Widget _buildTutorialDialog() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade100,
                  Colors.blue.shade50,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getTutorialTitle(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _getTutorialContent(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (_currentTutorialStep > 0)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentTutorialStep--;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade200,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('上一步'),
                      ),
                    ElevatedButton(
              onPressed: () {
                        if (_currentTutorialStep < 3) {
                          setState(() {
                            _currentTutorialStep++;
                          });
                        } else {
                          Navigator.of(context).pop();
                          _markTutorialAsShown();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(_currentTutorialStep < 3 ? '下一步' : '開始遊戲'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getTutorialTitle() {
    switch (_currentTutorialStep) {
      case 0:
        return '歡迎來到30天煉成遊戲！';
      case 1:
        return '角色屬性';
      case 2:
        return '事件系統';
      case 3:
        return '成就系統';
      default:
        return '';
    }
  }

  String _getTutorialContent() {
    switch (_currentTutorialStep) {
      case 0:
        return '你將在30天內培養一個遊戲開發者。\n'
               '每天都會遇到不同的事件，需要做出選擇。\n'
               '你的選擇將影響角色的成長。';
      case 1:
        return '角色有三個主要屬性：\n'
               '• 體力(HP)：影響你的生存能力\n'
               '• 靈感(MP)：影響你的創造力\n'
               '• 專業(Point)：影響你的技能水平\n\n'
               '點擊角色卡片可以升級，提升屬性。';
      case 2:
        return '每天會出現不同的事件：\n'
               '• 工作事件：提升專業度\n'
               '• 生活事件：影響體力和靈感\n'
               '• 特殊事件：可能帶來意外收穫\n\n'
               '謹慎選擇事件，平衡發展。';
      case 3:
        return '遊戲設有多個成就目標：\n'
               '• 進度類：完成30天挑戰\n'
               '• 事件類：完成特定事件\n'
               '• 屬性類：達到特定數值\n\n'
               '完成成就可以獲得獎勵。';
      default:
        return '';
    }
  }

  Future<void> _markTutorialAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_shown', true);
    setState(() {
      _isTutorialShown = true;
    });
  }

  void _showAchievementNotification(Achievement achievement) {
    // 移除現有的提示
    _achievementOverlay?.remove();
    
    // 創建新的提示
    _achievementOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: 20,
        left: 20,
        right: 20,
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, -50 * (1 - value)),
              child: Opacity(
                opacity: value,
            child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.emoji_events,
                          color: Colors.blue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "成就解鎖!",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              achievement.name,
                                style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              achievement.description,
                                style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.check_circle,
                        color: Colors.blue,
                        size: 24,
                      ),
                                  ],
                                ),
                              ),
                            ),
            );
          },
        ),
      ),
    );

    // 顯示提示
    Overlay.of(context).insert(_achievementOverlay!);

    // 3秒後自動移除
    Future.delayed(const Duration(seconds: 3), () {
      _achievementOverlay?.remove();
      _achievementOverlay = null;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _achievementOverlay?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '30天煉成遊戲',
        achievementManager: StaticFunction.instance.achieveManager,
        onAchievementPressed: () {
          _showAchievements();
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade100,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
                          children: [
              _buildHeader(),
              Expanded(
                child: _buildMainContent(),
              ),
              _buildBottomBar(),
                                  ],
                                ),
                              ),
                            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProgressBar(),
          const SizedBox(height: 16),
          _buildCharacterCard(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildProgressItem('創意', gameManager.role.create),
          _buildProgressItem('專業', gameManager.role.point),
          _buildProgressItem('人氣', gameManager.role.popular),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String label, int value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildCharacterCard() {
    return GestureDetector(
      onTap: () => _showUpgradeDialog(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
                        ),
                      ],
                    ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.person,
                size: 40,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      children: [
                      Text(
                        '等級 ${gameManager.role.level}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                          child: Text(
                          '第 ${gameManager.day} 天',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildStatusBar('HP', gameManager.role.hp, Colors.red),
                  const SizedBox(height: 4),
                  _buildStatusBar('MP', gameManager.role.mp, Colors.blue),
                  const SizedBox(height: 4),
                  _buildStatusBar('Point', gameManager.role.point, Colors.green),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildStatusBar(String label, int value, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              widthFactor: (value / 100).clamp(0.0, 1.0),
            child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
                                ),
                              ],
                            );
  }

  Widget _buildMainContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '今日事件',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildEventList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    return ListView.builder(
      itemCount: gameManager.events.length,
      itemBuilder: (context, index) {
        final event = gameManager.events[index];
        return _buildEventCard(event);
      },
    );
  }

  Widget _buildEventCard(GameEvent event) {
    return GestureDetector(
      onTap: () => _handleEvent(event),
                    child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Icon(
                    _getEventIcon(event),
                    color: Colors.blue,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                        child: Text(
                      event.title,
                          style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildEffectItem('HP', event.hpEffect, Colors.red),
                      _buildEffectItem('MP', event.mpEffect, Colors.blue),
                      _buildEffectItem('Point', event.pointEffect, Colors.green),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getEventIcon(GameEvent event) {
    if (event.title.contains('工作')) return Icons.work;
    if (event.title.contains('生活')) return Icons.home;
    if (event.title.contains('特殊')) return Icons.star;
    return Icons.event;
  }

  Widget _buildEffectItem(String label, int value, Color color) {
    return Row(
      children: [
        Icon(
          value >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
          color: value >= 0 ? Colors.green : Colors.red,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          '$label ${value.abs()}',
          style: TextStyle(
            fontSize: 14,
            color: value >= 0 ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomButton(
            icon: Icons.emoji_events,
            label: '成就',
            onTap: () => _showAchievements(),
          ),
          _buildBottomButton(
            icon: Icons.arrow_forward,
            label: '下一步',
            onTap: () => _nextDay(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        FlameAudio.play('poka.mp3');
        onTap();
            },
            child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleEvent(GameEvent event) {
    gameManager.handleEvent(event);
    setState(() {});
    _checkGameOver();
  }

  void _nextDay() {
    gameManager.nextDay();
    setState(() {});
    _checkGameOver();
  }

  void _checkGameOver() {
    if (gameManager.isGameOver) {
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade100,
                Colors.blue.shade50,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '遊戲結束',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                gameManager.failureReason,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '最終得分：${gameManager.calculateScore()}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('返回主選單'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade100,
                Colors.blue.shade50,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '升級角色',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '當前等級：${gameManager.role.level}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                '升級所需點數：${gameManager.role.level * 100}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('取消'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (gameManager.role.point >= gameManager.role.level * 100) {
                        gameManager.role.point -= gameManager.role.level * 100;
                        gameManager.role.level++;
                        Navigator.of(context).pop();
                        setState(() {});
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('點數不足！'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('升級'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAchievements() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AchievementPage()),
    );
  }

  void _showDailySummaryDialog(int requiredHp, int requiredMp, double popularityMultiplier) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade100,
                  Colors.blue.shade50,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '每日總結',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '第 ${gameManager.day} 天',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '今日消耗：',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('• 能力：-$requiredHp'),
                Text('• 靈感：-$requiredMp'),
                const SizedBox(height: 20),
                const Text(
                  '今日獲得：',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('• 專業度：+$requiredMp'),
                Text('• 創意：+$requiredHp'),
                Text('• 人氣：+${(requiredMp * popularityMultiplier).toInt()}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('確認'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



