import 'package:dio/dio.dart';
import 'package:flutter_crypto_demo/common/exceptions.dart';
import 'package:flutter_crypto_demo/common/model/exchanges/exchange/exchange.dart';
import 'package:flutter_crypto_demo/common/model/exchanges/exchanges_response/exchanges_response.dart';
import 'package:flutter_crypto_demo/common/model/graph/graph/graph.dart';
import 'package:flutter_crypto_demo/common/model/graph/graph_response/graph_response.dart';
import 'package:flutter_crypto_demo/common/model/markets/market_response/market_response.dart';
import 'package:flutter_crypto_demo/common/model/markets/pair/pair.dart';
import 'package:flutter_crypto_demo/common/model/pair/pair_response/pair_response.dart';
import 'package:flutter_crypto_demo/common/model/pair/pair_summary/pair_summary.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final clientProvider = Provider((ref) => Dio(BaseOptions(headers: {
      "X-CW-API-Key": dotenv.env['API_KEY'],
    }, baseUrl: 'https://api.cryptowat.ch')));

final cryptoRepository =
    Provider<CryptoRepositoryAPI>((ref) => CryptoRepositoryAPI(ref.read));

abstract class CryptoRepository {
  Future<List<Pair>> getPairs(String market);

  Future<PairSummary> getPairSummary(String makeret, String pair);

  Future<Graph> getPairGraph(String market, String pair,
      {String periods, String after, String before});

  Future<List<Exchange>> getExchanges();
}

class CryptoRepositoryAPI implements CryptoRepository {
  final Reader read;

  CryptoRepositoryAPI(this.read);

  @override
  Future<List<Pair>> getPairs(String market, {CancelToken? cancelToken}) async {
    try {
      final response = await read(clientProvider)
          .get('/markets/$market', cancelToken: cancelToken);
      return MarketResponse.fromJson(response.data).result;
    } on DioError catch (error) {
      throw DataException.fromDioError(error);
    }
  }

  @override
  Future<PairSummary> getPairSummary(String market, String pair,
      {CancelToken? cancelToken}) async {
    try {
      final response = await read(clientProvider)
          .get('/markets/$market/$pair/summary', cancelToken: cancelToken);
      return PairResponse.fromJson(response.data).result;
    } on DioError catch (error) {
      throw DataException.fromDioError(error);
    }
  }

  @override
  Future<Graph> getPairGraph(String market, String pair,
      {String periods = "",
      String after = "",
      String before = "",
      CancelToken? cancelToken}) async {
    try {
      final response = await read(clientProvider).get(
          '/markets/$market/$pair/ohlc',
          queryParameters: {
            "periods": periods,
            "after": after,
            "before": before
          },
          cancelToken: cancelToken);
      return GraphResponse.fromJson(response.data).result;
    } on DioError catch (error) {
      throw DataException.fromDioError(error);
    }
  }

  @override
  Future<List<Exchange>> getExchanges({CancelToken? cancelToken}) async {
    try {
      final response = await read(clientProvider)
          .get('/exchanges', cancelToken: cancelToken);
      return ExchangesResponse.fromJson(response.data).result;
    } on DioError catch (error) {
      throw DataException.fromDioError(error);
    }
  }
}
