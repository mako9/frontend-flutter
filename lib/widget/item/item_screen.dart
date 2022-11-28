import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../model/data_response.dart';
import '../../model/item.dart';
import 'item_cubit.dart';

class ItemScreen extends StatelessWidget {
  const ItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ItemCubit.ofInitialState(),
      child: const _ItemScreenContent(),
    );
  }
}

//ignore: must_be_immutable
class _ItemScreenContent extends StatefulWidget {
  const _ItemScreenContent();

  @override
  State<StatefulWidget> createState() {
    return _ItemScreenState();
  }
}

class _ItemScreenState extends State<_ItemScreenContent> {
  bool _isInitialized = false;
  late List<int> _indices;
  late Map<ItemCategory, List<Item>> _groupedItems;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemCubit, DataResponse<Map<ItemCategory, List<Item>>>>(
        builder: (_, dataResponse) {
      if (dataResponse.errorMessage != null) {
        return Text(AppLocalizations.of(context)!
            .errorMessage(dataResponse.errorMessage!));
      } else if (dataResponse.data == null) {
        return Text(AppLocalizations.of(context)!.emptyList);
      }
      _groupedItems = dataResponse.data!;
      if (!_isInitialized) {
        _indices = List.filled(_groupedItems.keys.length, 0);
        _isInitialized = true;
      }
      return Scaffold(
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          itemCount: _groupedItems.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildCarousel(context, index);
          },
        ),
      );
    });
  }

  Widget _buildCarousel(BuildContext context, int carouselIndex) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              _groupedItems.keys.elementAt(carouselIndex).getName(context),
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )),
        SizedBox(
          // you may want to use an aspect ratio here for tablet support
          height: 200.0,
          child: PageView.builder(
            // store this controller in a State to save the carousel scroll position
            controller: PageController(viewportFraction: 0.8),
            onPageChanged: (int index) =>
                setState(() => _indices[carouselIndex] = index),
            itemCount: _groupedItems.values.elementAt(carouselIndex).length,
            itemBuilder: (BuildContext context, int itemIndex) {
              return _buildCarouselItem(context, carouselIndex, itemIndex);
            },
          ),
        )
      ],
    );
  }

  Widget _buildCarouselItem(
      BuildContext context, int carouselIndex, int itemIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Transform.scale(
        scale: itemIndex == _indices[carouselIndex] ? 1 : 0.9,
        child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Column(
                children: [
                  Image.asset('/image/fox.png', height: 120, width: 300),
                  const SizedBox(height: 16),
                  Text(_groupedItems.values
                          .elementAt(carouselIndex)
                          .elementAt(itemIndex)
                          .name ??
                      "Unknown")
                ],
              )),
        ),
      ),
    );
  }
}
