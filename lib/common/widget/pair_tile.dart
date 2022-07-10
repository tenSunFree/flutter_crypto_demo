import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crypto_demo/common/model/markets/pair/pair.dart';
import 'package:flutter_crypto_demo/search/provider/crypto_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_crypto_demo/common/utils.dart' as Utils;
import 'line_chart.dart';

final currentPair = Provider<Pair>((ref) => const Pair(exchange: "", pair: ""));

class PairTile extends HookConsumerWidget {
  const PairTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pair = ref.watch(currentPair);
    final summary = ref.watch(pairSummaryProvider(pair));
    final graph = ref.watch(graphDataProvider(pair));
    return Column(
      children: [
        Container(
          color: const Color(0xFF1A222E),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: summary.when(
                  data: (final summary) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            width: 80,
                            child: AutoSizeText(pair.pair,
                                textAlign: TextAlign.start,
                                minFontSize: 0,
                                stepGranularity: 0.1,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.headline5),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            height: 50,
                            child: graph.when(
                                data: (data) => LineChartWidget(
                                      color: summary.price.change.absolute < 0
                                          ? Colors.red
                                          : const Color(0xff02d39a),
                                      data: Utils.getPoints(data),
                                    ),
                                loading: () =>
                                    const LineChartWidget(loading: true),
                                error: (e, ex) =>
                                    const LineChartWidget(error: true)),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            padding: const EdgeInsets.only(top: 25, left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                AutoSizeText(
                                  summary.price.last.toStringAsFixed(2),
                                  minFontSize: 10,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                const SizedBox(height: 5),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: AutoSizeText(
                                            summary.price.change.absolute
                                                .toStringAsFixed(5),
                                            textAlign: TextAlign.end,
                                            minFontSize: 0,
                                            stepGranularity: 0.1,
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5!
                                                .apply(
                                                    color: summary.price.change
                                                                .absolute >=
                                                            0
                                                        ? Colors.green
                                                        : Colors.red)),
                                      ),
                                      AutoSizeText(
                                          ' (${summary.price.change.percentage.toStringAsFixed(2)}%)',
                                          textAlign: TextAlign.end,
                                          minFontSize: 0,
                                          stepGranularity: 0.1,
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                    ]),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stk) =>
                      Center(child: Text(error.toString().tr()))),
            ),
          ),
        ),
        const Divider(
          height: 1,
          color: Color(0xFF1B232F),
        )
      ],
    );
  }
}
