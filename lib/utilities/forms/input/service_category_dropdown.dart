import 'package:afro_grids/blocs/serviceCategory/service_category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/serviceCategory/service_category_event.dart';
import '../../../blocs/serviceCategory/service_category_state.dart';
import '../../../models/service_category_model.dart';

class ServiceCategoryDropdown extends StatefulWidget {
  final Function(String value) onSelected;
  const ServiceCategoryDropdown({Key? key, required this.onSelected}) : super(key: key);

  @override
  State<ServiceCategoryDropdown> createState() => _ServiceCategoryDropdownState();
}

class _ServiceCategoryDropdownState extends State<ServiceCategoryDropdown> {
  List<ServiceCategoryModel> _serviceCategories = [];
  String? categoryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ServiceCategoryBloc>(
      create: (context)=>ServiceCategoryBloc()..add(FetchServiceCategoryEvent()),
      child: BlocBuilder<ServiceCategoryBloc, ServiceCategoryState>(
        builder: (context, state){
          if(state is ServiceCategoryLoadedState){
            _serviceCategories = state.serviceCategories;
          }
          return DropdownButton<String>(
              isExpanded: true,
              value: categoryId,
              alignment: Alignment.bottomLeft,
              hint: const Text("Select a service category"),
              items: _serviceCategories.map((category){
                return DropdownMenuItem(
                    value: category.id,
                    child: Text(category.name)
                );
              }).toList(),
              onChanged: (value){
                setState(()=>categoryId=value??"");
                widget.onSelected(value??"");
              }
          );
        },
      ),
    );
  }
}
