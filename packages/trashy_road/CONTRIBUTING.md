# Contributing to Trashy Road

This document describes the steps and information to contribute to `TrashyRoad`.

## Assets

Assets are located in the [assets](./assets/) directory.

### Adding assets

1. Include your new asset file inside the [assets](./assets/) directory.

```txt
packages/
├─ trashy_road/
│  ├─ assets/
│  │  ├─ trash_can.png
│  ├─ pubspec.yaml
```

2. Generate a new `Assets` class, with [flutter_gen](https://pub.dev/packages/flutter_gen).

```sh
dart run build_runner build
```

3. Use you new asset in code:

```dart
import 'package:trashy_road/gen/gen.dart';

void main() {
  Assets.images.trashCan;
}
```

## Testing

### Running tests

1. Run the game tests:

```sh
flutter test
```
