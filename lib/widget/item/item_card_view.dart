import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../model/item.dart';

typedef CardViewIndexCallback = void Function(int firstIndex, int secondIndex);

class ItemCardView extends StatefulWidget {
  late final List<int> _indices;
  late final Map<ItemCategory, List<Item>>? _groupedItems;
  late final String? _errorMessage;
  late final CardViewIndexCallback? _onTap;

  ItemCardView(Map<ItemCategory, List<Item>>? groupedItems, String? errorMessage, CardViewIndexCallback? onTap, {super.key}) {
    _groupedItems = groupedItems;
    _indices = List.filled(_groupedItems?.keys.length ?? 0, 0);
    _errorMessage = errorMessage;
    _onTap = onTap;
  }

  @override
  State<StatefulWidget> createState() {
    return _ItemCardViewState();
  }
}

class _ItemCardViewState extends State<ItemCardView> {

  @override
  Widget build(BuildContext context) {
    if (widget._errorMessage != null) {
      return _centeredText(context, AppLocalizations.of(context)!
          .errorMessage(widget._errorMessage ?? "Unknown"));
    } else if (widget._groupedItems == null) {
      return _centeredText(context, AppLocalizations.of(context)!.emptyList);
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 24),
      shrinkWrap: true,
      itemCount: widget._groupedItems?.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildCarousel(context, index);
      },
    );
  }

  Widget _centeredText(BuildContext context, String text) {
    return Column(children: [
      const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [PlatformText(text)]),
    ]);
  }

  Widget _buildCarousel(BuildContext context, int carouselIndex) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: PlatformText(
              widget._groupedItems?.keys.elementAt(carouselIndex).getName(context) ?? "Unknown",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )),
        SizedBox(
          // you may want to use an aspect ratio here for tablet support
          height: 200.0,
          child: PageView.builder(
            // store this controller in a State to save the carousel scroll position
            controller: PageController(viewportFraction: 0.8),
            onPageChanged: (int index) =>
                setState(() => widget._indices[carouselIndex] = index),
            itemCount: widget._groupedItems?.values.elementAt(carouselIndex).length,
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
    final item = widget._groupedItems?.values
        .elementAt(carouselIndex)
        .elementAt(itemIndex);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Transform.scale(
        scale: itemIndex == widget._indices[carouselIndex] ? 1 : 0.9,
        child: Card(
          elevation: 6,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: InkWell(
            child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Column(
                  children: [
                    Image.asset('/image/fox.png', height: 120, width: 300),
                    const SizedBox(height: 16),
                    Text(item?.name ?? "Unknown")
                  ],
                )
            ),
            onTap: () => {
              if (widget._onTap != null) widget._onTap!(carouselIndex, itemIndex)
            },
          ),
        ),
      ),
    );
  }
}