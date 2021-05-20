# Go Mobile App

Go board game as a mobile application.
The app uses the socket backend of [Go Haskell](https://github.com/asattelmaier/go-haskell).

<p align="center">
  <img width="400" src="https://drive.google.com/uc?export=view&id=1BN-Cqetaqpz7Q6Mqm8tbUQ0sUHUOtzYy" alt="Go Mobile App">
</p>

## Run

Generate mockito and json serializable files.

```bash
flutter pub run build_runner build
```

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
