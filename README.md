# Lumen Missal

Lumen Missal is a Flutter browser extension for the daily Catholic liturgical readings. Choose a general, national, or diocesan calendar and a Bible translation in Settings.

## Readings and storage

[LitCal v5](https://litcal.johnromanodorazio.com/dist/) provides the celebration and reading citations for the browser's local date. The extension selects the daytime celebration and fetches scripture text from [Bible API](https://bible-api.com/). It keeps the original citations visible. Bible API serves whole verses, including when a citation specifies part of a verse.

The extension caches a day's calendar and successful passages in Drift, scoped to the selected calendar and Bible translation. A failed refresh leaves saved passages available. Settings use browser local storage and app state uses Flutter's ChangeNotifier. Inter is bundled so the popup's typography works offline.

Calendar coverage and scripture coverage depend on the upstream services. If LitCal omits citations, the extension shows the celebration and explains the missing data. If Bible API cannot provide text, the citation remains available in the reading index.

## Build the extension

Use the Flutter and Dart versions specified in [pubspec.yaml](pubspec.yaml).

```sh
flutter pub get
flutter analyze
flutter test
flutter build web --release --wasm
dart compile js web/worker.dart -o build/web/worker.dart.js
```

- **Chrome**. Open `chrome://extensions/`, enable Developer mode, and choose **Load unpacked**. Select the `build/web` directory.
- **Firefox**. Open `about:debugging#/runtime/this-firefox` and choose **Load Temporary Add-on**. Select `build/web/manifest.json`.

To preview the app in a regular browser tab, serve `build/web` over loopback with `python3 -m http.server 8000 --directory build/web`. The browser extension host permissions allow requests to both APIs. When served over HTTP, the upstream services must allow cross-origin requests from the preview origin.

To regenerate Drift and Mockito code after changes to their declarations, run `dart run build_runner build`.

## Open source

See [CONTRIBUTING.md](CONTRIBUTING.md) and the [MIT License](LICENSE). The bundled Inter font is distributed under its [SIL Open Font License](assets/fonts/OFL.txt).
