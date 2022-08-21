import 'package:afro_grids/blocs/service/service_event.dart';
import 'package:afro_grids/blocs/service/service_state.dart';
import 'package:afro_grids/models/service_model.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/service/service_bloc.dart';

class ServiceDropdown extends StatefulWidget {
  final String? initialValue;
  final String? serviceCategoryId;
  final Function(String value) onSelected;
  const ServiceDropdown({Key? key, this.serviceCategoryId, required this.onSelected, this.initialValue}) : super(key: key);

  @override
  State<ServiceDropdown> createState() => _ServiceDropdownState();
}

class _ServiceDropdownState extends State<ServiceDropdown> {
  List<ServiceModel> _services = [];
  String? serviceId;

  @override
  void initState() {
    serviceId = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ServiceBloc>(
      key: Key("${widget.serviceCategoryId}"),
      create: (context)=>ServiceBloc()..add(FetchServiceEvent(widget.serviceCategoryId)),
      child: BlocConsumer<ServiceBloc, ServiceState>(
        listener: (context, state){
          if(state is ServiceLoadedState){
            setState(()=>_services = state.services);
          }
        },
        builder: (context, state){
          return DropdownButton<String>(
              dropdownColor: Colours.tertiary,
              isExpanded: true,
              value: serviceId,
              alignment: Alignment.bottomLeft,
              hint: const Text("Select a service"),
              items: _services.map((service){
                return DropdownMenuItem(
                    value: service.id,
                    child: Text(service.name)
                );
              }).toList(),
              onChanged: (value){
                setState(()=>serviceId=value);
                widget.onSelected(value!);
              }
          );
        },
      ),
    );
  }
}
