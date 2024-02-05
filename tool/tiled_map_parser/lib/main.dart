import 'dart:io';
import 'package:xml/xml.dart';

/// tiled doesnt parse template information properly
/// this function will copy all template data into
/// any objects
void main() async {
// Get the system temp directory.
  final dir = Directory('assets/tiles/'); // loop through dir

  dir
      .list(recursive: true, followLinks: false)
      .listen((FileSystemEntity entity) async {
    final extension = ".${entity.path.split('.').last}";

    if (extension != '.tmx') {
      return; // if extension isnt .tmx we don't want to modify
    }
    final file = File(entity.path);
    final document = XmlDocument.parse(file.readAsStringSync());

    document.findAllElements('objectgroup').toList().forEach((e) {
      for (final element in e.children) {
        final template = element.getAttribute('template');
        if (template != null) {
          // if the object has a template
          final templateFile = File('assets/tiles/$template');
          final templateDoc =
              XmlDocument.parse(templateFile.readAsStringSync());
          for (final attribute
              in templateDoc.findAllElements('object').toList()[0].attributes) {
            final parsedAttribute = attribute.toString().split('=');

            element.setAttribute(
              parsedAttribute[0],
              parsedAttribute[1].replaceAll('"', ''),
            );
          }
        }
      }
    });

    file.writeAsStringSync(document.toXmlString());
  });
}
