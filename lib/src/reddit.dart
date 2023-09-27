import 'dart:convert';

import 'package:oauth2/oauth2.dart';
import 'package:reddit/src/account.dart';
import 'package:reddit/src/subreddit.dart';

class Reddit {
  static Uri uri = Uri(scheme: 'https', host: 'oauth.reddit.com');
  String id;
  String name;
  Client client;

  Reddit({required this.client, required this.id, required this.name});

  static Future<Reddit> connect({
    required String client,
    required String secret,
    required Credentials credentials,
  }) {
    var oauth = Client(credentials, identifier: client, secret: secret);
    return Reddit.check(oauth);
  }

  static Future<Reddit> check(Client oauth) async {
    var response = await oauth.get(Reddit.uri.resolve('api/v1/me'));
    if (response.statusCode >= 200 && response.statusCode <= 300) {
      var me = jsonDecode(response.body);
      return Reddit(client: oauth, id: me['id'], name: me['name']);
    } else {
      throw Exception();
    }
  }

  Subreddit subreddit({required String name}) => Subreddit(client, name);

  Account account() => Account(client, name);
}
