import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend_flutter/model/listable_model.dart';

import '../../model/data_page.dart';
import 'loading_overlay.dart';

typedef PaginatedListIndexCallback = void Function(int index);

class CustomPaginatedList extends StatefulWidget {

  late final DataPage _page;
  late final List<ListableModel> _content;
  late final int _pageSize;
  late final PaginatedListIndexCallback? _onElementTap;
  late final PaginatedListIndexCallback? _onPageChangeTap;
  late final bool _isMultiselectList;

  CustomPaginatedList(DataPage page,
      {super.key,
        int? pageSize,
        bool? isMultiselectList,
        PaginatedListIndexCallback? onElementTap,
        PaginatedListIndexCallback? onPageChangeTap}) {
    _page = page;
    _content = page.content as List<ListableModel>;
    _pageSize = pageSize ?? 10;
    _isMultiselectList = isMultiselectList ?? false;
    _onElementTap = onElementTap;
    _onPageChangeTap = onPageChangeTap;
  }

  @override
  State<StatefulWidget> createState() {
    return _CustomPaginatedListState();
  }
}

class _CustomPaginatedListState extends State<CustomPaginatedList> {

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      if (widget._content.isEmpty) ...[
        Text(AppLocalizations.of(context)!.emptyList)
      ] else ...[
        ListView.builder(
            shrinkWrap: true,
            itemCount: widget._content.length,
            itemBuilder: (context, index) {
              return Card(
                  child: ListTile(
                    enabled: widget._onElementTap != null,
                    leading: widget._isMultiselectList ? Checkbox(value: widget._content[index].isSelected, onChanged: (isChecked) {
                      setState(() {
                        widget._content[index].isSelected = isChecked ?? false;
                      });
                      if (widget._onElementTap != null) widget._onElementTap!(index);
              }) : null,
                    title: Text(widget._content[index].title()),
                onTap: () {
                    if (widget._isMultiselectList) {
                      setState(() {
                        widget._content[index].isSelected = !widget._content[index].isSelected;
                      });
                    }
                  if (widget._onElementTap != null) widget._onElementTap!(index);
                },
              ));
            }),
        if (widget._content.length > widget._pageSize) ...[
          SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                      onPressed: (widget._page.pageNumber - 1 <= 0)
                          ? null
                          : () {
                              LoadingOverlay.of(context).show();
                              if (widget._onPageChangeTap != null) widget._onPageChangeTap!(widget._page.pageNumber - 1);
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
                              initialValue: (widget._page.pageNumber + 1).toString(),
                              keyboardType: TextInputType.number,
                              onFieldSubmitted: (value) {
                                if (int.parse(value) < 0 ||
                                    int.parse(value) > widget._page.totalPages) {
                                  return;
                                }
                                LoadingOverlay.of(context).show();
                                if (widget._onPageChangeTap != null) widget._onPageChangeTap!(int.parse(value) - 1);
                              })),
                      const SizedBox(width: 12),
                      Text(AppLocalizations.of(context)!
                          .communityScreen_ofPages(widget._page.totalPages))
                    ],
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                      onPressed: (widget._page.pageNumber + 1 >= widget._page.totalPages)
                          ? null
                          : () {
                              if (widget._page.pageNumber + 1 > widget._page.totalPages) {
                                return;
                              }
                              LoadingOverlay.of(context).show();
                              if (widget._onPageChangeTap != null) widget._onPageChangeTap!(widget._page.pageNumber + 1);
                            },
                      child: const Icon(Icons.navigate_next)),
                ],
              )),
        ]
      ]
    ]);
  }
}
