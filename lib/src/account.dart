import 'package:reddit/reddit.dart';
import 'package:reddit/src/utils.dart';

class Account {
  Client client;
  String name;

  Account(this.client, this.name);

  Future<Map<String, dynamic>> me() async {
    var path = 'api/v1/me';
    return await handler(await client.get(Reddit.uri.resolve(path)));
  }

  Future<Map<String, dynamic>> about({String? name}) async {
    name ??= this.name;
    var path = 'user/$name/about';
    return await handler(await client.get(Reddit.uri.resolve(path)));
  }

  Future<List> submitted({
    String? name,
    int limit = 100,
    bool all = false,
    String? after,
  }) async {
    name ??= this.name;
    Map<String, String> params = {'raw_json': '1', 'limit': limit.toString()};
    if (after != null) params['after'] = after;

    String path = '/user/$name/submitted';
    var endpoint = Reddit.uri.resolve(path).replace(queryParameters: params);

    return listing(
      client: client,
      endpoint: endpoint,
      limit: limit,
      all: all,
      after: after,
    );
  }

  Future<dynamic> submit({
    required String sr,
    required String title,
    required String url,
    String kind = 'link',
    String idFlair = '',
    String apiType = 'json',
    String submitType = 'subreddit',
    String recaptchaToken = '',
    bool nsfw = false,
    bool spoiler = false,
    bool sendreplies = true,
    bool postToTwitter = false,
    bool showErrorList = true,
    bool originalContent = false,
    bool validateOnSubmit = true,
  }) async {
    Map<String, String> params = {
      'resubmit': 'true',
      'redditWebClient': 'desktop2x',
      'app': 'desktop2x-client-production',
      'rtj': 'only',
      'raw_json': '1',
      'gilding_detail': '1',
    };

    String path = '/api/submit';
    var endpoint = Reddit.uri.resolve(path).replace(queryParameters: params);
    return await handler(
      await client.post(
        endpoint,
        body: {
          'sr': sr,
          'kind': kind,
          'title': title,
          'url': url,
          'flair_id': idFlair,
          'submitType': submitType,
          'recaptchaToken': recaptchaToken,
          'apiType': apiType,
          'spoiler': spoiler.toString(),
          'nsfw': nsfw.toString(),
          'showErrorList': showErrorList.toString(),
          'originalContent': originalContent.toString(),
          'postToTwitter': postToTwitter.toString(),
          'sendreplies': sendreplies.toString(),
          'validateOnSubmit': validateOnSubmit.toString(),
        },
      ),
    );
  }
}
