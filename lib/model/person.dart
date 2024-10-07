import 'dart:typed_data';

class Person {
  final String name;
  final Uint8List faceJpg;
  final Uint8List templates;

  const Person({
    required this.name,
    required this.faceJpg,
    required this.templates,
  });

  factory Person.fromMap(Map<String, dynamic> data) {
    return Person(
      name: data['name'],
      faceJpg: Uint8List.fromList((data['faceJpg'] as List).map((e) => int.parse(e.toString())).toList()),
      templates: Uint8List.fromList((data['templates'] as List).map((e) => int.parse(e.toString())).toList())
    );
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'name': name,
      'faceJpg': faceJpg,
      'templates': templates,
    };
    return map;
  }
}
