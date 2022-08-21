import 'package:afro_grids/models/service_model.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:afro_grids/utilities/forms/input/service_category_dropdown.dart';
import 'package:afro_grids/utilities/forms/input/service_type_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/service/service_bloc.dart';
import '../../../blocs/service/service_event.dart';
import '../../../blocs/service/service_state.dart';
import '../../../main.dart';
import '../../widgets/button_widget.dart';
import '../input/service_dropdown.dart';

class AddServiceForm extends StatefulWidget {
  final Function(ServiceModel service) onComplete;
  const AddServiceForm({
    Key? key,
    required this.onComplete
  }) : super(key: key);

  @override
  State<AddServiceForm> createState() => _AddServiceFormState();
}

class _AddServiceFormState extends State<AddServiceForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _serviceCategoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              cursorHeight: 20,
              validator: (value){
                if(value != null){
                  if(value.isNotEmpty){
                    return null;
                  }
                }
                return "Enter a valid service name";
              },
              decoration: const InputDecoration(
                labelText: "Service name",
                hintText: "Minter",
              ),
            ),
            const SizedBox(height: 10,),
            ServiceCategoryDropdown(
                onSelected: (categoryId){
                  _serviceCategoryController.text = categoryId;
                }
            ),
            const SizedBox(height: 50,),
            ElevatedButton(
                style: buttonPrimarySmStyle(),
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    if(_serviceCategoryController.text.isNotEmpty){
                      widget.onComplete(
                          ServiceModel(
                              id: "",
                              name: _nameController.text,
                              serviceCategoryId: _serviceCategoryController.text,
                              createdAt: DateTime.now()
                          )
                      );
                    }else{
                      Alerts(context).showToast("Select a service category");
                    }
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.save, size: 20,),
                    SizedBox(width: 10,),
                    Text("Save", style: TextStyle(fontSize: 20,),)
                  ],
                )
            )
          ],
        )
    );
  }
}

class UpdateProviderServiceForm extends StatefulWidget {
  final void Function(String? serviceId, String serviceType) onUpdated;
  const UpdateProviderServiceForm({Key? key,required this.onUpdated}) : super(key: key);

  @override
  State<UpdateProviderServiceForm> createState() => _UpdateProviderServiceFormState();
}

class _UpdateProviderServiceFormState extends State<UpdateProviderServiceForm> {
  ServiceModel? _userService;
  String? _selectedServiceCategory;
  String? _selectedServiceId = localStorage.user!.serviceId;
  String _selectedServiceType = localStorage.user!.serviceType;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context)=>ServiceBloc()..add(GetServiceEvent(localStorage.user!.serviceId)))
        ],
        child: BlocListener<ServiceBloc, ServiceState>(
          listener: (context, state){
            if(state is ServiceLoadedState){
              setState((){
                _userService=state.service;
                _selectedServiceCategory = _userService?.serviceCategoryId;
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Service Category", style: TextStyle(fontSize: 17),),
                  SizedBox(width: 20,),
                  Expanded(
                      child: ServiceCategoryDropdown(
                        key: Key("${_userService?.serviceCategoryId}"),
                        initialValue: _userService?.serviceCategoryId,
                        onSelected: (String value) {
                         setState((){
                           _selectedServiceCategory = value;
                           _selectedServiceId = null;
                         });
                        },
                      )
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("Service", style: TextStyle(fontSize: 17),),
                  const SizedBox(width: 20,),
                  Expanded(
                      child: ServiceDropdown(
                        key: Key("$_selectedServiceCategory"),
                        serviceCategoryId: _selectedServiceCategory??_userService?.serviceCategoryId,
                        initialValue: _selectedServiceId,
                        onSelected: (String value) {
                          _selectedServiceId = value;
                          widget.onUpdated(_selectedServiceId, _selectedServiceType);
                        },
                      )
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("Service Type", style: TextStyle(fontSize: 17),),
                  const SizedBox(width: 20,),
                  Expanded(
                      child: ServiceTypeDropdown(
                        initialValue: _selectedServiceType,
                        onChanged: (value){
                          setState(()=>_selectedServiceType = value);
                          widget.onUpdated(_selectedServiceId, _selectedServiceType);
                        },
                      )
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
