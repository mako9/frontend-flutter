import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend_flutter/model/listable_model.dart';

import '../../model/data_page.dart';
import 'loading_overlay.dart';

typedef PaginatedListIndexCallback = void Function(int index);

class CustomPaginatedList extends StatelessWidget {
  late final DataPage _page;
  late final List<ListableModel> _content;
  late final int _pageSize;
  late final PaginatedListIndexCallback? _onElementTap;
  late final PaginatedListIndexCallback? _onPageChangeTap;

  CustomPaginatedList(DataPage page,
      {super.key,
        int? pagesSize,
        PaginatedListIndexCallback? onElementTap,
        PaginatedListIndexCallback? onPageChangeTap}) {
    _page = page;
    _content = page.content as List<ListableModel>;
    _pageSize = pagesSize ?? 10;
    _onElementTap = onElementTap;
    _onPageChangeTap = onPageChangeTap;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      if (_content.isEmpty) ...[
        Text(AppLocalizations.of(context)!.emptyList)
      ] else ...[
        ListView.builder(
            shrinkWrap: true,
            itemCount: _content.length,
            itemBuilder: (context, index) {
              return Card(
                  child: ListTile(
                    enabled: _onElementTap != null,
                title: Text(_content[index].title()),
                onTap: () {
                  if (_onElementTap != null) _onElementTap!(index);
                },
              ));
            }),
        if (_page.content.length > _pageSize) ...[
          SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                      onPressed: (_page.pageNumber - 1 <= 0)
                          ? null
                          : () {
                              LoadingOverlay.of(context).show();
                              if (_onPageChangeTap != null) _onPageChangeTap!(_page.pageNumber - 1);
                            },
                      child: const Icon(Icons.navigate_before)),
                  const SizedBox(width: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          width: 24,
                          child: TextFormField(
                              initialValue: (_page.pageNumber + 1).toString(),
                              keyboardType: TextInputType.number,
                              onFieldSubmitted: (value) {
                                if (int.parse(value) < 0 ||
                                    int.parse(value) > _page.totalPages) {
                                  return;
                                }
                                LoadingOverlay.of(context).show();
                                if (_onPageChangeTap != null) _onPageChangeTap!(int.parse(value) - 1);
                              })),
                      const SizedBox(width: 12),
                      Text(AppLocalizations.of(context)!
                          .communityScreen_ofPages(_page.totalPages))
                    ],
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                      onPressed: (_page.pageNumber + 1 >= _page.totalPages)
                          ? null
                          : () {
                              if (_page.pageNumber + 1 > _page.totalPages) {
                                return;
                              }
                              LoadingOverlay.of(context).show();
                              if (_onPageChangeTap != null) _onPageChangeTap!(_page.pageNumber + 1);
                            },
                      child: const Icon(Icons.navigate_next)),
                ],
              )),
        ]
      ]
    ]);
  }
}
