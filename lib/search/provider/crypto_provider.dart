import 'package:dio/dio.dart';
import 'package:flutter_crypto_demo/common/model/graph/graph/graph.dart';
import 'package:flutter_crypto_demo/common/model/markets/pair/pair.dart';
import 'package:flutter_crypto_demo/common/model/pair/pair_summary/pair_summary.dart';
import 'package:flutter_crypto_demo/search/model/crypto_repository.dart';
import 'package:flutter_crypto_demo/search/provider/time_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchStringProvider = StateProvider<String>((ref) => "");

final filterPairListProvider = FutureProvider<List<Pair>?>((ref) async {
  final pairs = ref.watch(pairListProvider);
  final search = ref.watch(searchStringProvider);
  List<Pair>? list;
  pairs.maybeWhen(
      data: (data) {
        if (search.isNotEmpty) {
          list =
              data.where((element) => element.pair.contains(search)).toList();
        } else {
          list = data;
        }
      },
      orElse: () => {});
  return list;
});

final pairListProvider = FutureProvider<List<Pair>>((ref) async {
  String exchangeName = 'binance';
  List<Pair> pairs = await ref.read(cryptoRepository).getPairs(exchangeName);
  return pairs;
});

final pairSummaryProvider =
    FutureProvider.family<PairSummary, Pair>((ref, pair) async {
  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel());

  final pairSummary = await ref
      .read(cryptoRepository)
      .getPairSummary(pair.exchange, pair.pair, cancelToken: cancelToken);
  return pairSummary;
});

final graphDataProvider = FutureProvider.family<Graph, Pair>((ref, pair) async {
  String interval = ref.watch(timeDataProvider).periods;
  String fromHours = ref.watch(timeDataProvider).before;
  String before = "";
  if (fromHours.isNotEmpty) {
    before = (DateTime.now()
                .subtract(Duration(hours: int.parse(fromHours)))
                .toUtc()
                .millisecondsSinceEpoch ~/
            1000)
        .toString();
  }
  final graph = await ref.read(cryptoRepository).getPairGraph(
      pair.exchange, pair.pair,
      periods: interval, before: before);
  return graph;
});
