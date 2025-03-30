class TaskManager {
  List<Map<String, dynamic>> dailyTasks = [];
  List<Map<String, dynamic>> weeklyTasks = [];
  Map<String, bool> completedTasks = {};

  TaskManager() {
    _initTasks();
  }

  void _initTasks() {
    dailyTasks = [
      {
        'id': 'daily_work',
        'name': '完成工作',
        'description': '完成3次工作事件',
        'reward': 100,
        'type': 'daily',
        'target': 3,
        'progress': 0,
      },
      {
        'id': 'daily_rest',
        'name': '適當休息',
        'description': '完成2次休息事件',
        'reward': 80,
        'type': 'daily',
        'target': 2,
        'progress': 0,
      },
    ];

    weeklyTasks = [
      {
        'id': 'weekly_creative',
        'name': '創意爆發',
        'description': '累積獲得500點靈感',
        'reward': 300,
        'type': 'weekly',
        'target': 500,
        'progress': 0,
      },
      {
        'id': 'weekly_professional',
        'name': '專業提升',
        'description': '累積獲得500點專業度',
        'reward': 300,
        'type': 'weekly',
        'target': 500,
        'progress': 0,
      },
    ];
  }

  List<Map<String, dynamic>> getDailyTasks() {
    return dailyTasks;
  }

  List<Map<String, dynamic>> getWeeklyTasks() {
    return weeklyTasks;
  }

  void updateTaskProgress(String taskId, int progress) {
    final task = [...dailyTasks, ...weeklyTasks].firstWhere(
      (task) => task['id'] == taskId,
      orElse: () => {},
    );

    if (task.isEmpty) return;

    task['progress'] = progress;
    if (progress >= task['target']) {
      completeTask(taskId);
    }
  }

  void completeTask(String taskId) {
    completedTasks[taskId] = true;
  }

  bool isTaskCompleted(String taskId) {
    return completedTasks[taskId] ?? false;
  }

  void resetDailyTasks() {
    dailyTasks.forEach((task) {
      task['progress'] = 0;
    });
    completedTasks.removeWhere((key, value) => 
      dailyTasks.any((task) => task['id'] == key));
  }

  void resetWeeklyTasks() {
    weeklyTasks.forEach((task) {
      task['progress'] = 0;
    });
    completedTasks.removeWhere((key, value) => 
      weeklyTasks.any((task) => task['id'] == key));
  }

  int getTaskReward(String taskId) {
    final task = [...dailyTasks, ...weeklyTasks].firstWhere(
      (task) => task['id'] == taskId,
      orElse: () => {'reward': 0},
    );
    return task['reward'];
  }
} 