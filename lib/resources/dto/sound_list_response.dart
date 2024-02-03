import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:audio_shaker/models/sound_model.dart';

class SoundListResponse {
  final int count;
  final List<SoundModel> results;

  SoundListResponse({
    required this.count,
    required this.results,
  });

  SoundListResponse copyWith({
    int? count,
    List<SoundModel>? results,
  }) {
    return SoundListResponse(
      count: count ?? this.count,
      results: results ?? this.results,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'count': count,
      'results': results.map((x) => x.toMap()).toList(),
    };
  }

  factory SoundListResponse.fromMap(Map<String, dynamic> map) {
    return SoundListResponse(
      count: map['count']?.toInt() ?? 0,
      results: List<SoundModel>.from(
          map['results']?.map((x) => SoundModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory SoundListResponse.fromJson(String source) =>
      SoundListResponse.fromMap(json.decode(source));

  @override
  String toString() => 'SoundListResponse(count: $count, results: $results)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SoundListResponse &&
        other.count == count &&
        listEquals(other.results, results);
  }

  @override
  int get hashCode => count.hashCode ^ results.hashCode;
}
