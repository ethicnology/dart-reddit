import 'package:reddit/reddit.dart';
import 'package:reddit/src/utils.dart';

class Subreddit {
  Client client;
  String name;

  Subreddit(this.client, this.name);

  Future<Map<String, dynamic>> about() async {
    final path = '/r/$name/about';
    return await handler(await client.get(Reddit.uri.resolve(path)));
  }

  Future<Map<String, dynamic>> rules() async {
    final path = '/r/$name/about/rules';
    return await handler(await client.get(Reddit.uri.resolve(path)));
  }

  Future<List<dynamic>> flairs() async {
    final path = '/r/$name/api/link_flair';
    return await handler(await client.get(Reddit.uri.resolve(path)));
  }
}
