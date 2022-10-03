import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

myHttp(
  BuildContext context,
  String url,
  var mybody, {
  var header,
  int statusCode = 200,
}) async {
  var body = {};
  try {
    http.Response res = await http.post(
      Uri.parse(url),
      body: jsonEncode(mybody),
      headers: header ?? {"Content-Type": "application/json"},
    );

    body = jsonDecode(res.body);
    if (res.statusCode != statusCode) {
      debugPrint(body.toString());
      showCupertinoDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => CupertinoAlertDialog(
                title: const Text("Error"),
                content: Text(body['message'].toString()),
                actions: [
                  CupertinoButton(
                    child: const Text("close"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ));
      return;
    }
  } catch (e) {
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text("Error"),
              content: Text(e.toString()),
              actions: [
                CupertinoButton(
                  child: const Text("close"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ));
    //
  }

  return body;
}
