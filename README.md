# Lumen Missal

Lumen Missal is a production-ready, open-source, offline-capable browser extension (Manifest V3) for Chrome and Firefox. It serves as a "Daily Missal", displaying daily Catholic liturgical readings by chaining data from the Catholic LitCal API to the Bible API. It dynamically themes its beautiful Flutter UI based on the current liturgical season and caches data locally for offline availability.

## Architecture

*   **Framework:** Flutter Web, compiled strictly to WebAssembly (`--wasm`).
*   **State Management:** Pure Flutter `ChangeNotifier` and `ListenableBuilder`.
*   **Persistence:** Local caching via `drift` alongside `drift_sqlite3` and `sqlite3` for the web. A background Web Worker runs the database to persist to IndexedDB without blocking the UI thread.
*   **Networking:** Standard `http` package for chaining requests to the LitCal API and Bible API.
*   **Typography & Styling:** Utilizes `google_fonts` to provide a premium digital Missal feel. Dynamic theming maps LitCal liturgical colors directly into Flutter's `ColorScheme`.

## Building the Extension

### Prerequisites

Ensure you have the Flutter SDK installed and configured.

### Dependencies & Boilerplate Generation

Run the following to fetch dependencies and generate the required Drift boilerplate:

```bash
flutter pub get
dart run build_runner build -d
```

### Building for WebAssembly

Compile the Flutter app to WebAssembly:

```bash
flutter build web --release --wasm
dart compile js web/worker.dart -o build/web/worker.dart.js
```

### Running Locally with sqlite3.wasm

Because the app relies on Web Workers and a `sqlite3.wasm` binary, serving the app requires correct headers (like Cross-Origin-Opener-Policy). When testing locally, you can serve the build directory using Python:

```bash
cd build/web
python3 -m http.server 8000
```
*Note: Due to COOP/COEP requirements for SharedArrayBuffer (often used by sqlite3 Wasm), you may need a custom server script to attach the proper headers if simple HTTP serving fails.*

## Browser Extension Deployment

### Chrome

1. Build the app as described above.
2. Open Chrome and navigate to `chrome://extensions/`.
3. Enable **Developer mode**.
4. Click **Load unpacked** and select the `build/web` directory.

### Firefox

1. Open Firefox and navigate to `about:debugging#/runtime/this-firefox`.
2. Click **Load Temporary Add-on...**
3. Select the `web/manifest.json` file.

## Open Source

Please refer to [`CONTRIBUTING.md`](CONTRIBUTING.md) for how to contribute and [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md) for community guidelines. This project is licensed under the [MIT License](LICENSE).
