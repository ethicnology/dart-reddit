import 'package:reddit/reddit.dart';

class Oauth {
  static Uri uri = Uri(scheme: 'https', host: 'www.reddit.com');
  late AuthorizationCodeGrant grant;

  Oauth({required String identifier, required String secret}) {
    grant = AuthorizationCodeGrant(
      identifier,
      uri.resolve('api/v1/authorize'),
      uri.resolve('api/v1/access_token'),
      secret: secret,
    );
  }

  Uri url({
    required Uri redirect,
    Iterable<String>? scopes,
    String responseType = 'code',
    String duration = 'permanent',
    String state = '…', // NOT EMPTY
  }) {
    var url = grant.getAuthorizationUrl(redirect, scopes: scopes, state: state);
    var params = {
      ...url.queryParameters,
      'response_type': responseType,
      'duration': duration
    };
    return url.replace(queryParameters: params);
  }

  Future<Client> _authorize(String code) async {
    print(code);
    return await grant.handleAuthorizationCode(code);
  }

  Future<Reddit> authorize({Uri? redirected, String? code}) async {
    code = redirected?.queryParameters['code'];
    if (code != null) {
      return Reddit.check(await _authorize(code));
    } else {
      throw ArgumentError.value(code);
    }
  }
}
