// TODO(OlliePugh): Add an issue on FlameTiled, with reproductive steps to Flame
// and add the issue URL here.

/// {@template tile_map_parser}
/// Prepares a Tiled map file (`.tmx`) for use with Flame.
///
/// This script should be run from `tool/tiled_map_parser`, otherwise it will
/// throw an error.
/// {@endtemplate}
library tiled_map_parser;

import 'dart:io';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as path;
import 'package:xml/xml.dart';

/// The file extension used by Tiled to identify a map file.
const _tiledMapExtension = '.tmx';

/// Represents a Tiled object, within a Tiled map file (`.tmx`) that uses a
/// template.
class _TiledObject {
  const _TiledObject({
    required String template,
    required XmlElement element,
  })  : _element = element,
        _template = template;

  /// Attempts to parse a [_TiledObject] from an [XmlElement].
  ///
  /// It expects an element with the format:
  /// ```xml
  /// <object template="path/to/template.tx" ... />
  /// ```
  static _TiledObject? tryParse(XmlElement element) {
    final template = element.getAttribute('template');
    if (template == null) {
      return null;
    }

    return _TiledObject(
      template: template,
      element: element,
    );
  }

  /// The relative path to the template file (`.tx`) that this object uses.
  final String _template;

  /// The raw XML element that represents this object.
  final XmlElement _element;

  /// Gets the template file (`.tx`) from the given base path.
  _TiledTemplateFile _templateFile(String basePath) =>
      _TiledTemplateFile.fromFile(
        File(
          path.join(basePath, _template),
        ),
      );

  /// Copies data found in the template file (`.tx`) to the object element in
  /// the `.tmx` file.
  ///
  /// If the object element already has an attribute or property, it will not be
  /// overwritten.
  ///
  /// The data that is copied are the attributes and properties of the template
  /// file.
  ///
  /// For example:
  /// ```xml
  /// <!-- map.tmx -->
  /// <object id="32" template="road_lane.tx" x="64" y="160" ... >
  /// ```
  /// ```xml
  /// <!-- road_lane.tx -->
  /// <?xml version="1.0" encoding="UTF-8"?>
  /// <template>
  ///  <object name="road_lane" class="road_lane">
  ///   <properties>
  ///    <property name="speed" type="int" value="0"/>
  ///   </properties>
  ///  <point/>
  ///  </object>
  /// </template>
  /// ```
  ///
  /// Will update `map.tmx` to:
  /// ```xml
  /// <object id="32" template="road_lane.tx" x="64" y="160"
  ///         name="road_lane" class="road_lane">
  ///   <properties>
  ///     <property name="speed" type="int" value="0"/>
  ///   </properties>
  /// </object>
  void addTemplateData(String basePath) {
    final templateFile = _templateFile(basePath);

    final templateObject = templateFile._object;

    final objectAttributes = templateObject.attributes.where(
      (attribute) => _element.getAttribute(attribute.name.toString()) == null,
    );
    for (final attribute in objectAttributes) {
      _element.setAttribute(attribute.name.toString(), attribute.value);
    }

    final properties = templateFile._properties;
    if (properties != null && _element.getElement('properties') == null) {
      _element.children.add(properties.copy());
    }
  }
}

/// Represents a Tiled template file (`.tx`).
class _TiledTemplateFile {
  const _TiledTemplateFile({
    required XmlElement object,
    XmlElement? properties,
  })  : _object = object,
        _properties = properties;

  /// Creates a [_TiledTemplateFile] from a file.
  factory _TiledTemplateFile.fromFile(File file) {
    if (!file.existsSync()) {
      throw Exception('File does not exist: ${file.path}');
    }

    final contents = file.readAsStringSync();
    final document = XmlDocument.parse(contents);
    final object = document.findAllElements('object').firstOrNull;

    if (object == null) {
      throw Exception('No object found in file: ${file.path}');
    }

    return _TiledTemplateFile(
      object: object,
      properties: document.findAllElements('properties').firstOrNull,
    );
  }

  /// The first <object> element found in the template file.
  final XmlElement _object;

  /// The first <properties> element found in the template file, if it exists.
  final XmlElement? _properties;
}

/// {@macro tile_map_parser}
void main() async {
  final logger = Logger();

  final scriptPath = path.join('tool', 'tiled_map_parser');
  if (!Directory.current.path.endsWith(scriptPath)) {
    logger.err('This script should be run from the `$scriptPath` directory');
    return;
  }

  final assetsDirectory = Directory(
    path.join('..', '..', 'packages', 'trashy_road', 'assets', 'tiles'),
  );

  final tmxFiles = assetsDirectory
      .listSync()
      .whereType<File>()
      .where((file) => path.extension(file.path) == _tiledMapExtension)
      .toList();

  logger.info('Found ${tmxFiles.length} .tmx files');

  for (final file in tmxFiles) {
    final tmxFile = XmlDocument.parse(file.readAsStringSync());

    final objectsXmlElement = tmxFile.findAllElements('object').toList();
    final objects =
        objectsXmlElement.map(_TiledObject.tryParse).whereType<_TiledObject>();
    logger.info('Found ${objects.length} objects in ${file.path}');

    for (final object in objects) {
      object.addTemplateData(assetsDirectory.path);
    }

    file.writeAsStringSync(tmxFile.toXmlString(pretty: true));
  }
}
