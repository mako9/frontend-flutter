import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:frontend_flutter/model/data_page.dart';
import 'package:frontend_flutter/widget/community/community_cubit.dart';
import 'package:frontend_flutter/widget/element/custom_button.dart';
import 'package:frontend_flutter/widget/element/custom_picker.dart';

import '../../model/community.dart';
import '../../model/data_response.dart';
import '../../model/item.dart';
import '../../util/date_util.dart';
import '../element/custom_image.dart';
import '../element/custom_text_form_field.dart';
import '../element/loading_overlay.dart';
import 'item_edit_cubit.dart';

class ItemEditScreen extends StatelessWidget {
  late final Item? _initialItem;

  ItemEditScreen({Key? key, Item? item}) : super(key: key) {
    _initialItem = item;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) =>
                ItemEditCubit.ofInitialState(item: _initialItem)),
        BlocProvider(
            create: (BuildContext context) => CommunityCubit.ofInitialState()),
      ],
      child: LoadingOverlay(child: _ItemEditScreenStateful()),
    );
  }
}

class _ItemEditScreenStateful extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ItemEditScreenState();
  }
}

class _ItemEditScreenState extends State<_ItemEditScreenStateful> {
  final _nameController = TextEditingController();
  final _streetController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isActive = true;
  Item? _item;
  DataPage<Community>? _communityPage;
  String? _errorMessage;
  final Map<ItemCategory, bool> _selectedCategories = {};
  int _selectedCommunity = 0;
  DateTime? _selectedDate;
  Uint8List? _imageData;

