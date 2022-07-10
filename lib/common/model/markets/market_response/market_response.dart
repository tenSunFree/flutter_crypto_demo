import 'package:flutter_crypto_demo/common/model/allowance/allowance.dart';
import 'package:flutter_crypto_demo/common/model/markets/pair/pair.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'market_response.g.dart';
part 'market_response.freezed.dart';

@freezed
abstract class MarketResponse with _$MarketResponse {
  const factory MarketResponse(
      {required List<Pair> result,
      required Allowance allowance}) = _MarketResponse;
  factory MarketResponse.fromJson(Map<String, dynamic> json) =>
      _$MarketResponseFromJson(json);
}
