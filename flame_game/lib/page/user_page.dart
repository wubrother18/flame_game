import 'package:flame_game/static.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/user_data.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String? name;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserData? userData = StaticFunction.getInstance().getAccount();
    name = userData?.name;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back,size:24,color: Colors.black,),
            ),
            Row(
              children: [
                Container(
                  height: 200,
                  width: 100,
                  color: Colors.yellow,
                ),
                const SizedBox(width: 16,),
                Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Name"),
                    ),
                    const SizedBox(height: 4,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(name??""),
                    ),


                  ],
                )
              ],
            ),
            const SizedBox(height: 16,),
            Container(),
            const SizedBox(height: 16,),
            Container(),
          ],
        ),
      ),
    );
  }
  
}