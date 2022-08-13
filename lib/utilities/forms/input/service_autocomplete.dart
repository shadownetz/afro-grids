import 'package:afro_grids/utilities/alerts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../../blocs/service/service_bloc.dart';
import '../../../blocs/service/service_event.dart';
import '../../../blocs/service/service_state.dart';
import '../../../models/service_model.dart';
import '../../colours.dart';


class ServiceInput extends StatefulWidget {
  final void Function(ServiceModel service, String? inputText) onSelected;
  final String? serviceCategoryId;
  const ServiceInput({Key? key, this.serviceCategoryId, required this.onSelected}) : super(key: key);

  @override
  State<ServiceInput> createState() => _ServiceInputState();
}

class _ServiceInputState extends State<ServiceInput> {
  List<ServiceModel> _services = [];
  String? inputText;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ServiceBloc>(
      key: Key("${widget.serviceCategoryId}"),
      lazy: false,
      create: (context)=>ServiceBloc()..add(FetchServiceEvent(widget.serviceCategoryId)),
      child: BlocConsumer<ServiceBloc, ServiceState>(
        listener: (context, state){
          if(state is ServiceLoadedState){
            _services = state.services;
          }
          if(state is ServiceErrorState){
            Alerts(context).showToast("AfroGrids is unable to load the services list");
          }
        },
        builder: (context, state){
          return SafeArea(
              child: Autocomplete<ServiceModel>(
                displayStringForOption: (service)=>service.name,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<ServiceModel>.empty();
                  }
                  return _services;
                },
                optionsViewBuilder: (
                    BuildContext context,
                    AutocompleteOnSelected<ServiceModel> onSelected,
                    Iterable<ServiceModel> options
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
                                final ServiceModel option = options.elementAt(index);
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
                      labelText: "Select or enter your service field",
                      hintText: "e.g pharmacy",
                      helperText: "start typing to choose from available options",
                    ),
                    onChanged: (value)=>inputText=value,
                  );
                },
                onSelected: (ServiceModel selection) {
                  widget.onSelected(selection, inputText);
                },
              )
          );
        },
      ),
    );
  }
}
