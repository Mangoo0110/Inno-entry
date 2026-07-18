// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EntryModel {

@JsonKey(name: EntryModelFields.id, fromJson: EntryModel._entryUidFromJson, toJson: EntryModel._entryUidToJson) EntryUid get uId; String get owner; String get title; String get note; double? get amount; String get category; bool get done; String? get photoPath; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of EntryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntryModelCopyWith<EntryModel> get copyWith => _$EntryModelCopyWithImpl<EntryModel>(this as EntryModel, _$identity);

  /// Serializes this EntryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EntryModel&&(identical(other.uId, uId) || other.uId == uId)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.title, title) || other.title == title)&&(identical(other.note, note) || other.note == note)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.category, category) || other.category == category)&&(identical(other.done, done) || other.done == done)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uId,owner,title,note,amount,category,done,photoPath,createdAt,updatedAt);

@override
String toString() {
  return 'EntryModel(uId: $uId, owner: $owner, title: $title, note: $note, amount: $amount, category: $category, done: $done, photoPath: $photoPath, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $EntryModelCopyWith<$Res>  {
  factory $EntryModelCopyWith(EntryModel value, $Res Function(EntryModel) _then) = _$EntryModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: EntryModelFields.id, fromJson: EntryModel._entryUidFromJson, toJson: EntryModel._entryUidToJson) EntryUid uId, String owner, String title, String note, double? amount, String category, bool done, String? photoPath, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$EntryModelCopyWithImpl<$Res>
    implements $EntryModelCopyWith<$Res> {
  _$EntryModelCopyWithImpl(this._self, this._then);

  final EntryModel _self;
  final $Res Function(EntryModel) _then;

/// Create a copy of EntryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uId = null,Object? owner = null,Object? title = null,Object? note = null,Object? amount = freezed,Object? category = null,Object? done = null,Object? photoPath = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
uId: null == uId ? _self.uId : uId // ignore: cast_nullable_to_non_nullable
as EntryUid,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [EntryModel].
extension EntryModelPatterns on EntryModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EntryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EntryModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EntryModel value)  $default,){
final _that = this;
switch (_that) {
case _EntryModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EntryModel value)?  $default,){
final _that = this;
switch (_that) {
case _EntryModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: EntryModelFields.id, fromJson: EntryModel._entryUidFromJson, toJson: EntryModel._entryUidToJson)  EntryUid uId,  String owner,  String title,  String note,  double? amount,  String category,  bool done,  String? photoPath,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EntryModel() when $default != null:
return $default(_that.uId,_that.owner,_that.title,_that.note,_that.amount,_that.category,_that.done,_that.photoPath,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: EntryModelFields.id, fromJson: EntryModel._entryUidFromJson, toJson: EntryModel._entryUidToJson)  EntryUid uId,  String owner,  String title,  String note,  double? amount,  String category,  bool done,  String? photoPath,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _EntryModel():
return $default(_that.uId,_that.owner,_that.title,_that.note,_that.amount,_that.category,_that.done,_that.photoPath,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: EntryModelFields.id, fromJson: EntryModel._entryUidFromJson, toJson: EntryModel._entryUidToJson)  EntryUid uId,  String owner,  String title,  String note,  double? amount,  String category,  bool done,  String? photoPath,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _EntryModel() when $default != null:
return $default(_that.uId,_that.owner,_that.title,_that.note,_that.amount,_that.category,_that.done,_that.photoPath,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EntryModel extends EntryModel {
   _EntryModel({@JsonKey(name: EntryModelFields.id, fromJson: EntryModel._entryUidFromJson, toJson: EntryModel._entryUidToJson) required this.uId, required this.owner, required this.title, required this.note, required this.amount, required this.category, required this.done, this.photoPath, required this.createdAt, required this.updatedAt}): super._();
  factory _EntryModel.fromJson(Map<String, dynamic> json) => _$EntryModelFromJson(json);

@override@JsonKey(name: EntryModelFields.id, fromJson: EntryModel._entryUidFromJson, toJson: EntryModel._entryUidToJson) final  EntryUid uId;
@override final  String owner;
@override final  String title;
@override final  String note;
@override final  double? amount;
@override final  String category;
@override final  bool done;
@override final  String? photoPath;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of EntryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EntryModelCopyWith<_EntryModel> get copyWith => __$EntryModelCopyWithImpl<_EntryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EntryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EntryModel&&(identical(other.uId, uId) || other.uId == uId)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.title, title) || other.title == title)&&(identical(other.note, note) || other.note == note)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.category, category) || other.category == category)&&(identical(other.done, done) || other.done == done)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uId,owner,title,note,amount,category,done,photoPath,createdAt,updatedAt);

@override
String toString() {
  return 'EntryModel(uId: $uId, owner: $owner, title: $title, note: $note, amount: $amount, category: $category, done: $done, photoPath: $photoPath, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$EntryModelCopyWith<$Res> implements $EntryModelCopyWith<$Res> {
  factory _$EntryModelCopyWith(_EntryModel value, $Res Function(_EntryModel) _then) = __$EntryModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: EntryModelFields.id, fromJson: EntryModel._entryUidFromJson, toJson: EntryModel._entryUidToJson) EntryUid uId, String owner, String title, String note, double? amount, String category, bool done, String? photoPath, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$EntryModelCopyWithImpl<$Res>
    implements _$EntryModelCopyWith<$Res> {
  __$EntryModelCopyWithImpl(this._self, this._then);

  final _EntryModel _self;
  final $Res Function(_EntryModel) _then;

/// Create a copy of EntryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uId = null,Object? owner = null,Object? title = null,Object? note = null,Object? amount = freezed,Object? category = null,Object? done = null,Object? photoPath = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_EntryModel(
uId: null == uId ? _self.uId : uId // ignore: cast_nullable_to_non_nullable
as EntryUid,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
