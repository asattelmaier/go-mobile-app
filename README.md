# Go Mobile App

Go board game as a mobile application.
The app uses the socket backend of [Go Haskell](https://github.com/asattelmaier/go-haskell).

<p align="center">
  <img width="400" src="https://drive.google.com/uc?export=view&id=1BN-Cqetaqpz7Q6Mqm8tbUQ0sUHUOtzYy" alt="Go Mobile App">
</p>

</p>

## Prerequisites

* Flutter 3.13 or higher (Dart 3.1+)
* Java 17+ (for Android builds)

## Run

Generate mockito and json serializable files.

```bash
./scripts/build.sh
```

This script:
1. Generates the API client.
2. Installs dependencies.
3. Runs `build_runner` (Mockito, JSON Serializable).

Run Flutter.

```bash
flutter run
```

## Configuration

To target a specific environment provide a `ENV` via `--dart-define`.
Currently only `development` is supported.

```bash
flutter run --dart-define=ENV=development
```

## Session Server Client

The application communicates with the `go-session-server` using a generated Dart client.

### Client Package
The client is located in [`packages/session_server_client`](packages/session_server_client) and is a local dependency.

### Scripts
Two scripts are provided in `scripts/` to manage the API client:

*   **Update API Spec**: Fetches the latest OpenApi spec from a running backend and formats it.
    ```bash
    ./scripts/update_api_spec.sh [BACKEND_URL]
    # Default: http://127.0.0.1:8080
    ```

*   **Generate Client**: Regenerates the `session_server_client` package based on `api/session-server-api.json`.
    ```bash
    ./scripts/generate_client.sh
    ```
    This script uses `openapi-generator-cli` (Docker required) and automatically syncs the client version with the API spec.
