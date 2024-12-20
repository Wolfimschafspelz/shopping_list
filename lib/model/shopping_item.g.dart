// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingItem _$ShoppingItemFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'name', 'amount', 'bought', 'price', 'unit'],
  );
  return ShoppingItem(
    json['id'] as String,
    name: json['name'] as String,
    bought: json['bought'] as bool? ?? false,
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
    amount: (json['amount'] as num?)?.toDouble() ?? 1,
    unit: $enumDecodeNullable(_$MeasureEnumMap, json['unit']) ?? Measure.none,
  );
}

Map<String, dynamic> _$ShoppingItemToJson(ShoppingItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'bought': instance.bought,
      'price': instance.price,
      'unit': _$MeasureEnumMap[instance.unit]!,
    };

const _$MeasureEnumMap = {
  Measure.none: 'none',
  Measure.l: 'l',
  Measure.kg: 'kg',
};
