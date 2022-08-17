import 'package:afro_grids/blocs/service/service_bloc.dart';
import 'package:afro_grids/blocs/service/service_event.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../blocs/service/service_state.dart';
import '../../../utilities/colours.dart';
import '../../../utilities/forms/models/service_forms.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({Key? key}) : super(key: key);

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        title: const Text("Add a new Service"),
      ),
      body: CustomLoadingOverlay(
        widget: Container(
          padding: const EdgeInsets.all(10),
          child: BlocProvider<ServiceBloc>(
            create: (context)=>ServiceBloc(),
            child: BlocConsumer<ServiceBloc, ServiceState>(
              listener: (context, state){
                if(state is ServiceLoadingState){
                  context.loaderOverlay.show();
                }else{
                  context.loaderOverlay.hide();
                }
                if(state is ServiceLoadedState){
                  Alerts(context).showToast("Operation successful");
                  Navigator.of(context).pop(true);
                }
              },
              builder: (context, state){
                return AddServiceForm(
                    onComplete: (service){
                      BlocProvider.of<ServiceBloc>(context).add(AddServiceEvent(service));
                    }
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
