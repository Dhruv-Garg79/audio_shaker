import 'dart:convert';

import 'package:flutter/foundation.dart';

class SoundDetailModel {
  final int id;
  final String username;
  final String name;
  final String description;
  final List<String> tags;
  final int bitrate;
  final int bitdepth;
  final int duration;
  final int samplerate;
  final String assetUrl;
  final String imageUrl;

  SoundDetailModel({
    required this.id,
    required this.username,
    required this.name,
    required this.description,
    required this.tags,
    required this.bitrate,
    required this.bitdepth,
    required this.duration,
    required this.samplerate,
    required this.assetUrl,
    required this.imageUrl,
  });

  SoundDetailModel copyWith({
    int? id,
    String? username,
    String? name,
    String? description,
    List<String>? tags,
    int? bitrate,
    int? bitdepth,
    int? duration,
    int? samplerate,
    String? assetUrl,
    String? imageUrl,
  }) {
    return SoundDetailModel(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      bitrate: bitrate ?? this.bitrate,
      bitdepth: bitdepth ?? this.bitdepth,
      duration: duration ?? this.duration,
      samplerate: samplerate ?? this.samplerate,
      assetUrl: assetUrl ?? this.assetUrl,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'description': description,
      'tags': tags,
      'bitrate': bitrate,
      'bitdepth': bitdepth,
      'duration': duration,
      'samplerate': samplerate,
      'assetUrl': assetUrl,
      'imageUrl': imageUrl,
    };
  }

  factory SoundDetailModel.fromMap(Map<String, dynamic> map) {
    return SoundDetailModel(
      id: map['id']?.toInt() ?? 0,
      username: map['username'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      tags: List<String>.from(map['tags']),
      bitrate: map['bitrate']?.toInt() ?? 0,
      bitdepth: map['bitdepth']?.toInt() ?? 0,
      duration: map['duration']?.toInt() ?? 0,
      samplerate: map['samplerate']?.toInt() ?? 0,
      assetUrl: map['previews']['preview-hq-mp3'] ?? '',
      imageUrl: map['images']['waveform_l'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SoundDetailModel.fromJson(String source) =>
      SoundDetailModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SoundDetailModel(id: $id, username: $username, name: $name, description: $description, tags: $tags, bitrate: $bitrate, bitdepth: $bitdepth, duration: $duration, samplerate: $samplerate, assetUrl: $assetUrl, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SoundDetailModel &&
        other.id == id &&
        other.username == username &&
        other.name == name &&
        other.description == description &&
        listEquals(other.tags, tags) &&
        other.bitrate == bitrate &&
        other.bitdepth == bitdepth &&
        other.duration == duration &&
        other.samplerate == samplerate &&
        other.assetUrl == assetUrl &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        name.hashCode ^
        description.hashCode ^
        tags.hashCode ^
        bitrate.hashCode ^
        bitdepth.hashCode ^
        duration.hashCode ^
        samplerate.hashCode ^
        assetUrl.hashCode ^
        imageUrl.hashCode;
  }
}
