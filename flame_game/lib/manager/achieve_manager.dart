import 'dart:convert';

import 'package:flame_game/manager/notification.dart';
import 'package:flame_game/static.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AchieveManager {
  /// 單例
  static AchieveManager? self ;

  final SharedPreferences prefs = StaticFunction.prefs;

  static AchieveManager getInstance() {
    if(self == null) {
      self = AchieveManager();
      return self!;
    }else {
      return self!;
    }
  }

  add(Map dataInput) async {
    ///取得使用者的記錄資料
    String? recordString = prefs.getString("user_records");
    Map recordData = jsonDecode(recordString??"{}");
    ///傳入的資料若是數值表示要加上該數值，若是其他，則是覆寫
    if(dataInput[dataInput.keys.first] is int){
      int addValue = dataInput[dataInput.keys.first]??0;
      int oldValue = recordData[dataInput.keys.first]??0;
      recordData[dataInput.keys.first] = oldValue + addValue;
    }else{
      recordData[dataInput.keys.first] = dataInput[dataInput.keys.first];
    }
    await prefs.setString("user_records",jsonEncode(recordData));
    compareAchieve(dataInput.keys.first,recordData[dataInput.keys.first]);
    ///印出來在後台看
    print("使用者的記錄資料 : $recordData");
  }

  del(String key) async {
    ///取得使用者的記錄資料
    String? recordString = prefs.getString("user_records");
    Map recordData = jsonDecode(recordString??"{}");
    if(recordData.containsKey(key)){
      recordData.remove(key);
      await prefs.setString("user_records",jsonEncode(recordData));
    }
  }

  compareAchieve(String key, recordData){
    List achieveList = jsonDecode(prefs.getString("achieve_data")??"[{}]");
    for(int i=0;i<achieveList.length;i++){
      if(achieveList[i]["ID"].toString().compareTo(key)==0 && achieveList[i]["AMOUNT"] == recordData){
        achieveList[i]["HIDDEN"] = false;
        ///印在後台
        print("獲得成就 名稱： ${achieveList[i]["NAME"]} \n ${achieveList[i]["DESCRIPTION"]}");
        LocalNotificationService().showNotification(achieveList[i]["NAME"], "獲得成就 名稱： ${achieveList[i]["NAME"]} \n ${achieveList[i]["DESCRIPTION"]}");
      }
    }
  }

}
