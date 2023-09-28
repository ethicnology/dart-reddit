import 'dart:convert';

import 'package:reddit/reddit.dart';

Future<dynamic> handler(response) async {
  if (response.statusCode >= 200 && response.statusCode < 300) {
    return jsonDecode(response.body);
  } else {
    throw Exception('${response.statusCode} : ${response.body}');
  }
}

Future<List> listing({
  required Client client,
  required Uri endpoint,
  int limit = 100,
  bool all = true,
  String? after,
}) async {
  List<dynamic> result = [];
  do {
    if (after != null) {
      endpoint = endpoint.replace(queryParameters: {
        'raw_json': '1',
        'limit': limit.toString(),
        'after': after,
      });
    }

    var body = await handler(await client.get(endpoint));
    var children = body['data']['children'];
    after = body['data']['after'];
    result.addAll(children);
  } while (after != null && all);
  return result;
}
