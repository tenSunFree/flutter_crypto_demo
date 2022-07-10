import 'package:flutter_crypto_demo/common/model/allowance/allowance.dart';
import 'package:flutter_crypto_demo/common/model/graph/graph/graph.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'graph_response.freezed.dart';

@freezed
abstract class GraphResponse with _$GraphResponse {
  const factory GraphResponse(
      {required Graph result, required Allowance allowance}) = _GraphResponse;

  factory GraphResponse.fromJson(Map<String, dynamic> json) {
    final result = Graph.fromJson(json['result']);
    final allowance = Allowance.fromJson(json['allowance']);
    return GraphResponse(result: result, allowance: allowance);
  }
}
