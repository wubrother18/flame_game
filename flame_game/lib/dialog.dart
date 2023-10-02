
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static AlertDialog showWarning(
      BuildContext context, title, descriptions, text, Function callback) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: _warningContentBox(context, title, descriptions, text, callback),
    );
  }

  static Widget _warningContentBox(
      context, title, descriptions, text, callback) {
    return Stack(
      children: <Widget>[
        Container(
          padding:
          const EdgeInsets.only(left: 25, top: 50, right: 25, bottom: 25),
          margin: const EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                descriptions,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: MaterialButton(
                    color: Colors.blueAccent,
                    onPressed: () {
                      callback.call();
                    },
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 18, color: Colors.yellow),
                    )),
              ),
            ],
          ),
        ),
        const Positioned(
          left: 30,
          right: 30,
          top: 1,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              child: Icon(Icons.warning, color: Colors.amberAccent, size: 60),
            ),
          ),
        ),
      ],
    );
  }

}