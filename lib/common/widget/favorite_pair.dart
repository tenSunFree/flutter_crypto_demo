import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crypto_demo/common/locale_keys.g.dart';
import 'package:flutter_crypto_demo/common/model/markets/favorite_pair/favorite_pair.dart';
import 'package:flutter_crypto_demo/common/widget/title_price.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FavoritePairWidget extends HookWidget {
  final FavoritePair data;

  const FavoritePairWidget(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          TitlePrice(pair: data.pair),
          Container(
            margin: const EdgeInsets.only(top: 10),
            color: Theme.of(context).dividerColor,
            height: 1,
            width: double.infinity,
          ),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.add_chart,
                    size: 30,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(width: 10),
                  Text(LocaleKeys.openChart.tr(),
                      style: Theme.of(context).textTheme.headline3),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            color: Theme.of(context).dividerColor,
            height: 1,
            width: double.infinity,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
