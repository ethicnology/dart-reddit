# reddit

## Features

### Oauth
- [x] web 
- [ ] app
- [ ] script
### Account
- [x] me
- [x] about
- [x] submitted
- [x] submit

### Subreddit
- [x] about
- [x] rules
- [x] flairs

## Usage

`/example` 

```dart
import 'package:oauth2/oauth2.dart';
import 'package:reddit/reddit.dart';
import 'package:dotenv/dotenv.dart';

Future<void> main() async {
  var env = DotEnv(includePlatformEnvironment: true)..load();

  var client = env['client_id'];
  var secret = env['secret'];
  var redirect = env['redirect'];
  var credentials = env['credentials'];
  var otherAccount = env['other_account'];

  if (client == null ||
      secret == null ||
      redirect == null ||
      credentials == null ||
      otherAccount == null) {
    print('.env variables missing');
    return;
  }

  var auth = Oauth(identifier: client, secret: secret);
  var url = auth.url(
    redirect: Uri.parse(redirect),
    scopes: allScopes,
    duration: 'permanent',
  );
  print(url);

  // can be perform only once per redirectedUrl / code
  // var redirectedUrl = Uri.parse(
  //     'http://localhost:8080/?state=%C3%A2%C2%80%C2%A6&code=abcdek2bMKSJrmSJvwxyz#_');
  // var reddit1 = await auth.authorize(redirected: redirectedUrl);
  // var reddit1 = await auth.authorize(code: 'abcdek2bMKSJrmSJvwxyz');
  // var creds = reddit.client.credentials.toJson();
  // print(creds);

  var reddit = await Reddit.connect(
      client: client,
      secret: secret,
      credentials: Credentials.fromJson(credentials));

  print(await reddit.account().me());
  print(await reddit.account().about()); // my account about
  print(await reddit.account().submitted()); // my submissions
  print(await reddit.account().about(name: otherAccount));
  print(await reddit.subreddit(name: 'bitcoin').about());
  print(await reddit.account().submitted(name: otherAccount));
  print(await reddit
      .account()
      .submit(sr: 'u_${reddit.name}', title: 'test', url: "https://arte.tv"));
}
```