  _ItemEditScreenState() {
    for (var element in ItemCategory.values) {
      _selectedCategories[element] = false;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    if (pickedDate != _selectedDate) {
      setState(() {
        if (pickedDate != null) _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<ItemEditCubit, DataResponse<Item>>(
              listener: (context, state) {
            setState(() {
              _item = state.data;
              _imageData = state.data?.imageData;
              if (_item?.description != null) {
                _descriptionController.text = _item!.description!;
              }
              for (var element in _item?.itemCategories ?? []) {
                _selectedCategories[element] = true;
              }
              _errorMessage = state.errorMessage;
            });
          }),
          BlocListener<CommunityCubit, DataResponse<DataPage<Community>>>(
              listener: (context, state) {
            setState(() {
              _communityPage = state.data;
              if (_errorMessage != null) _errorMessage = state.errorMessage;
            });
          }),
        ],
        child: StatefulBuilder(builder: (context, setState) {
          LoadingOverlay.of(context).hide();
          return PlatformScaffold(
              appBar: PlatformAppBar(
                title: PlatformText(_item == null
                    ? AppLocalizations.of(context)!.itemEditScreen_title_create
                    : AppLocalizations.of(context)!.itemEditScreen_title_edit),
              ),
              body: Container(
                  padding: const EdgeInsets.all(30.0),
                  alignment: Alignment.topCenter,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(child:
                        SingleChildScrollView(
                            child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                          children: [
                                            CustomImage(_imageData, showDefault: false),
                                        PlatformIconButton(
                                          icon: const Icon(Icons.add_a_photo),
                                          onPressed: (() async {
                                            final imageData = await context
                                                .read<ItemEditCubit>()
                                                .pickFiles();
                                            setState(() {
                                              _imageData = imageData;
                                            });
                                          }),
                                        ),
                                      ]),
                              Row(children: [
                                CustomTextFormField(
                                    AppLocalizations.of(context)!.name,
                                    initialValue: _item?.name,
                                    controller: _nameController),
                              ]),
                              Row(
                                children: [
                                  CustomTextFormField(
                                      AppLocalizations.of(context)!.street,
                                      initialValue: _item?.street,
                                      controller: _streetController),
                                  CustomTextFormField(
                                      AppLocalizations.of(context)!.houseNumber,
                                      initialValue: _item?.houseNumber,
                                      controller: _houseNumberController),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomTextFormField(
                                      AppLocalizations.of(context)!.postalCode,
                                      initialValue: _item?.postalCode,
                                      controller: _postalCodeController),
                                  CustomTextFormField(
                                      AppLocalizations.of(context)!.city,
                                      initialValue: _item?.city,
                                      controller: _cityController),
                                ],
                              ),
                              const SizedBox(height: 24),
                              for (var category
                                  in _selectedCategories.keys) ...[
                                Row(
                                  children: [
                                    PlatformText(
                                      category.getName(context),
                                      style: const TextStyle(fontSize: 12.0),
                                    ),
                                    const Spacer(),
                                    PlatformSwitch(
                                        activeColor: Colors.brown[300],
                                        value: _selectedCategories[category] ??
                                            false,
                                        onChanged: (selected) {
                                          setState(() {
                                            _selectedCategories[category] =
                                                selected;
                                          });
                                        })
                                  ],
                                )
                              ],
                              const SizedBox(height: 24),
                              Row(children: [
                                PlatformText(
                                  AppLocalizations.of(context)!
                                      .itemEditScreen_isActive,
                                  style: const TextStyle(fontSize: 12.0),
                                ),
                                const SizedBox(height: 24),
                                PlatformSwitch(
                                    activeColor: Colors.brown[300],
                                    value: _isActive,
                                    onChanged: (value) {
                                      setState(() {
                                        _isActive = value;
                                      });
                                    }),
                              ]),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  PlatformText(
                                    AppLocalizations.of(context)!
                                        .itemEditScreen_selectedCommunity,
                                    style: const TextStyle(fontSize: 12.0),
                                  ),
                                  const Spacer(),
                                  if (_communityPage?.content.isNotEmpty ==
                                      true) ...[
                                    CustomPicker(
                                        _communityPage?.content
                                                .map((e) => e.name!)
                                                .toList() ??
                                            List.empty(), (index) {
                                      _selectedCommunity = index;
                                    }),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 24),
                              PlatformTextFormField(
                                controller: _descriptionController,
                                maxLines: 5,
                                hintText: AppLocalizations.of(context)!
                                    .itemEditScreen_descriptionHint,
                              ),
                              const SizedBox(height: 24),
                              Row(children: [
                                PlatformText(AppLocalizations.of(context)!
                                    .itemEditScreen_availableUntil),
                                const Spacer(),
                                PlatformTextButton(
                                    color: Colors.brown[300],
                                    onPressed: () => _selectDate(context),
                                    child: PlatformText(
                                        DateUtil.toDateString(_selectedDate) ??
                                            DateUtil.toDateString(
                                                _item?.availableUntil) ??
                                            '-')),
                              ]),
                            ]))),
                        const SizedBox(height: 24),
                        if (_errorMessage != null) ...[
                          PlatformText(
                            AppLocalizations.of(context)!
                                .errorMessage(_errorMessage!),
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 24),
                        ],
                        CustomButton(
                            AppLocalizations.of(context)!.save, Icons.save,
                            () async {
                          final updatedItem = Item(
                            uuid: _item?.uuid,
                            name: _nameController.text,
                            itemCategories: _selectedCategories.entries
                                .where((element) => element.value)
                                .map((e) => e.key)
                                .toList(),
                            street: _streetController.text,
                            houseNumber: _houseNumberController.text,
                            postalCode: _postalCodeController.text,
                            city: _cityController.text,
                            isActive: _isActive,
                            communityUuid: _communityPage
                                ?.content[_selectedCommunity].uuid,
                            availableUntil: _selectedDate,
                            description: _descriptionController.text,
                          );
                          LoadingOverlay.of(context).show();
                          if (_item == null) {
                            await context
                                .read<ItemEditCubit>()
                                .createItem(updatedItem);
                          } else {
                            await context
                                .read<ItemEditCubit>()
                                .updateItem(updatedItem);
                          }
                          if (mounted) {
                            LoadingOverlay.of(context).hide();
                            Navigator.pop(context);
                          }
                        }),
                        if (_item != null) ...[
                          const SizedBox(height: 16),
                          CustomButton(
                              AppLocalizations.of(context)!
                                  .itemEditScreen_delete,
                              Icons.delete, () async {
                            LoadingOverlay.of(context).show();
                            await context
                                .read<ItemEditCubit>()
                                .deleteItem(_item!);
                            if (mounted) {
                              LoadingOverlay.of(context).hide();
                              Navigator.pop(context);
                            }
                          }),
                        ],
                      ])));
        }));
  }
}
