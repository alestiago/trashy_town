# Tiled Map Parser

Prepares a Tiled map file (`.tmx`) for use with Flame.

This should be run whenever a new Tiled map file is added to the project.

## Why do we need this?

This is required because flame_tiled does not support the `template` tag in Tiled maps, which is used to define custom properties for the map. This script removes the `template` tag and adds the custom properties to the map directly.

This does result in a repeated data within the map file, but it is necessary for the map to be parsed correctly by flame_tiled.

An [issue](https://github.com/flame-engine/tiled.dart/issues/73) is open on the [tiled](https://github.com/flame-engine/tiled.dart) repository to address this.

## Usage

1. Run, using Dart CLI, the script (from tool/tiled_map_parser):

```sh
dart run lib/main.dart
```

2. The Tiled map files (`.tmx`) files under `packages/trashy_road/assets` are ready to go!
