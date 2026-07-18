// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EntryModel _$EntryModelFromJson(Map<String, dynamic> json) => _EntryModel(
  uId: EntryModel._entryUidFromJson(json['id'] as Object),
  owner: json['owner'] as String,
  title: json['title'] as String,
  note: json['note'] as String,
  amount: (json['amount'] as num?)?.toDouble(),
  category: json['category'] as String,
  done: json['done'] as bool,
  photoPath: json['photoPath'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$EntryModelToJson(_EntryModel instance) =>
    <String, dynamic>{
      'id': EntryModel._entryUidToJson(instance.uId),
      'owner': instance.owner,
      'title': instance.title,
      'note': instance.note,
      'amount': instance.amount,
      'category': instance.category,
      'done': instance.done,
      'photoPath': instance.photoPath,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
