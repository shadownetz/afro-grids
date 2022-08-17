import 'package:afro_grids/blocs/service/service_bloc.dart';
import 'package:afro_grids/screens/superAdmin/services/add_service_screen.dart';
import 'package:afro_grids/utilities/services/navigation_service.dart';
import 'package:afro_grids/utilities/widgets/button_widget.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../blocs/service/service_event.dart';
import '../../../blocs/service/service_state.dart';
import '../../../utilities/colours.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  ServiceBloc? _serviceProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        title: const Text("Services"),
      ),
      body: CustomLoadingOverlay(
        widget: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context)=>ServiceBloc()..add(FetchServiceEvent(null)))
          ],
          child: BlocConsumer<ServiceBloc, ServiceState>(
            listener: (context, state){
              if(state is ServiceLoadingState){
                context.loaderOverlay.show();
              }else{
                context.loaderOverlay.hide();
              }
            },
            builder: (context, state){
              _serviceProvider = BlocProvider.of<ServiceBloc>(context);
              if(state is ServiceLoadedState){
                if(state.services.isNotEmpty){
                  return ListView(
                    children: state.services.map((service){
                      return ListTile(
                        leading: const Icon(Ionicons.git_branch_outline),
                        title: Text(service.name),
                        subtitle: Text(service.createdAt.toString()),
                      );
                    }).toList(),
                  );
                }
              }
              return Container(
                alignment: Alignment.center,
                child: const Text("There are no available services at this time"),
              );
            },
          ),
        ),
      ),
      floatingActionButton: RoundSMButton(
        onPressed: ()async{
          bool? result = await NavigationService.toPage(const AddServiceScreen());
          if(result == true){
            _serviceProvider!.add(FetchServiceEvent(null));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
