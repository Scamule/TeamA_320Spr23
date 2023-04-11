# flutter_application_1

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Connecting Flutter to the backend

MAKING REQUESTS:
-   Import 'package:http/http.dart' (as http preferably)
-   Use the following line to get requests:
    -   'final http.Response response = await http.get(Uri.parse(url));'
    -   Note: The good status code is 200 for GET requests and 201 for POST requests
        More info at https://pub.dev/packages/http_status_code
ALLOWING REQUESTS:
-   To allow http requests in chrome, you need to add '--disable-web-security',
    after '--disable-extensions' to the following file:
    -   'flutter/packages/flutter_tools/lib/src/web/chrome.dart'
    -   Note: This could give you an "unsupported command line flag: --disable-web-security"
        error when launching Chrome. If you get this error, ignore it, but be wary.
        This may cause Chrome to reduce security features on your end, so downloading
        things from the web could be unsafe.
-   When hosting flask locally, the address in Flutter must be changed from
    127.0.0.1 to 10.0.2.2, because, um, Flutter.
    -   This shouldn't be an issue, since we may be hosting this on a non-local server
-   For a Mac app to work, you need to add "<key>com.apple.security.network.client</key><true/>"
    into the following file:
    -   'flutter_app/macos/Runner/DebugProfile.entitlements'
PARSING REQUESTS:
-   Import 'dart:convert'
-   After you get a reponse, it will be in JSON format. Use 'jsonDecode' to
    convert the response from a JSON object to a Flutter object.
-   You can now access attributes similar to a JSON object
    -   Example, converted_response['name'] returns the value of the attribute 'name'
RUNNING FLASK:
-   Make sure to use pip to install Flask.
-   Run the python file and it should work.
-   You may also need to install a json package, but I'm not sure.
