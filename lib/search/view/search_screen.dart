import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_crypto_demo/search/provider/crypto_provider.dart';
import 'package:flutter_crypto_demo/common/locale_keys.g.dart';
import 'package:flutter_crypto_demo/common/widget/pair_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = ref.read(searchStringProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pairs = ref.watch(filterPairListProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(),
      ),
      body: Container(
        color: const Color(0xFF0E1318),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 57,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12)),
                      color: Color(0xFF242F3E),
                    ),
                    child: TextFormField(
                      cursorColor: Colors.grey,
                      controller: _controller,
                      style: const TextStyle(color: Colors.white, fontSize: 21),
                      decoration: InputDecoration(
                          prefixIcon: InkWell(
                            onTap: () async {
                              await SystemChannels.platform
                                  .invokeMethod('SystemNavigator.pop');
                            },
                            child: const Icon(Icons.arrow_back,
                                color: Colors.white, size: 32),
                          ),
                          suffixIcon: ref.read(searchStringProvider).isNotEmpty
                              ? InkWell(
                                  onTap: () {
                                    ref
                                        .read(searchStringProvider.notifier)
                                        .state = '';
                                    _controller.text = '';
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                )
                              : null,
                          hintText: LocaleKeys.searchBar.tr(),
                          hintStyle: const TextStyle(
                              color: Color(0xFF5B6B7F), fontSize: 20),
                          border: InputBorder.none),
                      onChanged: (value) {
                        ref.read(searchStringProvider.notifier).state = value;
                      },
                    ),
                  ),
                  Expanded(
                    child: pairs.maybeWhen(
                        data: (data) {
                          return Stack(
                            children: [
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: data?.length ?? 0,
                                itemBuilder: (ctx, int id) {
                                  return ProviderScope(
                                    overrides: [
                                      currentPair.overrideWithValue(data![id]),
                                    ],
                                    child: const PairTile(),
                                  );
                                },
                              ),
                              if (data == null)
                                const Center(
                                  child: CircularProgressIndicator(),
                                )
                              else if (data.isEmpty)
                                Center(child: Text(LocaleKeys.noResults.tr()))
                            ],
                          );
                        },
                        orElse: () => const Center(
                              child: CircularProgressIndicator(),
                            )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
