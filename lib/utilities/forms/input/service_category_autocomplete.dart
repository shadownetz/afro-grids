import 'package:afro_grids/blocs/serviceCategory/service_category_bloc.dart';
import 'package:afro_grids/blocs/serviceCategory/service_category_event.dart';
import 'package:afro_grids/blocs/serviceCategory/service_category_state.dart';
import 'package:afro_grids/models/service_category_model.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../colours.dart';


class ServiceCategoryInput extends StatefulWidget {
  final void Function(ServiceCategoryModel serviceCategory, String? inputText) onSelected;
  const ServiceCategoryInput({Key? key, required this.onSelected}) : super(key: key);

  @override
  State<ServiceCategoryInput> createState() => _ServiceCategoryInputState();
}

class _ServiceCategoryInputState extends State<ServiceCategoryInput> {
  List<ServiceCategoryModel> _serviceCategories = [];
  String? inputText;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ServiceCategoryBloc>(
      create: (context)=>ServiceCategoryBloc()..add(FetchServiceCategoryEvent()),
      child: BlocBuilder<ServiceCategoryBloc, ServiceCategoryState>(
        builder: (context, state){
          if(state is ServiceCategoryLoadedState){
            _serviceCategories = state.serviceCategories;
          }
          if(state is ServiceCategoryErrorState){
            Alerts(context).showToast("AfroGrids is unable to load the service categories");
          }
          return SafeArea(
              child: Autocomplete<ServiceCategoryModel>(
                displayStringForOption: (service)=>service.name,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<ServiceCategoryModel>.empty();
                  }
                  return _serviceCategories;
                },
                optionsViewBuilder: (
                    BuildContext context,
                    AutocompleteOnSelected<ServiceCategoryModel> onSelected,
                    Iterable<ServiceCategoryModel> options
                    ) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 330,
                      height: 400,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.black26,blurRadius: 5)
                          ]
                      ),
                      child: Material(
                          color: Colours.tertiary,
                          elevation: 20,
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: options.length,
                              separatorBuilder: (context, i) {
                                return Divider();
                              },
                              itemBuilder: (BuildContext context, int index) {
                                final ServiceCategoryModel option = options.elementAt(index);
                                return GestureDetector(
                                    onTap: () {
                                      onSelected(option);
                                    },
                                    child: ListTile(
                                      minLeadingWidth: 20,
                                      dense: true,
                                      visualDensity: const VisualDensity(vertical: -3, horizontal: -4),
                                      leading: const Icon(Ionicons.bookmark_outline, color: Colours.primary,),
                                      title: Text(option.name, style: const TextStyle(color: Colours.primary, fontSize: 18)),
                                      // subtitle: Text(option.structuredFormatting?.secondaryText??"", style: const TextStyle(color: Colours.primary)),
                                    )
                                );
                              },
                            ),
                          )
                      ),
                    ),
                  );
                },
                fieldViewBuilder: (
                    BuildContext context,
                    TextEditingController fieldTextEditingController,
                    FocusNode fieldFocusNode,
                    VoidCallback onFieldSubmitted
                    ) {
                  return TextField(
                    controller: fieldTextEditingController,
                    focusNode: fieldFocusNode,
                    decoration: const InputDecoration(
                      labelText: "Select or enter your service category",
                      hintText: "e.g fashion",
                      helperText: "start typing to choose from available options",
                    ),
                    onChanged: (value)=>inputText=value,
                  );
                },
                onSelected: (ServiceCategoryModel selection) {
                  widget.onSelected(selection, inputText);
                },
              )
          );
        },
      ),
    );
  }
}
