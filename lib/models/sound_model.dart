import 'dart:convert';

import 'package:flutter/foundation.dart';

class SoundModel {
  final int id;
  final String username;
  final String name;
  final List<String> tags;
  
  SoundModel({
    required this.id,
    required this.username,
    required this.name,
    required this.tags,
  });

  SoundModel copyWith({
    int? id,
    String? username,
    String? name,
    List<String>? tags,
  }) {
    return SoundModel(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'tags': tags,
    };
  }

  factory SoundModel.fromMap(Map<String, dynamic> map) {
    return SoundModel(
      id: map['id']?.toInt() ?? 0,
      username: map['username'] ?? '',
      name: map['name'] ?? '',
      tags: List<String>.from(map['tags']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SoundModel.fromJson(String source) => SoundModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SoundModel(id: $id, username: $username, name: $name, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SoundModel &&
      other.id == id &&
      other.username == username &&
      other.name == name &&
      listEquals(other.tags, tags);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      username.hashCode ^
      name.hashCode ^
      tags.hashCode;
  }
  }
