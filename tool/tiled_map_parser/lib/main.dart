import 'dart:io';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as path;
import 'package:xml/xml.dart';

/// The file extension used by Tiled to identify a map file.
const _tiledMapExtension = '.tmx';

class _TiledObject {
  const _TiledObject({
    required String template,
    required XmlElement element,
  })  : _element = element,
        _template = template;

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

  final String _template;

  final XmlElement _element;

  _TiledTemplateFile _templateFile(String basePath) =>
      _TiledTemplateFile.fromFile(
        File(
          path.join(basePath, _template),
        ),
      );

  void addTemplateData(String basePath) {
    final templateFile = _templateFile(basePath);

    final object = templateFile._object;
    final newAttributes = object.attributes.where(
      (attribute) {
        print('name: ${attribute.name} value: ${attribute.value}');
        print('element: ${_element.getAttribute(attribute.name.toString())}');
        return _element.getAttribute(attribute.name.toString()) == null;
      },
    );

    for (final attribute in newAttributes) {
      _element.setAttribute(attribute.name.toString(), attribute.value);
    }
  }
}

class _TiledTemplateFile {
  const _TiledTemplateFile(this._object);

  static _TiledTemplateFile fromFile(File file) {
    if (!file.existsSync()) {
      throw Exception('File does not exist: ${file.path}');
    }

    final contents = file.readAsStringSync();
    final document = XmlDocument.parse(contents);
    final object = document.findAllElements('object').firstOrNull;

    if (object == null) {
      throw Exception('No object found in file: ${file.path}');
    }

    return _TiledTemplateFile(object);
  }

  final XmlElement _object;
}

// TODO(OlliePugh): The documentation here should follow
// EffectiveDart convention:
// https://dart.dev/guides/language/effective-dart/documentation

/// tiled doesnt parse template information properly
/// this function will copy all template data into
/// any objects
///
/// This script should be run from `tool/tiled_map_parser`, otherwise it will
/// throw an error.
void main() async {
  final logger = Logger();

  final scriptPath = path.join('tool', 'tiled_map_parser');
  if (!Directory.current.path.endsWith(scriptPath)) {
    throw Exception(
      'This script should be run from the `$scriptPath` directory',
    );
  }

  final assetsDirectory = Directory(
    path.join('..', '..', 'packages', 'trashy_road', 'assets', 'tiles'),
  );

  final tmxFiles = assetsDirectory
      .listSync()
      .whereType<File>()
      .where((file) => path.extension(file.path) == _tiledMapExtension)
      .toSet();

  logger.info('Found ${tmxFiles.length} .tmx files');

  for (final file in tmxFiles) {
    final tmxFile = XmlDocument.parse(file.readAsStringSync());
    final objects = tmxFile.findAllElements('object').toList();
    logger.info('Found ${objects.length} objects in ${file.path}');

    final templates =
        objects.map(_TiledObject.tryParse).whereType<_TiledObject>();
    logger.info('Found ${templates.length} templates in ${file.path}');

    for (final template in templates) {
      template.addTemplateData(assetsDirectory.path);
    }

    file.writeAsStringSync(tmxFile.toXmlString(pretty: true));
  }
}
