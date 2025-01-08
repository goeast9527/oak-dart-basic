import 'dart:convert';

import 'package:built_value/serializer.dart';
import 'package:oak_dart_basic/src/json/json_serializable_object.dart';
import 'package:oak_dart_basic/src/utils/string_utils.dart';

/// 基于 built_value 的 json serializer
/// doc [https://github.com/google/built_value.dart]
class BuiltJsonSerializers {
  final Serializers serializers;

  BuiltJsonSerializers._(this.serializers);

  factory BuiltJsonSerializers(Serializers serializers) {
    return BuiltJsonSerializers._(serializers);
  }

  /// parse json [String] or [Map] or [List] or [Set] to object
  /// [source] type [String] or  [Map] or [List] or [Set]
  /// [resultType]  结果数据类型
  /// [formJson]    自定义的 formJson 工厂方法
  /// [specifiedType]  FullType 存在泛型时需要
  /// 泛型支持需要 [SerializersBuilder.addBuilderFactory]
  T? parseObject<T>(dynamic source,
      {Type? resultType, Function? formJson, FullType specifiedType = FullType.unspecified}) {
    if (_isEmpty(source)) {
      return null;
    }

    final json = _tryJsonDecode(source);
    if (formJson != null) {
      // 自定义的fromJson方法
      return formJson(json);
    }
    if (resultType == null) {
      if (_isSpecifiedType(specifiedType)) {
        return this.serializers.deserialize(json, specifiedType: specifiedType) as T;
      } else {
        throw new ArgumentError("parameter resultType is null and specifiedType is null or invalid");
      }
    }

    final serializer = serializers.serializerForType(resultType);
    if (serializer == null) {
      if (_isSpecifiedType(specifiedType)) {
        return this.serializers.deserialize(json, specifiedType: specifiedType) as T;
      }
      return json;
    }

    // 需要使用泛型
    if (_isGeneric(serializer, specifiedType)) {
      return _deserializeWithGeneric(json, serializer, specifiedType);
    }

    return this.serializers.deserializeWith(serializer, json) as T;
  }

  /// object to string
  /// [object] serialize object
  /// [specifiedType]
  String? toJson<T>(object, {FullType? specifiedType}) {
    if (_isEmpty(object)) {
      return null;
    }

    final serializer = serializers.serializerForType(object.runtimeType);
    if (serializer == null) {
      return jsonEncode(object);
    }

    if (object is JsonSerializableObject) {
      return object.toJson();
    }

    // 需要使用泛型
    if (_isGeneric(serializer, specifiedType)) {
      return _serializeWhitGeneric(object, serializer as StructuredSerializer, specifiedType ?? FullType.unspecified);
    }

    return jsonEncode(this.serializers.serializeWith(serializer, object));
  }

  bool _isEmpty(source) => source == null || (source is String && !StringUtils.hasText(source));

  bool _isGeneric(Serializer<dynamic> serializer, FullType? specifiedType) {
    return serializer is StructuredSerializer && _isSpecifiedType(specifiedType);
  }

  _deserializeWithGeneric(Map json, Serializer<dynamic> serializer, FullType specifiedType) {
    final list = [];
    json.forEach((key, val) {
      list.add(key);
      list.add(val);
    });
    return (serializer as StructuredSerializer).deserialize(this.serializers, list, specifiedType: specifiedType);
  }

  _tryJsonDecode(source) => source is String ? json.decode(source) : source;

  bool _isSpecifiedType(FullType? specifiedType) =>
      specifiedType != null && specifiedType != FullType.unspecified && specifiedType != FullType.object;

  String _serializeWhitGeneric(object, StructuredSerializer<dynamic> serializer, FullType specifiedType) {
    // 泛型支持
    final result = serializer.serialize(this.serializers, object, specifiedType: specifiedType);
    final iterator = result.iterator;
    final map = {};
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      map[key] = value;
    }
    return jsonEncode(map);
  }
}
